local logInExpCoplayTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Analytics/logInExpCoplayTelemetry")
local SquadCoplayJoin = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadCoplayJoin")
require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadLocationEnum")
local SquadPromptType = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadPromptType")
local NetworkingSquads = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Http/NetworkingSquads")

return function(p2, callback, p3, p4, p5, onConfirm, p6)
	return function(object)
		return object:dispatch(NetworkingSquads.CreateOrJoinSquad.API({
			parentChannelId = p2,
			leaveExisting = true,
			squadLocation = p4,
			partyAttemptId = p5,
			scheduledSquadId = p6
		})):andThen(function(p7)
			local groupUpId = p7.responseBody.groupUp.groupUpId
			local members = p7.responseBody.groupUp.members

			if groupUpId and members then
				logInExpCoplayTelemetry(groupUpId, members, p4, SquadCoplayJoin.PartyJoin, p3)
			end
		end):catch(function(p7)
			callback(object, {
				hideCancelButton = true,
				promptType = SquadPromptType.Error,
				onConfirm = onConfirm
			})
		end)
	end
end
