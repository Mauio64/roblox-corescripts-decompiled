local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/React")
local impressionsTagUtility = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/Impressions").ImpressionsTagUtility

local roduxFriends = dependencies.RoduxFriends
local useSelector = dependencies.Hooks.useSelector
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local usePrimaryCta = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Components/PYMKUser/usePrimaryCta")
local useContextualInfo = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Components/PYMKUser/useContextualInfo")
local useUserPresence = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Components/PYMKUser/useUserPresence")
local useOnActivatedTile = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Components/PYMKUser/useOnActivatedTile")
require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/DirectRecommendationTypes")
require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics/AnalyticsTypes")

local FFlagPymkCarouselPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Flags/FFlagPymkCarouselPresenceStoreMigration")
local fFlagLuaAppEnableSduiHomePage = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SharedFlags").FFlagLuaAppEnableSduiHomePage
local fFlagPymkCarouselExtendProps = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SharedFlags").FFlagPymkCarouselExtendProps

require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/UserList")

return function(data)
	local id = tostring(data.entity.id)

	local ref = React.useRef(nil)
	React.useEffect(function()
		impressionsTagUtility.AddTag(ref, data.impressionsTag, data.absolutePosition)
		return function()
			impressionsTagUtility.RemoveTag(ref, data.impressionsTag, data.absolutePosition)
		end
	end, { data.impressionsTag, data.absolutePosition })
	local v5

	if fFlagLuaAppEnableSduiHomePage then
		v5 = nil
	else
		v5 = useSelector(function(p2)
			return (tostring(p2.LocalUserId))
		end)
	end

	local v6, v7

	if fFlagLuaAppEnableSduiHomePage then
		if data.recommendation then
			v6 = data.recommendation.hasIncomingFriendRequest
		end

		v7 = data.recommendation or {}
	elseif fFlagPymkCarouselExtendProps then
		v6 = useSelector(function(p2)
			return getDeepValue(
				p2,
				string.format("PYMKCarousel.Friends.recommendations.hasIncomingFriendRequest.%s", id)
			)
		end)

		v7 = useSelector(function(p2)
			return roduxFriends.Selectors.selectRecommendationsForUserId(p2)(v5)[id] or {}
		end)

		if data.recommendation then
			v6 = data.recommendation.hasIncomingFriendRequest
			v7 = data.recommendation
		end
	else
		v6 = useSelector(function(p2)
			return getDeepValue(
				p2,
				string.format("PYMKCarousel.Friends.recommendations.hasIncomingFriendRequest.%s", id)
			)
		end)

		v7 = useSelector(function(p2)
			return roduxFriends.Selectors.selectRecommendationsForUserId(p2)(v5)[id] or {}
		end)
	end

	local v8 = useSelector(function(p2)
		return roduxFriends.Selectors.selectFriendshipStatusesByUserIds(p2)({
			userId = id
		})[id] or nil
	end)

	local v10 = {
		entityId = id,
		showToast = data.showToast,
		fireAnalyticsEvent = data.fireAnalyticsEvent,
		absolutePosition = data.absolutePosition,
		entityType = data.entity.type,
		recommendation = 0
	}

	local v11 = if fFlagPymkCarouselExtendProps or fFlagLuaAppEnableSduiHomePage then data.recommendation else nil
	v10.recommendation = v11
	local v12 = usePrimaryCta(v10)

	local v13 = useContextualInfo({ recommendation = v7, hasIncomingFriendRequest = v6 })

	local v14 = {
		subtitle = false,
		contextualInfo = v7.contextType == nil
	}

	local v16 = { userId = id, entityType = 0, forceFetchUserPresence = 0 }

	local v17 = if FFlagPymkCarouselPresenceStoreMigration then data.entity.type else nil
	v16.entityType = v17
	local v18 = if FFlagPymkCarouselPresenceStoreMigration then data.forceFetchUserPresence else nil
	v16.forceFetchUserPresence = v18
	local v19 = useUserPresence(v16)

	local v21 = {
		userId = id,
		openProfilePeekView = data.openProfilePeekView,
		absolutePosition = data.absolutePosition,
		recommendation = v7,
		recommendationSessionId = data.recommendationSessionId,
		fireAnalyticsEvent = data.fireAnalyticsEvent,
		friendshipStatus = v8,
		userPresenceType = v19,
		analyticsSurface = 0
	}

	local v22 = if fFlagPymkCarouselExtendProps then data.analyticsSurface else nil
	v21.analyticsSurface = v22
	local v23 = useOnActivatedTile(v21)

	local row = data.createRow({
		primaryCta = v12,
		secondaryCta = nil,
		contextualInfo = v13,
		loadingState = v14,
		presence = v19,
		trailingContent = nil,
		onRowActivated = v23
	})

	if row then
		return React.cloneElement(row, { ref = ref })
	end

	return nil
end
