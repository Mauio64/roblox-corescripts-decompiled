local parent = script:FindFirstAncestor("Squads").Parent

local HttpService = game:GetService("HttpService")

local Enums = require(parent.SquadsCore.Enums)
local SquadPromptType = Enums.SquadPromptType

return function(data)
	return function(p)
		return data.squadExternalContext.inviteToParentChannel(data.dispatch, data.parentChannel, data.userIds):andThen(function(p2)
			if data.onSuccessCallback then
				data.onSuccessCallback(p2)
			end
		end):catch(function(p2)
			local success, result = pcall(function()
				return HttpService:JSONDecode(p2.Body)
			end)

			local setSquadPrompt = data.squadExternalContext.setSquadPrompt
			local promptType

			if success and result and result.reason_code == "participant_chat_disabled" then
				promptType = SquadPromptType.ParticipantChatDisabled
			else
				promptType = SquadPromptType.Error
			end

			setSquadPrompt(p, { hideCancelButton = true, promptType = promptType })

			if data.onErrorCallback then
				data.onErrorCallback()
			end
		end)
	end
end
