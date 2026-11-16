local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
return dependencies.enumerate(script.Name, {
	HomePage_AddFriends = "HomePage_AddFriends",
	HomePage_Carousel_LuaProfile = "HomePage_Carousel_LuaProfile",
	HomePage_Carousel_FriendsLanding = "HomePage_Carousel_FriendsLanding",
	MorePage_FriendsLanding = "MorePage_FriendsLanding"
})
