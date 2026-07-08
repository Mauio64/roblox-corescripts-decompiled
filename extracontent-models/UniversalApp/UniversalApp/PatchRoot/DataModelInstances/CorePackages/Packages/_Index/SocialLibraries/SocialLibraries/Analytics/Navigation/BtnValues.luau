local ParentParent = script.Parent.Parent.Parent

return require(ParentParent.dependencies).enumerate(script.Name, {
	PlayerProfile = "playerProfile",
	FriendsLanding = "friendsLanding"
})
