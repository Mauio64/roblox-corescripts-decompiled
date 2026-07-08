local Parent = script:FindFirstAncestor("FriendsRodux").Parent
local Rodux = require(Parent.Rodux)
local receivedCount = require(script.receivedCount)
local byUserId = require(script.byUserId)
local mutualFriends = require(script.mutualFriends)
local sourceUniverseIds = require(script.sourceUniverseIds)
local nextPageCursor = require(script.nextPageCursor)
local sentAt = require(script.sentAt)
local originSourceType = require(script.originSourceType)
local order = require(script.order)
local senderNickname = require(script.senderNickname)
local newFriendRequestsCount = require(script.newFriendRequestsCount)

return function(p1) -- line: 14
	-- upvalues: Rodux (copy), receivedCount (copy), byUserId (copy), mutualFriends (copy), sourceUniverseIds (copy), nextPageCursor (copy), sentAt (copy), originSourceType (copy), order (copy), senderNickname (copy), newFriendRequestsCount (copy)
	return Rodux.combineReducers({
		receivedCount = receivedCount(p1),
		byUserId = byUserId(p1),
		mutualFriends = mutualFriends(p1),
		sourceUniverseIds = sourceUniverseIds(p1),
		nextPageCursor = nextPageCursor(p1),
		sentAt = sentAt(p1),
		originSourceType = originSourceType(p1),
		order = order(p1),
		senderNickname = senderNickname(p1),
		newFriendRequestsCount = newFriendRequestsCount(p1)
	})
end
