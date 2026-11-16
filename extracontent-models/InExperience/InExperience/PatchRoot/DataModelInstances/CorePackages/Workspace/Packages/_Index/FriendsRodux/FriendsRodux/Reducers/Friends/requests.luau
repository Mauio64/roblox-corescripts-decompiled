local parent = script:FindFirstAncestor("FriendsRodux").Parent
local Rodux = require(parent.Rodux)

local receivedCount = require(script.receivedCount)
local byUserId = require(script.byUserId)
local mutualFriends = require(script.mutualFriends)
local sourceUniverseIds = require(script.sourceUniverseIds)
local nextPageCursor = require(script.nextPageCursor)
local sentAt = require(script.sentAt)
local originSourceType = require(script.originSourceType)
local order = require(script.order)
local senderNickname = require(script.senderNickname)
local isUnseen = require(script.isUnseen)
local newFriendRequestsCount = require(script.newFriendRequestsCount)

return function(p)
	return Rodux.combineReducers({
		receivedCount = receivedCount(p),
		byUserId = byUserId(p),
		mutualFriends = mutualFriends(p),
		sourceUniverseIds = sourceUniverseIds(p),
		nextPageCursor = nextPageCursor(p),
		sentAt = sentAt(p),
		originSourceType = originSourceType(p),
		order = order(p),
		senderNickname = senderNickname(p),
		isUnseen = isUnseen(p),
		newFriendRequestsCount = newFriendRequestsCount(p)
	})
end
