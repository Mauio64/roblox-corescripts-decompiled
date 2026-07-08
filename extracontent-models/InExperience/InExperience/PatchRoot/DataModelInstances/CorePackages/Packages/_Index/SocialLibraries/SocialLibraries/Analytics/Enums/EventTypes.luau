local ParentParent = script.Parent.Parent.Parent

return require(ParentParent.dependencies).enumerate(script.Name, {
	JoinGameInPeopleList = "joinGameInPeopleList",
	ButtonClick = "buttonClick",
	PageLoad = "luaPageLoad",
	PageMountingTime = "pageMountingTime",
	PageLoadingTime = "pageLoadingTime",
	FriendsCarouselLoaded = "friendsCarouselLoaded",
	UserSeen = "userSeen"
})
