local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local filterStates = require(FriendsLanding.Friends.filterStates)

return function(data, _)
	return {
		{ text = data.all, id = filterStates.All },
		{ text = data.online, id = filterStates.Online },
		{ text = data.inExperience, id = filterStates.InExperience }
	}
end
