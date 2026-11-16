local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Analytics/EventNames")
local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/SocialLuaAnalytics")

local enums = SocialLuaAnalytics.Analytics.Enums
local contexts = enums.Contexts
local eventTypes = enums.EventTypes
local BtnValues = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Analytics/BtnValues")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Common/Constants")

local formatFriendStatus = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Analytics/formatFriendStatus")
local getUniverseIdFromUser = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Analytics/getUniverseIdFromUser")
local formatRecommendationContextType = SocialLuaAnalytics.Analytics.Formatters.formatRecommendationContextType
local formatPresence = SocialLuaAnalytics.Analytics.Formatters.formatPresence

local getFIntShowFriendRecommendationsLimit = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Flags/getFIntShowFriendRecommendationsLimit")

local function fn(p2)
	return p2
end

return {
	[EventNames.CarouselLoadedWithUsers] = {
		context = contexts.HomePage,
		eventType = eventTypes.FriendsCarouselLoaded,
		additionalInfo = { source = Constants.HomepageFriendsCarouselSourceName },
		formatRulesForAdditionalInfo = {
			friendCount = fn,
			recommendationCount = fn,
			recommendationLimit = getFIntShowFriendRecommendationsLimit,
			refreshCount = fn,
			experimentLayerStatus = fn,
			fetchedRecommendations = fn,
			recommendationSessionId = fn
		}
	},
	[EventNames.UserSeen] = {
		context = contexts.HomePage,
		eventType = eventTypes.UserSeen,
		additionalInfo = { source = Constants.HomepageFriendsCarouselSourceName },
		formatRulesForAdditionalInfo = {
			absolutePosition = fn,
			recommendationContextType = formatRecommendationContextType,
			friendStatus = formatFriendStatus,
			isRecommendation = fn,
			presence = formatPresence,
			recommendationRank = fn,
			userId = fn,
			universeId = getUniverseIdFromUser
		}
	},
	[EventNames.UserPressed] = {
		context = contexts.HomePage,
		eventType = eventTypes.ButtonClick,
		additionalInfo = {
			btn = BtnValues.OpenPeopleList,
			source = Constants.HomepageFriendsCarouselSourceName
		},
		formatRulesForAdditionalInfo = {
			absolutePosition = fn,
			recommendationContextType = formatRecommendationContextType,
			friendId = fn,
			friendStatus = formatFriendStatus,
			isRecommendation = fn,
			recommendationRank = fn,
			universeId = getUniverseIdFromUser,
			presence = formatPresence
		}
	},
	[EventNames.RequestFriendship] = {
		context = contexts.HomePage,
		eventType = eventTypes.ButtonClick,
		additionalInfo = {
			btn = BtnValues.RequestFriendship,
			source = Constants.HomepageFriendsCarouselSourceName
		},
		formatRulesForAdditionalInfo = {
			absolutePosition = fn,
			recommendationContextType = formatRecommendationContextType,
			recommendationRank = fn,
			requestedId = fn
		}
	},
	[EventNames.RevokeFriendRequest] = {
		context = contexts.HomePage,
		eventType = eventTypes.ButtonClick,
		additionalInfo = {
			btn = BtnValues.RevokeFriendRequest,
			source = Constants.HomepageFriendsCarouselSourceName
		},
		formatRulesForAdditionalInfo = {
			absolutePosition = fn,
			recommendationContextType = formatRecommendationContextType,
			recommendationRank = fn,
			requestedId = fn
		}
	},
	[EventNames.ViewAllFriends] = {
		context = contexts.HomePage,
		eventType = eventTypes.ButtonClick,
		additionalInfo = {
			btn = BtnValues.FriendsLanding,
			source = Constants.HomepageFriendsCarouselSourceName
		},
		formatRulesForAdditionalInfo = {
			friendCount = fn,
			recommendationLimit = getFIntShowFriendRecommendationsLimit,
			recommendationCount = fn
		}
	},
	[EventNames.ViewAddFriends] = {
		context = contexts.AddFriends,
		eventType = eventTypes.ButtonClick,
		additionalInfo = {
			btn = BtnValues.AddFriendsButton,
			absolutePosition = 1,
			source = Constants.HomepageFriendsCarouselSourceName
		},
		formatRulesForAdditionalInfo = {
			friendCount = fn,
			recommendationLimit = getFIntShowFriendRecommendationsLimit,
			recommendationCount = fn,
			requestCount = fn,
			showContactImporterModal = fn
		}
	},
	[EventNames.CarouselLoadingTime] = {
		context = contexts.HomePage,
		eventType = eventTypes.CarouselLoadingTime,
		additionalInfo = { source = Constants.HomepageFriendsCarouselSourceName },
		formatRulesForAdditionalInfo = {
			carouselFetchingStatus = fn,
			friendsFetchingStatus = fn,
			recommendationFetchingStatus = fn,
			loadingTime = fn,
			reachedThreshold = fn,
			loadingThreshold = fn,
			experimentLayerStatus = fn,
			isLegacyCarousel = fn
		}
	},
	[EventNames.ContactImporterOnAddFriends] = {
		context = contexts.HomePage,
		eventType = eventTypes.ContactImporterOnAddFriends,
		additionalInfo = { isLegacyAddFriends = false }
	},
	[EventNames.PaginatedFriendsCarouselLoadingTime] = {
		context = contexts.HomePage,
		eventType = eventTypes.LoadingTime,
		formatRulesForAdditionalInfo = {
			status = fn,
			loadingTime = fn,
			loadingThreshold = fn,
			nextPage = fn,
			fetch = fn
		},
		additionalInfo = { source = Constants.HomepageFriendsCarouselSourceName }
	},
	[EventNames.FriendsEndpointLoadingTime] = {
		context = contexts.HomePage,
		eventType = eventTypes.LoadingTime,
		formatRulesForAdditionalInfo = {
			status = fn,
			loadingTime = fn,
			loadingThreshold = fn,
			nextPage = fn,
			fetch = fn
		},
		additionalInfo = { source = Constants.HomepageFriendsCarouselSourceName }
	},
	[EventNames.FriendsCarouselUILoadingTime] = {
		context = contexts.HomePage,
		eventType = eventTypes.LoadingTime,
		formatRulesForAdditionalInfo = {
			status = fn,
			fetch = fn,
			loadingTime = fn,
			loadingThreshold = fn,
			nextPage = fn
		},
		additionalInfo = { source = Constants.HomepageFriendsCarouselSourceName }
	}
}
