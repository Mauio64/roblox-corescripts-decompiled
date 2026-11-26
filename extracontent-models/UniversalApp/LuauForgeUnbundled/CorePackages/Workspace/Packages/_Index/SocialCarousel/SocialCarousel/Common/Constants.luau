local FFlagSocialCarouselUpdateVerticalSpacing = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselUpdateVerticalSpacing")
local fFlagSocialCarouselShareQREnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSocialCarouselShareQREnabled
local v5 = FFlagSocialCarouselUpdateVerticalSpacing and 38 or 45
return {
	LOCALIZATION = {
		FRIENDS_LABEL = "Feature.Friends.Label.Friends",
		FRIENDS_LABEL_WITH_COUNT = "Feature.Home.HeadingFriends",
		ADD_FRIENDS_HEADING = "Feature.Friends.Feature.Friends.Heading.AddFriends",
		ADD_FRIENDS_HEADING_SENTENCE_CASE = "Feature.AddFriends.Heading.AddFriends",
		FRIENDS_HINT_TITLE = "Feature.SocialTab.Label.AddFriendHintBody",
		FRIENDS_HINT_BODY = "Feature.Friends.Label.FindFriendsHintBody",
		FRIENDS_HINT_BOLD = fFlagSocialCarouselShareQREnabled and "Feature.Friends.Label.FriendsHintBold" or nil,
		FRIENDS_HINT_PLAIN = fFlagSocialCarouselShareQREnabled and "Feature.Friends.Label.FriendsHintPlain" or nil,
		NEW_FRIEND_REQUESTS_MAX = "Feature.Friends.Label.NewFriendRequestsMax",
		FRIENDS_ARE_NOW_CONNECTIONS = "Feature.Friends.Label.FriendsAreNowConnections",
		START_SQUAD_TEXT = "Feature.Squads.Label.StartParty",
		SHARE_QR_HEADING = "Feature.Friends.Action.ShareQR"
	},
	ANALYTICS = {
		ACTION_TYPES = {
			OPEN_CONTEXTUAL_MENU = "OpenContextualMenu",
			OPEN_PROFILE = "OpenProfile",
			OPEN_CONSOLE_CONTEXTUAL_MENU = "OpenConsoleContextualMenu",
			OPEN_ADD_FRIENDS = "OpenAddFriends",
			OPEN_SHARE_QR = "OpenShareQR"
		},
		TILE_CLICK_TARGETS = {
			AVATAR = "avatar",
			PLAY_ICON = "playIcon",
			TILE_TEXT = "tileText"
		},
		BTN_VALUES = {
			OPEN_PEOPLE_LIST = "openPeopleList",
			ADD_FRIENDS = "AddFriendsButton",
			VIEW_ALL_FRIENDS = "friendsLanding",
			START_SQUAD = "StartSquadButton",
			SHARE_QR = "ShareQRButton"
		},
		SRC = {
			HOMEPAGE_FRIENDS_CAROUSEL = "HomepageFriendsCarousel",
			PARTY_PAGE_UA = "PartyPageUA",
			PARTY_PAGE_IN_EXP = "PartyPageInExp"
		},
		UI_LOADING_EVENTS = {
			EMPTY_HINT = "EmptyHint",
			CAROUSEL_FRIEND = "CarouselFriend",
			ADD_FRIENDS = "AddFriendsBtn",
			START_SQUAD = "StartSquadBtn",
			SHARE_QR = "ShareQRBtn"
		},
		CONTENT_TYPE = "User"
	},
	TILE_ICON_SCALE = 0.5,
	ADD_FRIENDS_TITLE_OVERHANG = 1,
	TILE_TEXT_HEIGHT = v5,
	XSMALL_TILE_TEXT_HEIGHT = v5 - 4,
	TILE_TEXT_WIDTH = fFlagSocialCarouselShareQREnabled and 30 or 125,
	RODUX_KEY = "FriendsCarousel"
}
