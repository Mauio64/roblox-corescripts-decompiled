local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
local parent2 = parent.Parent

local React = require(parent2.React)
local Impressions = require(parent2.Impressions)
local ImpressionsTagUtility = Impressions.ImpressionsTagUtility

local roduxFriends = dependencies.RoduxFriends
local useSelector = dependencies.Hooks.useSelector
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local usePrimaryCta = require(parent.Components.PYMKUser.usePrimaryCta)
local useContextualInfo = require(parent.Components.PYMKUser.useContextualInfo)
local useUserPresence = require(parent.Components.PYMKUser.useUserPresence)
local useOnActivatedTile = require(parent.Components.PYMKUser.useOnActivatedTile)
require(parent.Common.DirectRecommendationTypes)
require(parent.Analytics.AnalyticsTypes)

local FFlagPymkCarouselPresenceStoreMigration = require(parent.Flags.FFlagPymkCarouselPresenceStoreMigration)
local SharedFlags = require(parent2.SharedFlags)
local FFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage
local SharedFlags2 = require(parent2.SharedFlags)
local FFlagPymkCarouselExtendProps = SharedFlags2.FFlagPymkCarouselExtendProps

require(parent2.UserList)

return function(data)
	local id = tostring(data.entity.id)

	local ref = React.useRef(nil)
	React.useEffect(function()
		ImpressionsTagUtility.AddTag(ref, data.impressionsTag, data.absolutePosition)
		return function()
			ImpressionsTagUtility.RemoveTag(ref, data.impressionsTag, data.absolutePosition)
		end
	end, { data.impressionsTag, data.absolutePosition })
	local v

	if FFlagLuaAppEnableSduiHomePage then
		v = nil
	else
		v = useSelector(function(p)
			return (tostring(p.LocalUserId))
		end)
	end

	local hasIncomingFriendRequest, recommendation

	if FFlagLuaAppEnableSduiHomePage then
		if data.recommendation then
			hasIncomingFriendRequest = data.recommendation.hasIncomingFriendRequest
		end

		recommendation = data.recommendation or {}
	elseif FFlagPymkCarouselExtendProps then
		hasIncomingFriendRequest = useSelector(function(p)
			return getDeepValue(
				p,
				string.format("PYMKCarousel.Friends.recommendations.hasIncomingFriendRequest.%s", id)
			)
		end)

		recommendation = useSelector(function(p)
			return roduxFriends.Selectors.selectRecommendationsForUserId(p)(v)[id] or {}
		end)

		if data.recommendation then
			hasIncomingFriendRequest = data.recommendation.hasIncomingFriendRequest
			recommendation = data.recommendation
		end
	else
		hasIncomingFriendRequest = useSelector(function(p)
			return getDeepValue(
				p,
				string.format("PYMKCarousel.Friends.recommendations.hasIncomingFriendRequest.%s", id)
			)
		end)

		recommendation = useSelector(function(p)
			return roduxFriends.Selectors.selectRecommendationsForUserId(p)(v)[id] or {}
		end)
	end

	local friendshipStatus = useSelector(function(p)
		return roduxFriends.Selectors.selectFriendshipStatusesByUserIds(p)({ userId = id })[id] or nil
	end)

	local v2 = {
		entityId = id,
		showToast = data.showToast,
		fireAnalyticsEvent = data.fireAnalyticsEvent,
		absolutePosition = data.absolutePosition,
		entityType = data.entity.type,
		recommendation = 0
	}
	local recommendation2

	if FFlagPymkCarouselExtendProps or FFlagLuaAppEnableSduiHomePage then
		recommendation2 = data.recommendation
	end

	v2.recommendation = recommendation2
	local primaryCta = usePrimaryCta(v2)

	local contextualInfo = useContextualInfo({
		recommendation = recommendation,
		hasIncomingFriendRequest = hasIncomingFriendRequest
	})

	local loadingState = {
		subtitle = false,
		contextualInfo = recommendation.contextType == nil
	}

	local v3 = { userId = id, entityType = 0, forceFetchUserPresence = 0 }
	local entityType

	if FFlagPymkCarouselPresenceStoreMigration then
		entityType = data.entity.type
	end

	v3.entityType = entityType
	local forceFetchUserPresence

	if FFlagPymkCarouselPresenceStoreMigration then
		forceFetchUserPresence = data.forceFetchUserPresence
	end

	v3.forceFetchUserPresence = forceFetchUserPresence
	local v4 = useUserPresence(v3)

	local v5 = {
		userId = id,
		openProfilePeekView = data.openProfilePeekView,
		absolutePosition = data.absolutePosition,
		recommendation = recommendation,
		recommendationSessionId = data.recommendationSessionId,
		fireAnalyticsEvent = data.fireAnalyticsEvent,
		friendshipStatus = friendshipStatus,
		userPresenceType = v4,
		analyticsSurface = 0
	}
	local analyticsSurface

	if FFlagPymkCarouselExtendProps then
		analyticsSurface = data.analyticsSurface
	end

	v5.analyticsSurface = analyticsSurface
	local onRowActivated = useOnActivatedTile(v5)

	local row = data.createRow({
		primaryCta = primaryCta,
		secondaryCta = nil,
		contextualInfo = contextualInfo,
		loadingState = loadingState,
		presence = v4,
		trailingContent = nil,
		onRowActivated = onRowActivated
	})

	if row then
		return React.cloneElement(row, { ref = ref })
	end

	return nil
end
