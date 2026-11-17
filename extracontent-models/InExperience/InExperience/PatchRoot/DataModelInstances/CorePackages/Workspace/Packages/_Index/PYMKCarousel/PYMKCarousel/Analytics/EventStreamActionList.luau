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
local FFlagPymkCarouselExtendProps = SharedFlags.FFlagPymkCarouselExtendProps

local function fn(p)
	return p
end

local function fn2(p)
	if p then
		return (tostring(p))
	end

	return nil
end

local CarouselLoadedWithUsers = EventNames.CarouselLoadedWithUsers
local v = {
	context = Contexts.HomePage,
	eventType = EventTypes.FriendsCarouselLoaded,
	additionalInfo = 0,
	formatRulesForAdditionalInfo = 0
}
local source

if not FFlagPymkCarouselExtendProps then
	source = Constants.HomepagePYMKCarouselSourceName
end

v.additionalInfo = { source = source }

v.formatRulesForAdditionalInfo = {
	recommendationCount = fn,
	recommendationLimit = nil,
	refreshCount = fn
}
local EventStreamActionList = { [CarouselLoadedWithUsers] = v }

local PYMKCarouselLoadingTime = EventNames.PYMKCarouselLoadingTime
local v2 = {
	context = Contexts.HomePage,
	eventType = EventTypes.LoadingTime,
	additionalInfo = 0,
	formatRulesForAdditionalInfo = 0
}
local source2

if not FFlagPymkCarouselExtendProps then
	source2 = Constants.HomepagePYMKCarouselSourceName
end

v2.additionalInfo = { source = source2 }

v2.formatRulesForAdditionalInfo = { loadingTime = fn }
EventStreamActionList[PYMKCarouselLoadingTime] = v2

local UserSeen = EventNames.UserSeen
local v3 = {
	context = Contexts.HomePage,
	eventType = EventTypes.UserSeen,
	additionalInfo = 0,
	formatRulesForAdditionalInfo = 0
}
local source3

if not FFlagPymkCarouselExtendProps then
	source3 = Constants.HomepagePYMKCarouselSourceName
end

v3.additionalInfo = { source = source3, isRecommendation = true }

v3.formatRulesForAdditionalInfo = {
	absolutePosition = fn,
	recommendationContextType = formatRecommendationContextType,
	friendStatus = fn,
	recommendationRank = fn,
	userId = fn,
	contactId = fn,
	presence = fn2
}
EventStreamActionList[UserSeen] = v3

local UserPressed = EventNames.UserPressed
local v4 = {
	context = Contexts.HomePage,
	eventType = EventTypes.ButtonClick,
	additionalInfo = 0,
	formatRulesForAdditionalInfo = 0
}
local source4

if not FFlagPymkCarouselExtendProps then
	source4 = Constants.HomepagePYMKCarouselSourceName
end

v4.additionalInfo = {
	source = source4,
	isRecommendation = true,
	btn = BtnValues.OpenPeopleList,
	contentType = "User",
	actionType = "OpenProfile"
}

v4.formatRulesForAdditionalInfo = {
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
EventStreamActionList[UserPressed] = v4

local RequestFriendship = EventNames.RequestFriendship
local v5 = {
	context = Contexts.HomePage,
	eventType = EventTypes.ButtonClick,
	additionalInfo = 0,
	formatRulesForAdditionalInfo = 0
}
local additionalInfo = {
	btn = BtnValues.RequestFriendship,
	source = 0,
	contentType = "User",
	actionType = "RequestFriendship"
}
local source5

if not FFlagPymkCarouselExtendProps then
	source5 = Constants.HomepagePYMKCarouselSourceName
end

additionalInfo.source = source5
v5.additionalInfo = additionalInfo

v5.formatRulesForAdditionalInfo = {
	absolutePosition = fn,
	positionInRow = fn,
	recommendationContextType = formatRecommendationContextType,
	recommendationRank = fn,
	requestedId = fn,
	contactId = fn,
	presence = fn2,
	interactionUuid = fn
}
EventStreamActionList[RequestFriendship] = v5

local AcceptFriendship = EventNames.AcceptFriendship
local v6 = {
	context = Contexts.HomePage,
	eventType = EventTypes.ButtonClick,
	additionalInfo = 0,
	formatRulesForAdditionalInfo = 0
}
local additionalInfo2 = { btn = BtnValues.AcceptFriendship, source = 0 }
local source6

if not FFlagPymkCarouselExtendProps then
	source6 = Constants.HomepagePYMKCarouselSourceName
end

additionalInfo2.source = source6
v6.additionalInfo = additionalInfo2

v6.formatRulesForAdditionalInfo = {
	absolutePosition = fn,
	recommendationContextType = formatRecommendationContextType,
	recommendationRank = fn,
	requestedId = fn,
	presence = fn2
}
EventStreamActionList[AcceptFriendship] = v6

EventStreamActionList[EventNames.PYMKUserPresenceLoad] = {
	context = Contexts.HomePage,
	eventType = EventTypes.LoadingTime,
	additionalInfo = { source = "HomepagePYMKUserPresence" },
	formatRulesForAdditionalInfo = { loadingTime = fn }
}

local UserSeenCollection = EventNames.UserSeenCollection
local v7

if FFlagLuaAppPYMKSendUserSeenCollection then
	v7 = {
		context = Contexts.HomePage,
		eventType = EventTypes.UserSeenCollection,
		additionalInfo = 0,
		formatRulesForAdditionalInfo = 0
	}
	local source7

	if not FFlagPymkCarouselExtendProps then
		source7 = Constants.HomepagePYMKCarouselSourceName
	end

	v7.additionalInfo = { source = source7 }
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

	v7.formatRulesForAdditionalInfo = {
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

EventStreamActionList[UserSeenCollection] = v7

if not getFFlagPYMKAddFriendsEntry() then
	return EventStreamActionList
end

local v8 = {
	context = Contexts.HomePage,
	eventType = EventTypes.ButtonClick,
	additionalInfo = 0,
	formatRulesForAdditionalInfo = 0
}
local source7

if not FFlagPymkCarouselExtendProps then
	source7 = Constants.HomepagePYMKCarouselSourceName
end

v8.additionalInfo = { source = source7 }

v8.formatRulesForAdditionalInfo = { btn = fn }

EventStreamActionList[EventNames.CarouselGenericTileClicked] = v8

return EventStreamActionList
