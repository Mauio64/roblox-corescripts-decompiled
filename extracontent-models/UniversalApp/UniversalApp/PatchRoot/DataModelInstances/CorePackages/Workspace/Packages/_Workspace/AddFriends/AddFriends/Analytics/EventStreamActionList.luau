local Parent = script:FindFirstAncestor("AddFriends").Parent
local Dash = require(Parent.Dash)
local Enums = require(Parent.SocialLuaAnalytics).Analytics.Enums
local EventTypes = Enums.EventTypes
local Contexts = Enums.Contexts
local Sources = Enums.Sources
local EventNames = require(script.Parent.EventNames)
local FFlagAddFriendsPYMKPresenceAnalytics = require(Parent.SharedFlags).FFlagAddFriendsPYMKPresenceAnalytics
local FFlagAddFriendsTileLoadFromHomeCarouselAnalytics = require(Parent.SharedFlags).FFlagAddFriendsTileLoadFromHomeCarouselAnalytics
local FFlagEnableSchoolEntry = require(Parent.SharedFlags).FFlagEnableSchoolEntry

local function v11(p1) -- line: 30
	if p1 then
		return (tostring(p1))
	end

	return nil
end

return {
	[EventNames.PageLoad] = {
		context = Contexts.AddFriends,
		eventType = EventTypes.PageLoad,
		formatRulesForAdditionalInfo = {
			recommendationCount = Dash.identity,
			status = Dash.identity
		}
	},
	[EventNames.AddFriendsPageLoadingTime] = {
		context = Contexts.AddFriends,
		eventType = EventTypes.LoadingTime,
		formatRulesForAdditionalInfo = {
			loadingTime = Dash.identity,
			status = Dash.identity
		}
	},
	[EventNames.AFPUserTileLoadFromHomeCarousel] = if not FFlagAddFriendsTileLoadFromHomeCarouselAnalytics then nil else {
		context = Contexts.AddFriends,
		eventType = EventTypes.LoadingTime,
		additionalInfo = {
			fetch = "userTileLoad",
			source = Sources.HomePageFriendsCarousel
		},
		formatRulesForAdditionalInfo = {
			loadingTime = Dash.identity
		}
	},
	[EventNames.UserSearchClick] = {
		context = Contexts.AddFriends,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			action = "peopleSearchBar"
		}
	},
	[EventNames.CIBtnClick] = {
		context = Contexts.AddFriends,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			action = "connectWithFriends"
		}
	},
	[EventNames.QRCodeBtnClick] = {
		context = Contexts.AddFriends,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			action = "shareProfileQRCode"
		}
	},
	[EventNames.CIBtnImpression] = {
		context = Contexts.AddFriends,
		eventType = EventTypes.UserSeen,
		additionalInfo = {
			action = "connectWithFriends"
		}
	},
	[EventNames.QRCodeBtnImpression] = {
		context = Contexts.AddFriends,
		eventType = EventTypes.UserSeen,
		additionalInfo = {
			action = "shareProfileQRCode"
		}
	},
	[EventNames.SchoolBtnClick] = if not FFlagEnableSchoolEntry then nil else {
		context = Contexts.AddFriends,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			action = "school"
		}
	},
	[EventNames.SchoolBtnImpression] = if not FFlagEnableSchoolEntry then nil else {
		context = Contexts.AddFriends,
		eventType = EventTypes.UserSeen,
		additionalInfo = {
			action = "school"
		}
	},
	[EventNames.RequestFriendshipBtnClick] = {
		context = Contexts.AddFriends,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			action = "requestFriendship"
		},
		formatRulesForAdditionalInfo = {
			namespace = Dash.identity,
			targetUserId = Dash.identity,
			absolutePosition = Dash.identity,
			rank = Dash.identity,
			contextType = Dash.identity,
			entityType = Dash.identity,
			presence = if not FFlagAddFriendsPYMKPresenceAnalytics then nil else v11
		}
	},
	[EventNames.AcceptFriendshipBtnClick] = {
		context = Contexts.AddFriends,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			action = "acceptFriendship"
		},
		formatRulesForAdditionalInfo = {
			namespace = Dash.identity,
			targetUserId = Dash.identity,
			absolutePosition = Dash.identity,
			rank = Dash.identity,
			contextType = Dash.identity,
			entityType = Dash.identity,
			presence = if not FFlagAddFriendsPYMKPresenceAnalytics then nil else v11
		}
	},
	[EventNames.DeclineFriendshipBtnClick] = {
		context = Contexts.AddFriends,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			action = "declineFriendship"
		},
		formatRulesForAdditionalInfo = {
			namespace = Dash.identity,
			targetUserId = Dash.identity,
			absolutePosition = Dash.identity,
			rank = Dash.identity,
			contextType = Dash.identity,
			entityType = Dash.identity,
			presence = if not FFlagAddFriendsPYMKPresenceAnalytics then nil else v11
		}
	},
	[EventNames.PlayerTileClick] = {
		context = Contexts.AddFriends,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			action = "userTileClick"
		},
		formatRulesForAdditionalInfo = {
			namespace = Dash.identity,
			targetUserId = Dash.identity,
			absolutePosition = Dash.identity,
			rank = Dash.identity,
			contextType = Dash.identity,
			entityType = Dash.identity,
			friendStatus = Dash.identity,
			presence = if not FFlagAddFriendsPYMKPresenceAnalytics then nil else v11
		}
	},
	[EventNames.IgnoreAllBtnClick] = {
		context = Contexts.AddFriends,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			action = "ignoreAll"
		}
	},
	[EventNames.ShowMoreBtnClick] = {
		context = Contexts.AddFriends,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			action = "loadMoreUsers"
		},
		formatRulesForAdditionalInfo = {
			namespace = Dash.identity
		}
	},
	[EventNames.UserTileImpression] = {
		context = Contexts.AddFriends,
		eventType = EventTypes.UserSeen,
		additionalInfo = {
			action = "userTileImpression"
		},
		formatRulesForAdditionalInfo = {
			namespace = Dash.identity,
			targetUserId = Dash.identity,
			absolutePosition = Dash.identity,
			rank = Dash.identity,
			contextType = Dash.identity,
			entityType = Dash.identity,
			friendStatus = Dash.identity,
			rowInSort = Dash.identity,
			presence = if not FFlagAddFriendsPYMKPresenceAnalytics then nil else Dash.identity
		}
	},
	[EventNames.FriendingOSAEducationSubtitleImpression] = {
		context = Contexts.AddFriends,
		eventType = EventTypes.UserSeen,
		additionalInfo = {
			action = "friendingOSAEducationSubtitle"
		}
	},
	[EventNames.TrustedContactsEducationalBannerClick] = {
		context = Contexts.AddFriends,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			action = "trustedContactsEducationalBanner"
		}
	},
	[EventNames.TrustedContactsEducationalBannerClose] = {
		context = Contexts.AddFriends,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			action = "TrustedContactsEducationalBannerClose"
		}
	},
	[EventNames.TrustedContactsEducationalBannerImpression] = {
		context = Contexts.AddFriends,
		eventType = EventTypes.UserSeen,
		additionalInfo = {
			action = "trustedContactsEducationalBanner"
		}
	},
	[EventNames.PYMKUserPresenceLoad] = if not FFlagAddFriendsPYMKPresenceAnalytics then nil else {
		context = Contexts.AddFriends,
		eventType = EventTypes.LoadingTime,
		additionalInfo = {
			source = "AddFriendsPYMKUserPresence"
		}
	}
}
