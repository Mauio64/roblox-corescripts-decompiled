local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies")

local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics/EventNames")
local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SocialLuaAnalytics")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SharedFlags")

local enums = SocialLuaAnalytics.Analytics.Enums
local contexts = enums.Contexts
local eventTypes = enums.EventTypes
local BtnValues = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics/BtnValues")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/Constants")

local formatRecommendationContextType = SocialLuaAnalytics.Analytics.Formatters.formatRecommendationContextType

local getFFlagPYMKAddFriendsEntry = dependencies.getFFlagPYMKAddFriendsEntry
local fFlagLuaAppPYMKSendUserSeenCollection = SharedFlags.FFlagLuaAppPYMKSendUserSeenCollection
local fFlagLuaAppUserSeenCollectionUnifiedFields = SharedFlags.FFlagLuaAppUserSeenCollectionUnifiedFields

local function fn(p2)
	return p2
end

local function fn2(p2)
	if p2 then
		return (tostring(p2))
	end

	return nil
end

local v5 = {
	[EventNames.CarouselLoadedWithUsers] = {
		context = contexts.HomePage,
		eventType = eventTypes.FriendsCarouselLoaded,
		additionalInfo = { source = Constants.HomepagePYMKCarouselSourceName },
		formatRulesForAdditionalInfo = {
			recommendationCount = fn,
			recommendationLimit = nil,
			refreshCount = fn
		}
	},
	[EventNames.PYMKCarouselLoadingTime] = {
		context = contexts.HomePage,
		eventType = eventTypes.LoadingTime,
		additionalInfo = { source = Constants.HomepagePYMKCarouselSourceName },
		formatRulesForAdditionalInfo = { loadingTime = fn }
	},
	[EventNames.UserSeen] = {
		context = contexts.HomePage,
		eventType = eventTypes.UserSeen,
		additionalInfo = {
			source = Constants.HomepagePYMKCarouselSourceName,
			isRecommendation = true
		},
		formatRulesForAdditionalInfo = {
			absolutePosition = fn,
			recommendationContextType = formatRecommendationContextType,
			friendStatus = fn,
			recommendationRank = fn,
			userId = fn,
			contactId = fn,
			presence = fn2
		}
	},
	[EventNames.UserPressed] = {
		context = contexts.HomePage,
		eventType = eventTypes.ButtonClick,
		additionalInfo = {
			source = Constants.HomepagePYMKCarouselSourceName,
			isRecommendation = true,
			btn = BtnValues.OpenPeopleList,
			contentType = "User",
			actionType = "OpenProfile"
		},
		formatRulesForAdditionalInfo = {
			absolutePosition = fn,
			positionInRow = fn,
			recommendationContextType = formatRecommendationContextType,
			recommendationId = fn,
			friendStatus = fn,
			recommendationRank = fn,
			contactId = fn,
			presence = fn2,
			interactionUuid = fn
		}
	},
	[EventNames.RequestFriendship] = {
		context = contexts.HomePage,
		eventType = eventTypes.ButtonClick,
		additionalInfo = {
			btn = BtnValues.RequestFriendship,
			source = Constants.HomepagePYMKCarouselSourceName,
			contentType = "User",
			actionType = "RequestFriendship"
		},
		formatRulesForAdditionalInfo = {
			absolutePosition = fn,
			positionInRow = fn,
			recommendationContextType = formatRecommendationContextType,
			recommendationRank = fn,
			requestedId = fn,
			contactId = fn,
			presence = fn2,
			interactionUuid = fn
		}
	},
	[EventNames.AcceptFriendship] = {
		context = contexts.HomePage,
		eventType = eventTypes.ButtonClick,
		additionalInfo = {
			btn = BtnValues.AcceptFriendship,
			source = Constants.HomepagePYMKCarouselSourceName
		},
		formatRulesForAdditionalInfo = {
			absolutePosition = fn,
			recommendationContextType = formatRecommendationContextType,
			recommendationRank = fn,
			requestedId = fn,
			presence = fn2
		}
	},
	[EventNames.PYMKUserPresenceLoad] = {
		context = contexts.HomePage,
		eventType = eventTypes.LoadingTime,
		additionalInfo = { source = "HomepagePYMKUserPresence" },
		formatRulesForAdditionalInfo = { loadingTime = fn }
	}
}

local userSeenCollection = EventNames.UserSeenCollection
local v6

if fFlagLuaAppPYMKSendUserSeenCollection then
	v6 = {
		context = contexts.HomePage,
		eventType = eventTypes.UserSeenCollection,
		additionalInfo = { source = Constants.HomepagePYMKCarouselSourceName },
		formatRulesForAdditionalInfo = 0
	}

	v6.formatRulesForAdditionalInfo = {
		userId = fn,
		absolutePosition = fn,
		presence = fn,
		recommendationRank = fn,
		friendStatus = fn,
		recommendationContextType = fn,
		isRecommendation = fn,
		universeId = fn,
		tileCount = fn,
		sessionEventCount = fn,
		contentType = if fFlagLuaAppUserSeenCollectionUnifiedFields then fn else nil,
		interactionUuid = if fFlagLuaAppUserSeenCollectionUnifiedFields then fn else nil,
		collectionId = if fFlagLuaAppUserSeenCollectionUnifiedFields then fn else nil,
		collectionPosition = if fFlagLuaAppUserSeenCollectionUnifiedFields then fn else nil,
		positionsInRow = if fFlagLuaAppUserSeenCollectionUnifiedFields then fn else nil,
		rowNumbers = if fFlagLuaAppUserSeenCollectionUnifiedFields then fn else nil,
		feedRowNumbers = if fFlagLuaAppUserSeenCollectionUnifiedFields then fn else nil,
		totalNumberOfItems = if fFlagLuaAppUserSeenCollectionUnifiedFields then fn else nil
	}
end

v5[userSeenCollection] = v6

if getFFlagPYMKAddFriendsEntry() then
	local v7 = {
		context = contexts.HomePage,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { source = Constants.HomepagePYMKCarouselSourceName },
		formatRulesForAdditionalInfo = { btn = fn }
	}

	v5[EventNames.CarouselGenericTileClicked] = v7
end

return v5
