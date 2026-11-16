local HttpService = game:GetService("HttpService")

local function isOneToOneChatToast(p): boolean
	local content = p.content

	if content == nil or content.currentState == nil or content.states == nil then
		return false
	end

	local state = content.states[content.currentState]

	if state == nil or state.visualItems == nil then
		return false
	end

	local count = 0

	for _, visualItem in state.visualItems do
		if visualItem.thumbnail ~= nil then
			count += 1
		end
	end

	return count == 1
end

local function shouldHideFriendsChatToast(p, p2: string?)
	if p == nil or p2 == nil then
		return false
	end

	local content = p.content
	local clientEventsPayload

	if content then
		clientEventsPayload = content.clientEventsPayload
	else
		clientEventsPayload = p.clientEventsPayload
	end

	local sender_id = clientEventsPayload and (clientEventsPayload.sender_id or clientEventsPayload.sender_userid)

	if sender_id ~= nil and isOneToOneChatToast(p) and p2 == `friends:{tostring(sender_id)}` then
		return true
	end

	local conversation_id = clientEventsPayload and clientEventsPayload.conversation_id

	if conversation_id == p2 then
		return true
	end

	if type(conversation_id) ~= "string" then
		return false
	end

	local success, result = pcall(function()
		return HttpService:JSONDecode(conversation_id)
	end)

	if success then
		if type(result) == "table" then
			success = result.conversationId == p2
		else
			success = false
		end
	end

	return success
end

return shouldHideFriendsChatToast
