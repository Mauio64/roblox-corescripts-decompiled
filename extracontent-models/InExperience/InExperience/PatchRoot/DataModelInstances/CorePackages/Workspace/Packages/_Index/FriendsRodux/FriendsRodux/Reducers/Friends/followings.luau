local parent = script:FindFirstAncestor("FriendsRodux").Parent
local Rodux = require(parent.Rodux)
local followingStatuses = require(script.followingStatuses)

return function(p)
	return Rodux.combineReducers({ followingStatuses = followingStatuses(p) })
end
