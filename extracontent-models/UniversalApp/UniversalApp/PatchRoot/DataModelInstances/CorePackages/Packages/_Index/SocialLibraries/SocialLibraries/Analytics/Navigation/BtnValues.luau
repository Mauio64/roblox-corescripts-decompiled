local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
return dependencies.enumerate(script.Name, {
	PlayerProfile = "playerProfile",
	FriendsLanding = "friendsLanding"
})
