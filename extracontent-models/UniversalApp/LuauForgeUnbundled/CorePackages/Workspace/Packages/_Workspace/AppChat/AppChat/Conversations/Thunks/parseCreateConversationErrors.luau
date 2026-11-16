local HttpService = game:GetService("HttpService")

local function parseCreateConversationErrors(p2): string
	if p2.StatusCode == 403 then
		local success, result = pcall(function()
			return HttpService:JSONDecode(p2.Body)
		end)

		if success and result and result.reason_code == "participant_chat_disabled" then
			return "participant_chat_disabled"
		end
	end

	return "unknown"
end

return parseCreateConversationErrors
