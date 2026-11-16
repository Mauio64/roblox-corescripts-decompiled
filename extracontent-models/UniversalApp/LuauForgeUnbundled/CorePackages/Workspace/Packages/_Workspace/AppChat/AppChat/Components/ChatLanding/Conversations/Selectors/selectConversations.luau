local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue")
local populateConversationWithState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/populateConversationWithState")

local function conversationSortPredicate(p2, p3): boolean
	if p2.unixTime and p3.unixTime then
		return p2.unixTime > p3.unixTime
	end

	if p2.unixTime or p3.unixTime then
		return (p2.unixTime or p3.unixTime) == p2.unixTime
	end

	return string.lower(p2.title) < string.lower(p3.title)
end

local v5 = nil
local v6 = nil
return function(p2)
	local v7 = getDeepValue(p2, "ChatAppReducer.Conversations")

	if not v7 then
		return {}
	end

	if v7 == v5 then
		return v6
	end

	local result = {}

	for k, v8 in pairs(v7) do
		table.insert(result, (populateConversationWithState(p2, v8)))
	end

	table.sort(result, conversationSortPredicate)

	v5 = v7
	v6 = result

	return result
end
