local TextChatService = game:GetService("TextChatService")

return function() -- line: 3
	-- upvalues: TextChatService (copy)
	if TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService then
		return false
	end

	return true
end
