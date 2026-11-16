local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local leaveSquad = require(script.Parent.leaveSquad)

local Constants = require(SquadsCore.Common.Constants)
local logInExpCoplayTelemetry = require(SquadsCore.Analytics.logInExpCoplayTelemetry)
local SquadCoplayJoin = require(SquadsCore.Enums.SquadCoplayJoin)
require(SquadsCore.Enums.SquadLocationEnum)
local SquadPromptType = require(SquadsCore.Enums.SquadPromptType)
local NetworkingSquads = require(SquadsCore.Http.NetworkingSquads)

local Promise = require(parent.Promise)
local SharedFlags = require(parent.SharedFlags)

local FFlagPartyDevAPIToRespectThirdPartySettingsEnabled = SharedFlags.FFlagPartyDevAPIToRespectThirdPartySettingsEnabled

return function(p: string, p2: string, flag: boolean, callback, callback2, p3, flag2: boolean, p4: string?, p5: string?)
	return function(object)
		local state = object:getState()
		local squadId = state.Squad
			and state.Squad.Squad
			and state.Squad.Squad.currentSquad
			and state.Squad.Squad.currentSquad.squadId

		if squadId and squadId ~= "" and flag then
			return Promise.new(function(p6, p7)
				object:dispatch(leaveSquad(SquadPromptType.JoinAnotherSquad, callback, function()
					local action = p
					local nudgeId = p2
					local v = callback
					local v2 = callback2
					local squadLocation = p3
					local partyAttemptId = p4
					local parentChannelId = p5
					object:dispatch(function(object2)
						return object2:dispatch(NetworkingSquads.ActOnPartyNudge.API({
							action = action,
							nudgeId = nudgeId,
							leaveExisting = true,
							partyAttemptId = partyAttemptId,
							squadLocation = squadLocation,
							parentChannelId = parentChannelId
						})):andThen(function(p8)
							if
								action == Constants.ACCEPT_START_PARTY_REQUEST_ACTION
								or action == Constants.ACCEPT_PARTY_INVITE_ACTION
							then
								local groupUpId = p8.responseBody.groupUp.groupUpId
								local members = p8.responseBody.groupUp.members

								if groupUpId and members then
									local v3

									if action == Constants.ACCEPT_START_PARTY_REQUEST_ACTION then
										v3 = SquadCoplayJoin.SquadNudgeCreation
									else
										v3 = SquadCoplayJoin.SquadNudgeJoin
									end

									logInExpCoplayTelemetry(groupUpId, members, squadLocation, v3, v2)
								end
							end
						end):catch(function(_)
							if
								action == Constants.ACCEPT_START_PARTY_REQUEST_ACTION
								or action == Constants.ACCEPT_PARTY_INVITE_ACTION
							then
								v(object2, {
									hideCancelButton = true,
									promptType = SquadPromptType.Error
								})
							end
						end)
					end):andThen(p6):catch(p7)
				end, p3, not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or flag2))
			end)
		end

		local action = p
		local nudgeId = p2
		local v = callback
		local v2 = callback2
		local squadLocation = p3
		local partyAttemptId = p4
		local parentChannelId = p5
		return object:dispatch(function(object2)
			return object2:dispatch(NetworkingSquads.ActOnPartyNudge.API({
				action = action,
				nudgeId = nudgeId,
				leaveExisting = true,
				partyAttemptId = partyAttemptId,
				squadLocation = squadLocation,
				parentChannelId = parentChannelId
			})):andThen(function(p6)
				if
					action == Constants.ACCEPT_START_PARTY_REQUEST_ACTION
					or action == Constants.ACCEPT_PARTY_INVITE_ACTION
				then
					local groupUpId = p6.responseBody.groupUp.groupUpId
					local members = p6.responseBody.groupUp.members

					if groupUpId and members then
						local v3

						if action == Constants.ACCEPT_START_PARTY_REQUEST_ACTION then
							v3 = SquadCoplayJoin.SquadNudgeCreation
						else
							v3 = SquadCoplayJoin.SquadNudgeJoin
						end

						logInExpCoplayTelemetry(groupUpId, members, squadLocation, v3, v2)
					end
				end
			end):catch(function(_)
				if
					action == Constants.ACCEPT_START_PARTY_REQUEST_ACTION
					or action == Constants.ACCEPT_PARTY_INVITE_ACTION
				then
					v(object2, { hideCancelButton = true, promptType = SquadPromptType.Error })
				end
			end)
		end)
	end
end
