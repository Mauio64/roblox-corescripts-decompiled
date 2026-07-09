local HttpService = game:GetService("HttpService")

local function parseCreateConversationErrors(p1) -- line: 3
	-- upvalues: HttpService (copy)
	if p1.StatusCode == 403 then
		local ok, result = pcall(function() -- line: 5
			-- upvalues: HttpService (copy), p1 (copy)
			return HttpService:JSONDecode(p1.Body)
		end)

		if ok and result and result.reason_code == "participant_chat_disabled" then
			return "participant_chat_disabled"
		end
	end

	return "unknown"
end

return parseCreateConversationErrors
