local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SocialLuaAnalytics")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags")
local formatRecommendationContextType = SocialLuaAnalytics.Analytics.Formatters.formatRecommendationContextType
local enums = SocialLuaAnalytics.Analytics.Enums
local contexts = enums.Contexts
local eventTypes = enums.EventTypes

local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Analytics/EventNames")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Constants")
local fIntSocialCarouselShowRecsLimit = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags").FIntSocialCarouselShowRecsLimit
local fFlagSocialCarouselShareQREnabled = SharedFlags.FFlagSocialCarouselShareQREnabled
local fFlagLuaAppUserSeenCollectionUnifiedFields = SharedFlags.FFlagLuaAppUserSeenCollectionUnifiedFields

local FFlagSocialCarouselLogNewFriendRequestsBadge = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselLogNewFriendRequestsBadge")
local fFlagSocialCarouselInGamePlayIcon = SharedFlags.FFlagSocialCarouselInGamePlayIcon

local function fn(p2)
	return p2
end

local v5 = {
	[EventNames.UserPressed] = {
		context = contexts.HomePage,
		eventType = eventTypes.ButtonClick,
		additionalInfo = {
			btn = Constants.ANALYTICS.BTN_VALUES.OPEN_PEOPLE_LIST,
			contentType = Constants.ANALYTICS.CONTENT_TYPE,
			actionType = Constants.ANALYTICS.ACTION_TYPES.OPEN_PROFILE
		},
		formatRulesForAdditionalInfo = {
			absolutePosition = fn,
			positionInRow = fn,
			recommendationContextType = formatRecommendationContextType,
			friendId = fn,
			friendStatus = fn,
			isRecommendation = fn,
			recommendationRank = fn,
			universeId = fn,
			presence = fn,
			source = fn,
			interactionUuid = fn,
			tileClickTarget = if fFlagSocialCarouselInGamePlayIcon then fn else nil
		}
	},
	[EventNames.UserSeen] = {
		context = contexts.HomePage,
		eventType = eventTypes.UserSeen,
		formatRulesForAdditionalInfo = {
			userId = fn,
			presence = fn,
			absolutePosition = fn,
			recommendationRank = fn,
			friendStatus = fn,
			recommendationContextType = formatRecommendationContextType,
			isRecommendation = fn,
			source = fn,
			universeId = fn
		}
	},
	[EventNames.ViewAddFriends] = {
		context = contexts.AddFriends,
		eventType = eventTypes.ButtonClick,
		additionalInfo = {
			btn = Constants.ANALYTICS.BTN_VALUES.ADD_FRIENDS,
			absolutePosition = fn,
			positionInRow = fn,
			contentType = Constants.ANALYTICS.CONTENT_TYPE,
			actionType = Constants.ANALYTICS.ACTION_TYPES.OPEN_ADD_FRIENDS
		},
		formatRulesForAdditionalInfo = {
			friendCount = fn,
			recommendationLimit = fIntSocialCarouselShowRecsLimit,
			recommendationCount = fn,
			requestCount = fn,
			source = fn,
			interactionUuid = fn
		}
	},
	[EventNames.AddFriendsTileSeen] = FFlagSocialCarouselLogNewFriendRequestsBadge and {
		context = contexts.HomePage,
		eventType = eventTypes.AddFriendsTileSeen,
		formatRulesForAdditionalInfo = {
			newRequestCount = fn,
			previousCount = fn,
			trigger = fn,
			badgeEnabled = fn,
			badgeShown = fn,
			badgeCapped = fn,
			absolutePosition = fn,
			source = fn
		}
	} or nil,
	[EventNames.ViewAllFriends] = {
		context = contexts.HomePage,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { btn = Constants.ANALYTICS.BTN_VALUES.VIEW_ALL_FRIENDS },
		formatRulesForAdditionalInfo = {
			friendCount = fn,
			recommendationLimit = fIntSocialCarouselShowRecsLimit,
			recommendationCount = fn,
			source = fn
		}
	},
	[EventNames.FriendsCarouselUILoadingTime] = {
		context = contexts.HomePage,
		eventType = eventTypes.LoadingTime,
		formatRulesForAdditionalInfo = {
			status = fn,
			fetch = fn,
			loadingTime = fn,
			loadingThreshold = fn,
			nextPage = fn,
			source = fn
		},
		additionalInfo = {}
	},
	[EventNames.StartSquadPressed] = {
		context = contexts.HomePage,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { btn = Constants.ANALYTICS.BTN_VALUES.START_SQUAD },
		formatRulesForAdditionalInfo = { absolutePosition = fn, source = fn }
	},
	[EventNames.ShareQRPressed] = fFlagSocialCarouselShareQREnabled and {
		context = contexts.HomePage,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { btn = Constants.ANALYTICS.BTN_VALUES.SHARE_QR },
		formatRulesForAdditionalInfo = { absolutePosition = fn, source = fn }
	} or nil
}

local tilesSeenCollection = EventNames.TilesSeenCollection
local v9 = {
	context = contexts.HomePage,
	eventType = eventTypes.UserSeenCollection,
	formatRulesForAdditionalInfo = 0
}
local v10 = {
	userId = fn,
	absolutePosition = fn,
	presence = fn,
	recommendationRank = fn,
	friendStatus = fn,
	recommendationContextType = fn,
	isRecommendation = fn,
	universeId = fn,
	tileCount = fn,
	source = fn,
	sessionEventCount = fn,
	contentType = if fFlagLuaAppUserSeenCollectionUnifiedFields then fn else nil,
	interactionUuid = if fFlagLuaAppUserSeenCollectionUnifiedFields then fn else nil,
	collectionId = if fFlagLuaAppUserSeenCollectionUnifiedFields then fn else nil,
	collectionPosition = if fFlagLuaAppUserSeenCollectionUnifiedFields then fn else nil,
	positionsInRow = if fFlagLuaAppUserSeenCollectionUnifiedFields then fn else nil,
	rowNumbers = if fFlagLuaAppUserSeenCollectionUnifiedFields then fn else nil,
	feedRowNumbers = if fFlagLuaAppUserSeenCollectionUnifiedFields then fn else nil,
	totalNumberOfItems = nil
}

if not fFlagLuaAppUserSeenCollectionUnifiedFields then
	fn = nil
end

v10.totalNumberOfItems = fn
v9.formatRulesForAdditionalInfo = v10
v5[tilesSeenCollection] = v9

return v5
