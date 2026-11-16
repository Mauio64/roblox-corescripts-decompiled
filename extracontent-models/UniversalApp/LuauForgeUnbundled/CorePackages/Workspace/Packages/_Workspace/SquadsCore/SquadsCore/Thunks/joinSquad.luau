local leaveSquad = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Thunks/leaveSquad")

local logInExpCoplayTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Analytics/logInExpCoplayTelemetry")
local SquadCoplayJoin = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadCoplayJoin")
require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadLocationEnum")
local SquadPromptType = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadPromptType")
local NetworkingSquads = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Http/NetworkingSquads")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Promise")
local fFlagPartyDevAPIToRespectThirdPartySettingsEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SharedFlags").FFlagPartyDevAPIToRespectThirdPartySettingsEnabled

return function(p2, callback, p3, p4, p5)
	return function(object)
		local state = object:getState()
		local squadId = state.Squad
			and state.Squad.Squad
			and state.Squad.Squad.currentSquad
			and state.Squad.Squad.currentSquad.squadId

		if squadId == p2 then
			callback(object, {
				hideCancelButton = true,
				promptType = SquadPromptType.AlreadyJoined
			})

			return Promise.resolve({})
		end

		if squadId then
			return object:dispatch(leaveSquad(SquadPromptType.JoinAnotherSquad, callback, function()
				local v5 = p2
				local v6 = callback
				local v7 = p3
				local v8 = p4
				object:dispatch(function(object2)
					return object2:dispatch(NetworkingSquads.JoinSquad.API({
						squadId = v5,
						leaveExisting = true,
						squadLocation = v8
					})):andThen(function(p6)
						local groupUpId = p6.responseBody.groupUp.groupUpId
						local members = p6.responseBody.groupUp.members

						if groupUpId and members then
							logInExpCoplayTelemetry(groupUpId, members, v8, SquadCoplayJoin.PartyJoin, v7)
						end
					end):catch(function(p6)
						v6(object2, {
							hideCancelButton = true,
							promptType = SquadPromptType.Error
						})
					end)
				end)
			end, p4, not fFlagPartyDevAPIToRespectThirdPartySettingsEnabled or p5))
		end

		local v5 = p2
		local v6 = callback
		local v7 = p3
		local v8 = p4
		return object:dispatch(function(object2)
			return object2:dispatch(NetworkingSquads.JoinSquad.API({
				squadId = v5,
				leaveExisting = true,
				squadLocation = v8
			})):andThen(function(p6)
				local groupUpId = p6.responseBody.groupUp.groupUpId
				local members = p6.responseBody.groupUp.members

				if groupUpId and members then
					logInExpCoplayTelemetry(groupUpId, members, v8, SquadCoplayJoin.PartyJoin, v7)
				end
			end):catch(function(p6)
				v6(object2, { hideCancelButton = true, promptType = SquadPromptType.Error })
			end)
		end)
	end
end
