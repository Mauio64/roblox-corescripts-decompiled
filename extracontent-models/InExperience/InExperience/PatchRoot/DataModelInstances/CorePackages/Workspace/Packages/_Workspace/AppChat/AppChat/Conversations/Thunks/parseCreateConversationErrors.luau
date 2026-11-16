local HttpService = game:GetService("HttpService")

local function parseCreateConversationErrors(p): string
	if p.StatusCode == 403 then
		local success, result = pcall(function()
			return HttpService:JSONDecode(p.Body)
		end)

		if success and result and result.reason_code == "participant_chat_disabled" then
			return "participant_chat_disabled"
		end
	end

	return "unknown"
end

return parseCreateConversationErrors
