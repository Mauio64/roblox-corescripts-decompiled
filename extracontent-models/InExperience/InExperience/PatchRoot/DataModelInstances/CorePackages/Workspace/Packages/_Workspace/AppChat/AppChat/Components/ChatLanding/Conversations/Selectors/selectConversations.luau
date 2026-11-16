local AppChat = script:FindFirstAncestor("AppChat")

local getDeepValue = require(AppChat.Utils.getDeepValue)
local populateConversationWithState = require(AppChat.Conversations.populateConversationWithState)

local function conversationSortPredicate(p, p2): boolean
	if p.unixTime and p2.unixTime then
		return p.unixTime > p2.unixTime
	end

	if p.unixTime or p2.unixTime then
		return (p.unixTime or p2.unixTime) == p.unixTime
	end

	return string.lower(p.title) < string.lower(p2.title)
end

local v = nil
local v2 = nil
return function(p)
	local deepValue = getDeepValue(p, "ChatAppReducer.Conversations")

	if not deepValue then
		return {}
	end

	if deepValue == v then
		return v2
	end

	local result = {}

	for _, v3 in pairs(deepValue) do
		table.insert(result, (populateConversationWithState(p, v3)))
	end

	table.sort(result, conversationSortPredicate)

	v = deepValue
	v2 = result

	return result
end
