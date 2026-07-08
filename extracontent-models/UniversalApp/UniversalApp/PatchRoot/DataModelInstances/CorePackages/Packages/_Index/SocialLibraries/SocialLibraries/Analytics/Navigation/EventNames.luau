local ParentParent = script.Parent.Parent.Parent

return require(ParentParent.dependencies).enumerate(script.Name, {
	HomePage_AddFriends = "HomePage_AddFriends",
	HomePage_Carousel_LuaProfile = "HomePage_Carousel_LuaProfile",
	HomePage_Carousel_FriendsLanding = "HomePage_Carousel_FriendsLanding",
	MorePage_FriendsLanding = "MorePage_FriendsLanding"
})
