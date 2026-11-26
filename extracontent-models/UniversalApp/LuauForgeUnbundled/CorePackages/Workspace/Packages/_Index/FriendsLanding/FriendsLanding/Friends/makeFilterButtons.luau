local filterStates = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Friends/filterStates")

return function(data, p2)
	return {
		{ text = data.all, id = filterStates.All },
		{ text = data.online, id = filterStates.Online },
		{ text = data.inExperience, id = filterStates.InExperience }
	}
end
