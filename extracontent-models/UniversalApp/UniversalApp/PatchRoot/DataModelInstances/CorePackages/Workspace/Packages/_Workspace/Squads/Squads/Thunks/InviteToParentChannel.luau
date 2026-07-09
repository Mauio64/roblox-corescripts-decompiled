local Parent = script:FindFirstAncestor("Squads").Parent
local HttpService = game:GetService("HttpService")
local SquadPromptType = require(Parent.SquadsCore.Enums).SquadPromptType

return function(t1: {[any]: any}) -- line: 8
	-- upvalues: HttpService (copy), SquadPromptType (copy)
	return function(p1) -- line: 16
		-- upvalues: t1 (copy), HttpService (copy), SquadPromptType (copy)
		return t1.squadExternalContext.inviteToParentChannel(t1.dispatch, t1.parentChannel, t1.userIds):andThen(function(p2) -- line: 19
			-- upvalues: t1 (copy)
			if t1.onSuccessCallback then
				t1.onSuccessCallback(p2)
			end
		end):catch(function(p3) -- line: 24
			-- upvalues: HttpService (copy), t1 (copy), p1 (copy), SquadPromptType (copy)
			local ok, result = pcall(function() -- line: 25
				-- upvalues: HttpService (copy), p3 (copy)
				return HttpService:JSONDecode(p3.Body)
			end)

			t1.squadExternalContext.setSquadPrompt(p1, {
				hideCancelButton = true,
				promptType = if not ok or (not result or result.reason_code ~= "participant_chat_disabled") then SquadPromptType.Error else SquadPromptType.ParticipantChatDisabled
			})

			if t1.onErrorCallback then
				t1.onErrorCallback()
			end
		end)
	end
end
