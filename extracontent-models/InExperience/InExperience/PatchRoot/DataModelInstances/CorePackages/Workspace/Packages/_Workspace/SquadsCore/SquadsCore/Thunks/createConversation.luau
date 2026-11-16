local SquadsCore = script:FindFirstAncestor("SquadsCore")

local HttpService = game:GetService("HttpService")

local SquadPromptType = require(SquadsCore.Enums.SquadPromptType)

return function(data)
	return function(object)
		object:dispatch(data.squadContext.createConversation(data.conversationType, data.userIds, nil, data.source)):andThen(function(p)
			if data.onSuccessCallback then
				data.onSuccessCallback(p.id)
			end
		end):catch(function(p)
			local success, result = pcall(function()
				return HttpService:JSONDecode(p.Body)
			end)

			local setSquadPrompt = data.squadContext.setSquadPrompt
			local promptType

			if success and result and result.reason_code == "participant_chat_disabled" then
				promptType = SquadPromptType.ParticipantChatDisabled
			else
				promptType = SquadPromptType.Error
			end

			setSquadPrompt(object, { hideCancelButton = true, promptType = promptType })

			if data.onErrorCallback then
				data.onErrorCallback()
			end
		end)
	end
end
