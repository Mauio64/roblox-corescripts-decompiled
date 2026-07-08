local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local SocialCarouselParent = SocialCarousel.Parent
local FFlagConnectionsToFriendsRename = require(SocialCarouselParent.SharedFlags).FFlagConnectionsToFriendsRename
local FFlagSocialCarouselUpdateVerticalSpacing = require(SocialCarousel.Flags.FFlagSocialCarouselUpdateVerticalSpacing)
local FFlagSocialCarouselShareQREnabled = require(SocialCarouselParent.SharedFlags).FFlagSocialCarouselShareQREnabled

return {
	RODUX_KEY = "FriendsCarousel",
	LOCALIZATION = {
		FRIENDS_LABEL = "Feature.Friends.Label.Friends",
		FRIENDS_LABEL_WITH_COUNT = "Feature.Home.HeadingFriends",
		ADD_FRIENDS_HEADING = "Feature.Friends.Feature.Friends.Heading.AddFriends",
		FRIENDS_HINT_TITLE = "Feature.SocialTab.Label.AddFriendHintBody",
		FRIENDS_HINT_BODY = "Feature.Friends.Label.FindFriendsHintBody",
		NEW_FRIEND_REQUESTS_MAX = "Feature.Friends.Label.NewFriendRequestsMax",
		FRIENDS_ARE_NOW_CONNECTIONS = "Feature.Friends.Label.FriendsAreNowConnections",
		START_SQUAD_TEXT = "Feature.Squads.Label.StartParty",
		SHARE_QR_HEADING = "Feature.Friends.Action.ShareQR",
		FRIENDS_HINT_BOLD = if not FFlagSocialCarouselShareQREnabled then nil else "Feature.Friends.Label.FriendsHintBold",
		FRIENDS_HINT_PLAIN = if not FFlagSocialCarouselShareQREnabled then nil else "Feature.Friends.Label.FriendsHintPlain",
		CONNECTIONS_LABEL = not FFlagConnectionsToFriendsRename and "CommonUI.Features.Label.Connections" or nil,
		CONNECTIONS_LABEL_WITH_COUNT = not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.ConnectionsCount" or nil,
		CONNECTIONS_HINT_TITLE = not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.AddConnectionsHint" or nil,
		CONNECTIONS_HINT_BODY = not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.AddConnectionsHintBody" or nil,
		ADD_CONNECTIONS_HEADING = not FFlagConnectionsToFriendsRename and "CommonUI.Features.Label.Connect" or nil
	},
	ANALYTICS = {
		CONTENT_TYPE = "User",
		ACTION_TYPES = {
			OPEN_CONTEXTUAL_MENU = "OpenContextualMenu",
			OPEN_PROFILE = "OpenProfile",
			OPEN_CONSOLE_CONTEXTUAL_MENU = "OpenConsoleContextualMenu",
			OPEN_ADD_FRIENDS = "OpenAddFriends",
			OPEN_SHARE_QR = "OpenShareQR"
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
		}
	},
	TILE_TEXT_HEIGHT = not FFlagSocialCarouselUpdateVerticalSpacing and 45 or 32,
	TILE_TEXT_WIDTH = not FFlagSocialCarouselShareQREnabled and 125 or 30
}
