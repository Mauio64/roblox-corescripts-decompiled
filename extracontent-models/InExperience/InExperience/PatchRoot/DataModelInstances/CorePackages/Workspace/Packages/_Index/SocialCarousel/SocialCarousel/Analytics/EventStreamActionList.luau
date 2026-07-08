local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local SocialCarouselParent = SocialCarousel.Parent
local SocialLuaAnalytics = require(SocialCarouselParent.SocialLuaAnalytics)
local formatRecommendationContextType = SocialLuaAnalytics.Analytics.Formatters.formatRecommendationContextType
local Enums = SocialLuaAnalytics.Analytics.Enums
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes
local EventNames = require(script.Parent.EventNames)
local Constants = require(SocialCarousel.Common.Constants)
local FIntSocialCarouselShowRecsLimit = require(SocialCarousel.Flags).FIntSocialCarouselShowRecsLimit
local FFlagLuaAppAddSortDataToSocialCarouselClicks = require(SocialCarouselParent.SharedFlags).FFlagLuaAppAddSortDataToSocialCarouselClicks
local FFlagSocialCarouselShareQREnabled = require(SocialCarouselParent.SharedFlags).FFlagSocialCarouselShareQREnabled

local function v13(p1) -- line: 17
	return p1
end

return {
	[EventNames.UserPressed] = {
		context = Contexts.HomePage,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = Constants.ANALYTICS.BTN_VALUES.OPEN_PEOPLE_LIST,
			contentType = if not FFlagLuaAppAddSortDataToSocialCarouselClicks then nil else Constants.ANALYTICS.CONTENT_TYPE,
			actionType = if not FFlagLuaAppAddSortDataToSocialCarouselClicks then nil else Constants.ANALYTICS.ACTION_TYPES.OPEN_PROFILE
		},
		formatRulesForAdditionalInfo = {
			absolutePosition = v13,
			positionInRow = if not FFlagLuaAppAddSortDataToSocialCarouselClicks then nil else v13,
			recommendationContextType = formatRecommendationContextType,
			friendId = v13,
			friendStatus = v13,
			isRecommendation = v13,
			recommendationRank = v13,
			universeId = v13,
			presence = v13,
			source = v13,
			interactionUuid = v13
		}
	},
	[EventNames.UserSeen] = {
		context = Contexts.HomePage,
		eventType = EventTypes.UserSeen,
		formatRulesForAdditionalInfo = {
			userId = v13,
			presence = v13,
			absolutePosition = v13,
			recommendationRank = v13,
			friendStatus = v13,
			recommendationContextType = formatRecommendationContextType,
			isRecommendation = v13,
			source = v13,
			universeId = v13
		}
	},
	[EventNames.ViewAddFriends] = {
		context = Contexts.AddFriends,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = Constants.ANALYTICS.BTN_VALUES.ADD_FRIENDS,
			absolutePosition = v13,
			positionInRow = v13,
			contentType = Constants.ANALYTICS.CONTENT_TYPE,
			actionType = Constants.ANALYTICS.ACTION_TYPES.OPEN_ADD_FRIENDS
		},
		formatRulesForAdditionalInfo = {
			friendCount = v13,
			recommendationLimit = FIntSocialCarouselShowRecsLimit,
			recommendationCount = v13,
			requestCount = v13,
			source = v13,
			interactionUuid = v13
		}
	},
	[EventNames.ViewAllFriends] = {
		context = Contexts.HomePage,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = Constants.ANALYTICS.BTN_VALUES.VIEW_ALL_FRIENDS
		},
		formatRulesForAdditionalInfo = {
			friendCount = v13,
			recommendationLimit = FIntSocialCarouselShowRecsLimit,
			recommendationCount = v13,
			source = v13
		}
	},
	[EventNames.FriendsCarouselUILoadingTime] = {
		context = Contexts.HomePage,
		eventType = EventTypes.LoadingTime,
		formatRulesForAdditionalInfo = {
			status = v13,
			fetch = v13,
			loadingTime = v13,
			loadingThreshold = v13,
			nextPage = v13,
			source = v13
		},
		additionalInfo = {}
	},
	[EventNames.StartSquadPressed] = {
		context = Contexts.HomePage,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = Constants.ANALYTICS.BTN_VALUES.START_SQUAD
		},
		formatRulesForAdditionalInfo = {
			absolutePosition = v13,
			source = v13
		}
	},
	[EventNames.ShareQRPressed] = if not FFlagSocialCarouselShareQREnabled then nil else {
		context = Contexts.HomePage,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = Constants.ANALYTICS.BTN_VALUES.SHARE_QR
		},
		formatRulesForAdditionalInfo = {
			absolutePosition = v13,
			source = v13
		}
	},
	[EventNames.TilesSeenCollection] = {
		context = Contexts.HomePage,
		eventType = EventTypes.UserSeenCollection,
		formatRulesForAdditionalInfo = {
			userId = v13,
			absolutePosition = v13,
			presence = v13,
			recommendationRank = v13,
			friendStatus = v13,
			recommendationContextType = v13,
			isRecommendation = v13,
			universeId = v13,
			tileCount = v13,
			source = v13,
			sessionEventCount = v13
		}
	}
}
