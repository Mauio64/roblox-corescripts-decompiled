local SquadsCore = script:FindFirstAncestor("SquadsCore")

local logInExpCoplayTelemetry = require(SquadsCore.Analytics.logInExpCoplayTelemetry)
local SquadCoplayJoin = require(SquadsCore.Enums.SquadCoplayJoin)
require(SquadsCore.Enums.SquadLocationEnum)
local SquadPromptType = require(SquadsCore.Enums.SquadPromptType)
local NetworkingSquads = require(SquadsCore.Http.NetworkingSquads)

return function(parentChannelId: string, callback, callback2, squadLocation, partyAttemptId: string?, onConfirm, scheduledSquadId: string?)
	return function(object)
		return object:dispatch(NetworkingSquads.CreateOrJoinSquad.API({
			parentChannelId = parentChannelId,
			leaveExisting = true,
			squadLocation = squadLocation,
			partyAttemptId = partyAttemptId,
			scheduledSquadId = scheduledSquadId
		})):andThen(function(p)
			local groupUpId = p.responseBody.groupUp.groupUpId
			local members = p.responseBody.groupUp.members

			if groupUpId and members then
				logInExpCoplayTelemetry(groupUpId, members, squadLocation, SquadCoplayJoin.PartyJoin, callback2)
			end
		end):catch(function(_)
			callback(object, {
				hideCancelButton = true,
				promptType = SquadPromptType.Error,
				onConfirm = onConfirm
			})
		end)
	end
end
