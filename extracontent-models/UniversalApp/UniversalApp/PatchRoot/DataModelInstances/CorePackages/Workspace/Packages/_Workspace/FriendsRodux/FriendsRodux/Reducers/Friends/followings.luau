local Parent = script:FindFirstAncestor("FriendsRodux").Parent
local Rodux = require(Parent.Rodux)
local followingStatuses = require(script.followingStatuses)

return function(p1) -- line: 6
	-- upvalues: Rodux (copy), followingStatuses (copy)
	return Rodux.combineReducers({
		followingStatuses = followingStatuses(p1)
	})
end
