local FriendsLanding = script:FindFirstAncestor("FriendsLanding")

return require(FriendsLanding.dependencies).enumerate(script.Name, {
	ConnectionsHeader = "CommonUI.Features.Label.Connections",
	FriendsHeader = "CommonUI.Features.Label.Friends"
})
