local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local SharedFlags = require(parent.SharedFlags)
local formatRecommendationContextType = SocialLuaAnalytics.Analytics.Formatters.formatRecommendationContextType
local Enums = SocialLuaAnalytics.Analytics.Enums
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes

local EventNames = require(script.Parent.EventNames)
local Constants = require(SocialCarousel.Common.Constants)
local Flags = require(SocialCarousel.Flags)
local FIntSocialCarouselShowRecsLimit = Flags.FIntSocialCarouselShowRecsLimit
local FFlagSocialCarouselShareQREnabled = SharedFlags.FFlagSocialCarouselShareQREnabled
local FFlagLuaAppUserSeenCollectionUnifiedFields = SharedFlags.FFlagLuaAppUserSeenCollectionUnifiedFields

local FFlagSocialCarouselLogNewFriendRequestsBadge = require(SocialCarousel.Flags.FFlagSocialCarouselLogNewFriendRequestsBadge)

local function fn(p)
	return p
end

local EventStreamActionList = {
	[EventNames.UserPressed] = {
		context = Contexts.HomePage,
		eventType = EventTypes.ButtonClick,
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
			interactionUuid = fn
		}
	},
	[EventNames.UserSeen] = {
		context = Contexts.HomePage,
		eventType = EventTypes.UserSeen,
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
		context = Contexts.AddFriends,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = Constants.ANALYTICS.BTN_VALUES.ADD_FRIENDS,
			absolutePosition = fn,
			positionInRow = fn,
			contentType = Constants.ANALYTICS.CONTENT_TYPE,
			actionType = Constants.ANALYTICS.ACTION_TYPES.OPEN_ADD_FRIENDS
		},
		formatRulesForAdditionalInfo = {
			friendCount = fn,
			recommendationLimit = FIntSocialCarouselShowRecsLimit,
			recommendationCount = fn,
			requestCount = fn,
			source = fn,
			interactionUuid = fn
		}
	},
	[EventNames.AddFriendsTileSeen] = FFlagSocialCarouselLogNewFriendRequestsBadge and {
		context = Contexts.HomePage,
		eventType = EventTypes.AddFriendsTileSeen,
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
		context = Contexts.HomePage,
		eventType = EventTypes.ButtonClick,
		additionalInfo = { btn = Constants.ANALYTICS.BTN_VALUES.VIEW_ALL_FRIENDS },
		formatRulesForAdditionalInfo = {
			friendCount = fn,
			recommendationLimit = FIntSocialCarouselShowRecsLimit,
			recommendationCount = fn,
			source = fn
		}
	},
	[EventNames.FriendsCarouselUILoadingTime] = {
		context = Contexts.HomePage,
		eventType = EventTypes.LoadingTime,
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
		context = Contexts.HomePage,
		eventType = EventTypes.ButtonClick,
		additionalInfo = { btn = Constants.ANALYTICS.BTN_VALUES.START_SQUAD },
		formatRulesForAdditionalInfo = { absolutePosition = fn, source = fn }
	},
	[EventNames.ShareQRPressed] = FFlagSocialCarouselShareQREnabled and {
		context = Contexts.HomePage,
		eventType = EventTypes.ButtonClick,
		additionalInfo = { btn = Constants.ANALYTICS.BTN_VALUES.SHARE_QR },
		formatRulesForAdditionalInfo = { absolutePosition = fn, source = fn }
	} or nil
}

local TilesSeenCollection = EventNames.TilesSeenCollection
local v = {
	context = Contexts.HomePage,
	eventType = EventTypes.UserSeenCollection,
	formatRulesForAdditionalInfo = 0
}
local contentType

if FFlagLuaAppUserSeenCollectionUnifiedFields then
	contentType = fn
end

local interactionUuid

if FFlagLuaAppUserSeenCollectionUnifiedFields then
	interactionUuid = fn
end

local collectionId

if FFlagLuaAppUserSeenCollectionUnifiedFields then
	collectionId = fn
end

local collectionPosition

if FFlagLuaAppUserSeenCollectionUnifiedFields then
	collectionPosition = fn
end

local positionsInRow

if FFlagLuaAppUserSeenCollectionUnifiedFields then
	positionsInRow = fn
end

local rowNumbers

if FFlagLuaAppUserSeenCollectionUnifiedFields then
	rowNumbers = fn
end

local feedRowNumbers

if FFlagLuaAppUserSeenCollectionUnifiedFields then
	feedRowNumbers = fn
end

local formatRulesForAdditionalInfo = {
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
	contentType = contentType,
	interactionUuid = interactionUuid,
	collectionId = collectionId,
	collectionPosition = collectionPosition,
	positionsInRow = positionsInRow,
	rowNumbers = rowNumbers,
	feedRowNumbers = feedRowNumbers,
	totalNumberOfItems = nil
}

if not FFlagLuaAppUserSeenCollectionUnifiedFields then
	fn = nil
end

formatRulesForAdditionalInfo.totalNumberOfItems = fn
v.formatRulesForAdditionalInfo = formatRulesForAdditionalInfo
EventStreamActionList[TilesSeenCollection] = v

return EventStreamActionList
