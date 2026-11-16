local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)

return dependencies.enumerate(script.Name, {
	ConnectionsHeader = "CommonUI.Features.Label.Connections",
	FriendsHeader = "CommonUI.Features.Label.Friends"
})
