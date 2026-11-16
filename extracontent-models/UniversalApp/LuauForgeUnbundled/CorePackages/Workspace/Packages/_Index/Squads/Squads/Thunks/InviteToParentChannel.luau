local HttpService = game:GetService("HttpService")

local squadPromptType = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Enums").SquadPromptType

return function(data)
	return function(p2)
		return data.squadExternalContext.inviteToParentChannel(
			data.dispatch,
			data.parentChannel,
			data.userIds
		):andThen(function(p3)
			if data.onSuccessCallback then
				data.onSuccessCallback(p3)
			end
		end):catch(function(p3)
			local success, result = pcall(function()
				return HttpService:JSONDecode(p3.Body)
			end)

			local setSquadPrompt = data.squadExternalContext.setSquadPrompt

			local v7 = if success and result and result.reason_code == "participant_chat_disabled" then squadPromptType.ParticipantChatDisabled else squadPromptType.Error
			setSquadPrompt(p2, { hideCancelButton = true, promptType = v7 })

			if data.onErrorCallback then
				data.onErrorCallback()
			end
		end)
	end
end
