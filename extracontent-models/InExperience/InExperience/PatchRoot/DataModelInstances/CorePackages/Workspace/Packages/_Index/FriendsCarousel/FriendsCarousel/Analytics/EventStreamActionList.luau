local parent = script.Parent.Parent
local parent2 = parent.Parent

local EventNames = require(script.Parent.EventNames)
local SocialLuaAnalytics = require(parent2.SocialLuaAnalytics)

local Enums = SocialLuaAnalytics.Analytics.Enums
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes
local BtnValues = require(script.Parent.BtnValues)
local Constants = require(parent.Common.Constants)

local formatFriendStatus = require(script.Parent.formatFriendStatus)
local getUniverseIdFromUser = require(script.Parent.getUniverseIdFromUser)
local formatRecommendationContextType = SocialLuaAnalytics.Analytics.Formatters.formatRecommendationContextType
local formatPresence = SocialLuaAnalytics.Analytics.Formatters.formatPresence

local getFIntShowFriendRecommendationsLimit = require(parent.Flags.getFIntShowFriendRecommendationsLimit)

local function fn(p)
	return p
end

return {
	[EventNames.CarouselLoadedWithUsers] = {
		context = Contexts.HomePage,
		eventType = EventTypes.FriendsCarouselLoaded,
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
		context = Contexts.HomePage,
		eventType = EventTypes.UserSeen,
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
		context = Contexts.HomePage,
		eventType = EventTypes.ButtonClick,
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
		context = Contexts.HomePage,
		eventType = EventTypes.ButtonClick,
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
		context = Contexts.HomePage,
		eventType = EventTypes.ButtonClick,
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
		context = Contexts.HomePage,
		eventType = EventTypes.ButtonClick,
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
		context = Contexts.AddFriends,
		eventType = EventTypes.ButtonClick,
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
		context = Contexts.HomePage,
		eventType = EventTypes.CarouselLoadingTime,
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
		context = Contexts.HomePage,
		eventType = EventTypes.ContactImporterOnAddFriends,
		additionalInfo = { isLegacyAddFriends = false }
	},
	[EventNames.PaginatedFriendsCarouselLoadingTime] = {
		context = Contexts.HomePage,
		eventType = EventTypes.LoadingTime,
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
		context = Contexts.HomePage,
		eventType = EventTypes.LoadingTime,
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
		context = Contexts.HomePage,
		eventType = EventTypes.LoadingTime,
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
