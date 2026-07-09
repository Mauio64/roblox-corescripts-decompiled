local FriendsLanding = script:FindFirstAncestor("FriendsLanding")

return require(FriendsLanding.dependencies).enumerate(script.Name, {
	Home = "Home",
	More = "More",
	SocialTab = "SocialTab"
})
