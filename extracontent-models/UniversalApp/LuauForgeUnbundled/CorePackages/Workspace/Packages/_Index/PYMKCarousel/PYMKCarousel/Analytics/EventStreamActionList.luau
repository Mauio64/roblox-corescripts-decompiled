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
local fFlagPymkCarouselExtendProps = SharedFlags.FFlagPymkCarouselExtendProps

local function fn(p2)
	return p2
end

local function fn2(p2)
	if p2 then
		return (tostring(p2))
	end

	return nil
end

local carouselLoadedWithUsers = EventNames.CarouselLoadedWithUsers
local v6 = {
	context = contexts.HomePage,
	eventType = eventTypes.FriendsCarouselLoaded,
	additionalInfo = 0,
	formatRulesForAdditionalInfo = 0
}

local v8 = if not fFlagPymkCarouselExtendProps then Constants.HomepagePYMKCarouselSourceName else nil
v6.additionalInfo = { source = v8 }

v6.formatRulesForAdditionalInfo = {
	recommendationCount = fn,
	recommendationLimit = nil,
	refreshCount = fn
}
local v5 = { [carouselLoadedWithUsers] = v6 }

local pymkCarouselLoadingTime = EventNames.PYMKCarouselLoadingTime
local v9 = {
	context = contexts.HomePage,
	eventType = eventTypes.LoadingTime,
	additionalInfo = 0,
	formatRulesForAdditionalInfo = 0
}

local v11 = if not fFlagPymkCarouselExtendProps then Constants.HomepagePYMKCarouselSourceName else nil
v9.additionalInfo = { source = v11 }

v9.formatRulesForAdditionalInfo = { loadingTime = fn }
v5[pymkCarouselLoadingTime] = v9

local userSeen = EventNames.UserSeen
local v12 = {
	context = contexts.HomePage,
	eventType = eventTypes.UserSeen,
	additionalInfo = 0,
	formatRulesForAdditionalInfo = 0
}

local v14 = if not fFlagPymkCarouselExtendProps then Constants.HomepagePYMKCarouselSourceName else nil
v12.additionalInfo = { source = v14, isRecommendation = true }

v12.formatRulesForAdditionalInfo = {
	absolutePosition = fn,
	recommendationContextType = formatRecommendationContextType,
	friendStatus = fn,
	recommendationRank = fn,
	userId = fn,
	contactId = fn,
	presence = fn2
}
v5[userSeen] = v12

local userPressed = EventNames.UserPressed
local v15 = {
	context = contexts.HomePage,
	eventType = eventTypes.ButtonClick,
	additionalInfo = 0,
	formatRulesForAdditionalInfo = 0
}

local v17 = if not fFlagPymkCarouselExtendProps then Constants.HomepagePYMKCarouselSourceName else nil
v15.additionalInfo = {
	source = v17,
	isRecommendation = true,
	btn = BtnValues.OpenPeopleList,
	contentType = "User",
	actionType = "OpenProfile"
}

v15.formatRulesForAdditionalInfo = {
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
v5[userPressed] = v15

local requestFriendship = EventNames.RequestFriendship
local v18 = {
	context = contexts.HomePage,
	eventType = eventTypes.ButtonClick,
	additionalInfo = 0,
	formatRulesForAdditionalInfo = 0
}
local v19 = {
	btn = BtnValues.RequestFriendship,
	source = 0,
	contentType = "User",
	actionType = "RequestFriendship"
}
local v20 = if not fFlagPymkCarouselExtendProps then Constants.HomepagePYMKCarouselSourceName else nil
v19.source = v20
v18.additionalInfo = v19

v18.formatRulesForAdditionalInfo = {
	absolutePosition = fn,
	positionInRow = fn,
	recommendationContextType = formatRecommendationContextType,
	recommendationRank = fn,
	requestedId = fn,
	contactId = fn,
	presence = fn2,
	interactionUuid = fn
}
v5[requestFriendship] = v18

local acceptFriendship = EventNames.AcceptFriendship
local v21 = {
	context = contexts.HomePage,
	eventType = eventTypes.ButtonClick,
	additionalInfo = 0,
	formatRulesForAdditionalInfo = 0
}
local v22 = { btn = BtnValues.AcceptFriendship, source = 0 }
local v23 = if not fFlagPymkCarouselExtendProps then Constants.HomepagePYMKCarouselSourceName else nil
v22.source = v23
v21.additionalInfo = v22

v21.formatRulesForAdditionalInfo = {
	absolutePosition = fn,
	recommendationContextType = formatRecommendationContextType,
	recommendationRank = fn,
	requestedId = fn,
	presence = fn2
}
v5[acceptFriendship] = v21

v5[EventNames.PYMKUserPresenceLoad] = {
	context = contexts.HomePage,
	eventType = eventTypes.LoadingTime,
	additionalInfo = { source = "HomepagePYMKUserPresence" },
	formatRulesForAdditionalInfo = { loadingTime = fn }
}

local userSeenCollection = EventNames.UserSeenCollection
local v24

if fFlagLuaAppPYMKSendUserSeenCollection then
	v24 = {
		context = contexts.HomePage,
		eventType = eventTypes.UserSeenCollection,
		additionalInfo = 0,
		formatRulesForAdditionalInfo = 0
	}

	local v26 = if not fFlagPymkCarouselExtendProps then Constants.HomepagePYMKCarouselSourceName else nil
	v24.additionalInfo = { source = v26 }

	v24.formatRulesForAdditionalInfo = {
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

v5[userSeenCollection] = v24

if not getFFlagPYMKAddFriendsEntry() then
	return v5
end

local v25 = {
	context = contexts.HomePage,
	eventType = eventTypes.ButtonClick,
	additionalInfo = 0,
	formatRulesForAdditionalInfo = 0
}

local v27 = if not fFlagPymkCarouselExtendProps then Constants.HomepagePYMKCarouselSourceName else nil
v25.additionalInfo = { source = v27 }

v25.formatRulesForAdditionalInfo = { btn = fn }

v5[EventNames.CarouselGenericTileClicked] = v25

return v5
