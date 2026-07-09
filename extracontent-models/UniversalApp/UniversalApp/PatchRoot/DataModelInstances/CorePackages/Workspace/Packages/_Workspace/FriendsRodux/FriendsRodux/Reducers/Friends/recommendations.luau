local Parent = script:FindFirstAncestor("FriendsRodux").Parent
local Rodux = require(Parent.Rodux)
local byUserId = require(script.byUserId)
local bySource = require(script.bySource)
local hasIncomingFriendRequest = require(script.hasIncomingFriendRequest)

return function(p1) -- line: 8
	-- upvalues: Rodux (copy), byUserId (copy), bySource (copy), hasIncomingFriendRequest (copy)
	return Rodux.combineReducers({
		byUserId = byUserId(p1),
		bySource = bySource(p1),
		hasIncomingFriendRequest = hasIncomingFriendRequest(p1)
	})
end
