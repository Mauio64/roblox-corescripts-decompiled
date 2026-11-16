local HttpService = game:GetService("HttpService")

local SquadPromptType = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadPromptType")

return function(data)
	return function(object)
		object:dispatch(data.squadContext.createConversation(
			data.conversationType,
			data.userIds,
			nil,
			data.source
		)):andThen(function(p2)
			if data.onSuccessCallback then
				data.onSuccessCallback(p2.id)
			end
		end):catch(function(p2)
			local success, result = pcall(function()
				return HttpService:JSONDecode(p2.Body)
			end)

			local setSquadPrompt = data.squadContext.setSquadPrompt

			local v7 = if success and result and result.reason_code == "participant_chat_disabled" then SquadPromptType.ParticipantChatDisabled else SquadPromptType.Error
			setSquadPrompt(object, { hideCancelButton = true, promptType = v7 })

			if data.onErrorCallback then
				data.onErrorCallback()
			end
		end)
	end
end
