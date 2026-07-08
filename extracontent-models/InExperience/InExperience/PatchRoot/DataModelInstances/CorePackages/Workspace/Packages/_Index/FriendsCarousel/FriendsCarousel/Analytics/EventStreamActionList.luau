local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local EventNames = require(script.Parent.EventNames)
local SocialLuaAnalytics = require(ParentParentParent.SocialLuaAnalytics)
local Enums = SocialLuaAnalytics.Analytics.Enums
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes
local BtnValues = require(script.Parent.BtnValues)
local Constants = require(ParentParent.Common.Constants)
local formatFriendStatus = require(script.Parent.formatFriendStatus)
local getUniverseIdFromUser = require(script.Parent.getUniverseIdFromUser)
local formatRecommendationContextType = SocialLuaAnalytics.Analytics.Formatters.formatRecommendationContextType
local formatPresence = SocialLuaAnalytics.Analytics.Formatters.formatPresence
local getFIntShowFriendRecommendationsLimit = require(ParentParent.Flags.getFIntShowFriendRecommendationsLimit)

local function v15(p1) -- line: 20
	return p1
end

return {
	[EventNames.CarouselLoadedWithUsers] = {
		context = Contexts.HomePage,
		eventType = EventTypes.FriendsCarouselLoaded,
		additionalInfo = {
			source = Constants.HomepageFriendsCarouselSourceName
		},
		formatRulesForAdditionalInfo = {
			friendCount = v15,
			recommendationCount = v15,
			recommendationLimit = getFIntShowFriendRecommendationsLimit,
			refreshCount = v15,
			experimentLayerStatus = v15,
			fetchedRecommendations = v15,
			recommendationSessionId = v15
		}
	},
	[EventNames.UserSeen] = {
		context = Contexts.HomePage,
		eventType = EventTypes.UserSeen,
		additionalInfo = {
			source = Constants.HomepageFriendsCarouselSourceName
		},
		formatRulesForAdditionalInfo = {
			absolutePosition = v15,
			recommendationContextType = formatRecommendationContextType,
			friendStatus = formatFriendStatus,
			isRecommendation = v15,
			presence = formatPresence,
			recommendationRank = v15,
			userId = v15,
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
			absolutePosition = v15,
			recommendationContextType = formatRecommendationContextType,
			friendId = v15,
			friendStatus = formatFriendStatus,
			isRecommendation = v15,
			recommendationRank = v15,
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
			absolutePosition = v15,
			recommendationContextType = formatRecommendationContextType,
			recommendationRank = v15,
			requestedId = v15
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
			absolutePosition = v15,
			recommendationContextType = formatRecommendationContextType,
			recommendationRank = v15,
			requestedId = v15
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
			friendCount = v15,
			recommendationLimit = getFIntShowFriendRecommendationsLimit,
			recommendationCount = v15
		}
	},
	[EventNames.ViewAddFriends] = {
		context = Contexts.AddFriends,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			absolutePosition = 1,
			btn = BtnValues.AddFriendsButton,
			source = Constants.HomepageFriendsCarouselSourceName
		},
		formatRulesForAdditionalInfo = {
			friendCount = v15,
			recommendationLimit = getFIntShowFriendRecommendationsLimit,
			recommendationCount = v15,
			requestCount = v15,
			showContactImporterModal = v15
		}
	},
	[EventNames.CarouselLoadingTime] = {
		context = Contexts.HomePage,
		eventType = EventTypes.CarouselLoadingTime,
		additionalInfo = {
			source = Constants.HomepageFriendsCarouselSourceName
		},
		formatRulesForAdditionalInfo = {
			carouselFetchingStatus = v15,
			friendsFetchingStatus = v15,
			recommendationFetchingStatus = v15,
			loadingTime = v15,
			reachedThreshold = v15,
			loadingThreshold = v15,
			experimentLayerStatus = v15,
			isLegacyCarousel = v15
		}
	},
	[EventNames.ContactImporterOnAddFriends] = {
		context = Contexts.HomePage,
		eventType = EventTypes.ContactImporterOnAddFriends,
		additionalInfo = {
			isLegacyAddFriends = false
		}
	},
	[EventNames.PaginatedFriendsCarouselLoadingTime] = {
		context = Contexts.HomePage,
		eventType = EventTypes.LoadingTime,
		formatRulesForAdditionalInfo = {
			status = v15,
			loadingTime = v15,
			loadingThreshold = v15,
			nextPage = v15,
			fetch = v15
		},
		additionalInfo = {
			source = Constants.HomepageFriendsCarouselSourceName
		}
	},
	[EventNames.FriendsEndpointLoadingTime] = {
		context = Contexts.HomePage,
		eventType = EventTypes.LoadingTime,
		formatRulesForAdditionalInfo = {
			status = v15,
			loadingTime = v15,
			loadingThreshold = v15,
			nextPage = v15,
			fetch = v15
		},
		additionalInfo = {
			source = Constants.HomepageFriendsCarouselSourceName
		}
	},
	[EventNames.FriendsCarouselUILoadingTime] = {
		context = Contexts.HomePage,
		eventType = EventTypes.LoadingTime,
		formatRulesForAdditionalInfo = {
			status = v15,
			fetch = v15,
			loadingTime = v15,
			loadingThreshold = v15,
			nextPage = v15
		},
		additionalInfo = {
			source = Constants.HomepageFriendsCarouselSourceName
		}
	}
}
