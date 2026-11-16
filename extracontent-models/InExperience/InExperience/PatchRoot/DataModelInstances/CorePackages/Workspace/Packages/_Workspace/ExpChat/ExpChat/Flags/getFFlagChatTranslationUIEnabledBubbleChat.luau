local TextChatService = game:GetService("TextChatService")

return function(): boolean
	return TextChatService.ChatVersion ~= Enum.ChatVersion.LegacyChatService
end
