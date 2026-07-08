local AppChat = script:FindFirstAncestor("AppChat")
local getDeepValue = require(AppChat.Utils.getDeepValue)
local populateConversationWithState = require(AppChat.Conversations.populateConversationWithState)

local function conversationSortPredicate(p1, p2) -- line: 7
	if p1.unixTime and p2.unixTime then
		return p1.unixTime > p2.unixTime
	end

	if not p1.unixTime and not p2.unixTime then
		return string.lower(p1.title) < string.lower(p2.title)
	end

	return (p1.unixTime or p2.unixTime) == p1.unixTime
end

local u5 = nil
local u6 = nil

return function(p3) -- line: 19
	-- upvalues: getDeepValue (copy), u5 (ref), u6 (ref), populateConversationWithState (copy), conversationSortPredicate (copy)
	local v10 = getDeepValue(p3, "ChatAppReducer.Conversations")

	if not v10 then
		return {}
	end

	local v11 = getDeepValue(p3, "ChatAppReducer.ConversationsAsync.latestMessagesIsFetching")

	if v10 == u5 then
		return u6
	end

	if v11 and u6 then
		return u6
	end

	local t1 = {}

	for _, v in pairs(v10) do
		table.insert(t1, (populateConversationWithState(p3, v)))
	end

	table.sort(t1, conversationSortPredicate)
	u5 = v10
	u6 = t1

	return t1
end
