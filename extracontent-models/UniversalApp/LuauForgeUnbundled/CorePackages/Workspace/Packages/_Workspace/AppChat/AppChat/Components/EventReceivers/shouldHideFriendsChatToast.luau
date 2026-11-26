local HttpService = game:GetService("HttpService")

local function isOneToOneChatToast(p2): boolean
	local content = p2.content

	if content == nil or content.currentState == nil or content.states == nil then
		return false
	end

	local state = content.states[content.currentState]

	if state == nil or state.visualItems == nil then
		return false
	end

	local count = 0

	for k, visualItem in state.visualItems do
		if visualItem.thumbnail ~= nil then
			count += 1
		end
	end

	return count == 1
end

local function shouldHideFriendsChatToast(p2, p3)
	if p2 == nil or p3 == nil then
		return false
	end

	local content = p2.content
	local clientEventsPayload = if content then content.clientEventsPayload else p2.clientEventsPayload
	local sender_id = clientEventsPayload
		and (clientEventsPayload.sender_id or clientEventsPayload.sender_userid)

	if sender_id ~= nil and isOneToOneChatToast(p2) and p3 == `friends:{tostring(sender_id)}` then
		return true
	end

	local conversation_id = clientEventsPayload and clientEventsPayload.conversation_id

	if conversation_id == p3 then
		return true
	end

	if type(conversation_id) ~= "string" then
		return false
	end

	local success, result = pcall(function()
		return HttpService:JSONDecode(conversation_id)
	end)

	if success then
		success = type(result) == "table" and result.conversationId == p3
	end

	return success
end

return shouldHideFriendsChatToast
