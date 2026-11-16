local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local leaveSquad = require(script.Parent.leaveSquad)

local logInExpCoplayTelemetry = require(SquadsCore.Analytics.logInExpCoplayTelemetry)
local SquadCoplayJoin = require(SquadsCore.Enums.SquadCoplayJoin)
require(SquadsCore.Enums.SquadLocationEnum)
local SquadPromptType = require(SquadsCore.Enums.SquadPromptType)
local NetworkingSquads = require(SquadsCore.Http.NetworkingSquads)

local Promise = require(parent.Promise)
local SharedFlags = require(parent.SharedFlags)

local FFlagPartyDevAPIToRespectThirdPartySettingsEnabled = SharedFlags.FFlagPartyDevAPIToRespectThirdPartySettingsEnabled

return function(p: string, callback, callback2, p2, flag: boolean)
	return function(object)
		local state = object:getState()
		local squadId = state.Squad
			and state.Squad.Squad
			and state.Squad.Squad.currentSquad
			and state.Squad.Squad.currentSquad.squadId

		if squadId == p then
			callback(object, { hideCancelButton = true, promptType = SquadPromptType.AlreadyJoined })

			return Promise.resolve({})
		end

		if squadId then
			return object:dispatch(leaveSquad(SquadPromptType.JoinAnotherSquad, callback, function()
				local squadId2 = p
				local v = callback
				local v2 = callback2
				local squadLocation = p2
				object:dispatch(function(object2)
					return object2:dispatch(NetworkingSquads.JoinSquad.API({
						squadId = squadId2,
						leaveExisting = true,
						squadLocation = squadLocation
					})):andThen(function(p3)
						local groupUpId = p3.responseBody.groupUp.groupUpId
						local members = p3.responseBody.groupUp.members

						if groupUpId and members then
							logInExpCoplayTelemetry(groupUpId, members, squadLocation, SquadCoplayJoin.PartyJoin, v2)
						end
					end):catch(function(_)
						v(object2, { hideCancelButton = true, promptType = SquadPromptType.Error })
					end)
				end)
			end, p2, not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or flag))
		end

		local squadId2 = p
		local v = callback
		local v2 = callback2
		local squadLocation = p2
		return object:dispatch(function(object2)
			return object2:dispatch(NetworkingSquads.JoinSquad.API({
				squadId = squadId2,
				leaveExisting = true,
				squadLocation = squadLocation
			})):andThen(function(p3)
				local groupUpId = p3.responseBody.groupUp.groupUpId
				local members = p3.responseBody.groupUp.members

				if groupUpId and members then
					logInExpCoplayTelemetry(groupUpId, members, squadLocation, SquadCoplayJoin.PartyJoin, v2)
				end
			end):catch(function(_)
				v(object2, { hideCancelButton = true, promptType = SquadPromptType.Error })
			end)
		end)
	end
end
