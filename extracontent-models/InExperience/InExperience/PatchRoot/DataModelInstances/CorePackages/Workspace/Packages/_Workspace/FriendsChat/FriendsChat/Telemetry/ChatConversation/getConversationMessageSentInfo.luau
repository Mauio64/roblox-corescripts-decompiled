local parent = script:FindFirstAncestor("FriendsChat").Parent

local SendMessageError = require(parent.AppChat.SendMessageError)

local function getConversationMessageSentInfo(data, recipientIds: string)
	local conversationMessageSentInfo = {
		messageSentResult = SendMessageError.OtherFailure,
		recipientIds = recipientIds
	}

	if data == nil then
		conversationMessageSentInfo.messageSentResult = SendMessageError.NoResponse
		return conversationMessageSentInfo
	end

	if (data.StatusCode or data.responseCode) == 409 then
		conversationMessageSentInfo.messageSentResult = SendMessageError.Conflict
		return conversationMessageSentInfo
	end

	if data.responseBody == nil then
		conversationMessageSentInfo.messageSentResult = SendMessageError.NoResponseBody
		return conversationMessageSentInfo
	end

	local messages = data.responseBody.messages

	if messages == nil or #messages == 0 then
		conversationMessageSentInfo.messageSentResult = SendMessageError.NoMessages
		return conversationMessageSentInfo
	end

	local message = messages[1]

	if message.status == nil then
		conversationMessageSentInfo.messageSentResult = SendMessageError.NoMessageStatus
		return conversationMessageSentInfo
	end

	conversationMessageSentInfo.messageSentResult = message.status
	conversationMessageSentInfo.messageId = message.id
	return conversationMessageSentInfo
end

return getConversationMessageSentInfo
