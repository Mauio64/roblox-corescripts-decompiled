local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
return dependencies.enumerate(script.Name, {
	JoinGameInPeopleList = "joinGameInPeopleList",
	ButtonClick = "buttonClick",
	PageLoad = "luaPageLoad",
	PageMountingTime = "pageMountingTime",
	PageLoadingTime = "pageLoadingTime",
	FriendsCarouselLoaded = "friendsCarouselLoaded",
	UserSeen = "userSeen"
})
