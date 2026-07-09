local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local filterStates = require(FriendsLanding.Friends.filterStates)

return function(p1, _) -- line: 4
	-- upvalues: filterStates (copy)
	return {
		{
			text = p1.all,
			id = filterStates.All
		},
		{
			text = p1.online,
			id = filterStates.Online
		},
		{
			text = p1.inExperience,
			id = filterStates.InExperience
		}
	}
end
