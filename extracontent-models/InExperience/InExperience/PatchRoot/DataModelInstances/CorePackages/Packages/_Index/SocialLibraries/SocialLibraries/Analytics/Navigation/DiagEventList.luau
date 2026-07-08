local EventNames = require(script.Parent.EventNames)

require(script.Parent.Parent.FireEvent.Types)

return {
	[EventNames.HomePage_AddFriends] = {
		name = game:DefineFastString("SocialNavigationHomePageAddFriends", "HomePageAddFriends")
	},
	[EventNames.HomePage_Carousel_LuaProfile] = {
		name = game:DefineFastString("SocialNavigationHomePageCarouselLuaProfile", "LuaProfileEntryHomePageFriendsCarousel")
	},
	[EventNames.HomePage_Carousel_FriendsLanding] = {
		name = game:DefineFastString("SocialNavigationHomePageFriendsLanding", "HomePageNavigationFriendsLanding")
	},
	[EventNames.MorePage_FriendsLanding] = {
		name = game:DefineFastString("SocialNavigationMorePageFriendsLanding", "MorePageNavigationFriendsLanding")
	}
}
