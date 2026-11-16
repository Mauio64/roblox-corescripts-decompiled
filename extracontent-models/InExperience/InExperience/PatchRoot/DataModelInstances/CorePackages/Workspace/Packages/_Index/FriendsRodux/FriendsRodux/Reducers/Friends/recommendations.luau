local parent = script:FindFirstAncestor("FriendsRodux").Parent
local Rodux = require(parent.Rodux)
local byUserId = require(script.byUserId)
local bySource = require(script.bySource)
local hasIncomingFriendRequest = require(script.hasIncomingFriendRequest)

return function(p)
	return Rodux.combineReducers({
		byUserId = byUserId(p),
		bySource = bySource(p),
		hasIncomingFriendRequest = hasIncomingFriendRequest(p)
	})
end
