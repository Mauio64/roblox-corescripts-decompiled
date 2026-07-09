local SquadsCore = script:FindFirstAncestor("SquadsCore")
local HttpService = game:GetService("HttpService")
local SquadPromptType = require(SquadsCore.Enums.SquadPromptType)

return function(t1: {[any]: any}) -- line: 7
	-- upvalues: HttpService (copy), SquadPromptType (copy)
	return function(p1) -- line: 15
		-- upvalues: t1 (copy), HttpService (copy), SquadPromptType (copy)
		p1:dispatch(t1.squadContext.createConversation(t1.conversationType, t1.userIds, nil, t1.source)):andThen(function(p2) -- line: 20
			-- upvalues: t1 (copy)
			if t1.onSuccessCallback then
				t1.onSuccessCallback(p2.id)
			end
		end):catch(function(p3) -- line: 25
			-- upvalues: HttpService (copy), t1 (copy), p1 (copy), SquadPromptType (copy)
			local ok, result = pcall(function() -- line: 26
				-- upvalues: HttpService (copy), p3 (copy)
				return HttpService:JSONDecode(p3.Body)
			end)

			t1.squadContext.setSquadPrompt(p1, {
				hideCancelButton = true,
				promptType = if not ok or (not result or result.reason_code ~= "participant_chat_disabled") then SquadPromptType.Error else SquadPromptType.ParticipantChatDisabled
			})

			if t1.onErrorCallback then
				t1.onErrorCallback()
			end
		end)
	end
end
