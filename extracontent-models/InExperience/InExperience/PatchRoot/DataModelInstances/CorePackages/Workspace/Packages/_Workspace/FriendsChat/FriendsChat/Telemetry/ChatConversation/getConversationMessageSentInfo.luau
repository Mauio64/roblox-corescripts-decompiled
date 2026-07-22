local Parent = script:FindFirstAncestor("FriendsChat").Parent
local SendMessageError = require(Parent.AppChat.SendMessageError)

local function getConversationMessageSentInfo(p1, s1: string) -- line: 27
	-- upvalues: SendMessageError (copy)
	local t1 = {
		messageSentResult = SendMessageError.OtherFailure,
		recipientIds = s1
	}

	if p1 == nil then
		t1.messageSentResult = SendMessageError.NoResponse

		return t1
	end

	if (p1.StatusCode or p1.responseCode) == 409 then
		t1.messageSentResult = SendMessageError.Conflict

		return t1
	end

	if p1.responseBody == nil then
		t1.messageSentResult = SendMessageError.NoResponseBody

		return t1
	end

	local messages = p1.responseBody.messages

	if messages == nil or #messages == 0 then
		t1.messageSentResult = SendMessageError.NoMessages

		return t1
	end

	local v8 = messages[1]

	if v8.status == nil then
		t1.messageSentResult = SendMessageError.NoMessageStatus

		return t1
	end

	t1.messageSentResult = v8.status
	t1.messageId = v8.id

	return t1
end

return getConversationMessageSentInfo
