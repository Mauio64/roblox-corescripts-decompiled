local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
local parent2 = parent.Parent
local EventNames = require(script.Parent.EventNames)
local SocialLuaAnalytics = require(parent2.SocialLuaAnalytics)
local SharedFlags = require(parent2.SharedFlags)

local Enums = SocialLuaAnalytics.Analytics.Enums
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes
local BtnValues = require(script.Parent.BtnValues)
local Constants = require(parent.Common.Constants)

local formatRecommendationContextType = SocialLuaAnalytics.Analytics.Formatters.formatRecommendationContextType

local getFFlagPYMKAddFriendsEntry = dependencies.getFFlagPYMKAddFriendsEntry
local FFlagLuaAppPYMKSendUserSeenCollection = SharedFlags.FFlagLuaAppPYMKSendUserSeenCollection
local FFlagLuaAppUserSeenCollectionUnifiedFields = SharedFlags.FFlagLuaAppUserSeenCollectionUnifiedFields

local function fn(p)
	return p
end

local function fn2(p)
	if p then
		return (tostring(p))
	end

	return nil
end

local EventStreamActionList = {
	[EventNames.CarouselLoadedWithUsers] = {
		context = Contexts.HomePage,
		eventType = EventTypes.FriendsCarouselLoaded,
		additionalInfo = { source = Constants.HomepagePYMKCarouselSourceName },
		formatRulesForAdditionalInfo = {
			recommendationCount = fn,
			recommendationLimit = nil,
			refreshCount = fn
		}
	},
	[EventNames.PYMKCarouselLoadingTime] = {
		context = Contexts.HomePage,
		eventType = EventTypes.LoadingTime,
		additionalInfo = { source = Constants.HomepagePYMKCarouselSourceName },
		formatRulesForAdditionalInfo = { loadingTime = fn }
	},
	[EventNames.UserSeen] = {
		context = Contexts.HomePage,
		eventType = EventTypes.UserSeen,
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
		context = Contexts.HomePage,
		eventType = EventTypes.ButtonClick,
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
		context = Contexts.HomePage,
		eventType = EventTypes.ButtonClick,
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
		context = Contexts.HomePage,
		eventType = EventTypes.ButtonClick,
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
		context = Contexts.HomePage,
		eventType = EventTypes.LoadingTime,
		additionalInfo = { source = "HomepagePYMKUserPresence" },
		formatRulesForAdditionalInfo = { loadingTime = fn }
	}
}

local UserSeenCollection = EventNames.UserSeenCollection
local v

if FFlagLuaAppPYMKSendUserSeenCollection then
	v = {
		context = Contexts.HomePage,
		eventType = EventTypes.UserSeenCollection,
		additionalInfo = { source = Constants.HomepagePYMKCarouselSourceName },
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

	local totalNumberOfItems

	if FFlagLuaAppUserSeenCollectionUnifiedFields then
		totalNumberOfItems = fn
	end

	v.formatRulesForAdditionalInfo = {
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
		contentType = contentType,
		interactionUuid = interactionUuid,
		collectionId = collectionId,
		collectionPosition = collectionPosition,
		positionsInRow = positionsInRow,
		rowNumbers = rowNumbers,
		feedRowNumbers = feedRowNumbers,
		totalNumberOfItems = totalNumberOfItems
	}
end

EventStreamActionList[UserSeenCollection] = v

if getFFlagPYMKAddFriendsEntry() then
	local v2 = {
		context = Contexts.HomePage,
		eventType = EventTypes.ButtonClick,
		additionalInfo = { source = Constants.HomepagePYMKCarouselSourceName },
		formatRulesForAdditionalInfo = { btn = fn }
	}

	EventStreamActionList[EventNames.CarouselGenericTileClicked] = v2
end

return EventStreamActionList
