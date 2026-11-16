local function applyBubbleChatMessagePropertiesText(p: string?, p2: string?, textChatMessageProperties)
	if textChatMessageProperties and textChatMessageProperties:IsA("TextChatMessageProperties") then
		if textChatMessageProperties.Text ~= "" then
			p = textChatMessageProperties.Text
		end

		if textChatMessageProperties.Translation ~= "" then
			return p, textChatMessageProperties.Translation
		end
	end

	return p, p2
end

return applyBubbleChatMessagePropertiesText
