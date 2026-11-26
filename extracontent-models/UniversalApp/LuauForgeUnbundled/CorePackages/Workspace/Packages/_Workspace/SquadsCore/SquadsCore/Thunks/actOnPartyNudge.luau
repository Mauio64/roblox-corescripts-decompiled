local leaveSquad = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Thunks/leaveSquad")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants")
local logInExpCoplayTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Analytics/logInExpCoplayTelemetry")
local SquadCoplayJoin = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadCoplayJoin")
require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadLocationEnum")
local SquadPromptType = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadPromptType")
local NetworkingSquads = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Http/NetworkingSquads")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Promise")
local fFlagPartyDevAPIToRespectThirdPartySettingsEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SharedFlags").FFlagPartyDevAPIToRespectThirdPartySettingsEnabled

return function(p2, p3, p4, p5, p6, p7, p8, p9, p10)
	return function(object)
		local state = object:getState()
		local squadId = state.Squad
			and state.Squad.Squad
			and state.Squad.Squad.currentSquad
			and state.Squad.Squad.currentSquad.squadId

		if squadId and squadId ~= "" and p4 then
			return Promise.new(function(p11, p12)
				object:dispatch(leaveSquad(SquadPromptType.JoinAnotherSquad, p5, function()
					local v5 = p2
					local v6 = p3
					local v7 = p5
					local v8 = p6
					local v9 = p7
					local v10 = p9
					local v11 = p10
					object:dispatch(function(object2)
						return object2:dispatch(NetworkingSquads.ActOnPartyNudge.API({
							action = v5,
							nudgeId = v6,
							leaveExisting = true,
							partyAttemptId = v10,
							squadLocation = v9,
							parentChannelId = v11
						})):andThen(function(p13)
							if
								v5 == Constants.ACCEPT_START_PARTY_REQUEST_ACTION
								or v5 == Constants.ACCEPT_PARTY_INVITE_ACTION
							then
								local groupUpId = p13.responseBody.groupUp.groupUpId
								local members = p13.responseBody.groupUp.members

								if groupUpId and members then
									local v12 = if v5 == Constants.ACCEPT_START_PARTY_REQUEST_ACTION then SquadCoplayJoin.SquadNudgeCreation else SquadCoplayJoin.SquadNudgeJoin

									logInExpCoplayTelemetry(groupUpId, members, v9, v12, v8)
								end
							end
						end):catch(function(p13)
							if
								v5 == Constants.ACCEPT_START_PARTY_REQUEST_ACTION
								or v5 == Constants.ACCEPT_PARTY_INVITE_ACTION
							then
								v7(object2, {
									hideCancelButton = true,
									promptType = SquadPromptType.Error
								})
							end
						end)
					end):andThen(p11):catch(p12)
				end, p7, not fFlagPartyDevAPIToRespectThirdPartySettingsEnabled or p8))
			end)
		end

		local v5 = p2
		local v6 = p3
		local v7 = p5
		local v8 = p6
		local v9 = p7
		local v10 = p9
		local v11 = p10
		return object:dispatch(function(object2)
			return object2:dispatch(NetworkingSquads.ActOnPartyNudge.API({
				action = v5,
				nudgeId = v6,
				leaveExisting = true,
				partyAttemptId = v10,
				squadLocation = v9,
				parentChannelId = v11
			})):andThen(function(p11)
				if
					v5 == Constants.ACCEPT_START_PARTY_REQUEST_ACTION
					or v5 == Constants.ACCEPT_PARTY_INVITE_ACTION
				then
					local groupUpId = p11.responseBody.groupUp.groupUpId
					local members = p11.responseBody.groupUp.members

					if groupUpId and members then
						local v12 = if v5 == Constants.ACCEPT_START_PARTY_REQUEST_ACTION then SquadCoplayJoin.SquadNudgeCreation else SquadCoplayJoin.SquadNudgeJoin

						logInExpCoplayTelemetry(groupUpId, members, v9, v12, v8)
					end
				end
			end):catch(function(p11)
				if
					v5 == Constants.ACCEPT_START_PARTY_REQUEST_ACTION
					or v5 == Constants.ACCEPT_PARTY_INVITE_ACTION
				then
					v7(object2, { hideCancelButton = true, promptType = SquadPromptType.Error })
				end
			end)
		end)
	end
end
