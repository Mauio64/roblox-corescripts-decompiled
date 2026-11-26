local HttpService = game:GetService("HttpService")

local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies")

local react = dependencies.React
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/Constants")
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SocialCommon")
require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/UserList")
local recommendationContextType = dependencies.RoduxFriends.Enums.RecommendationContextType
local getRecommendationContextualInfoType = SocialCommon.Utils.getRecommendationContextualInfoType
local Analytics = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics")
local getFriendStatus = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics/getFriendStatus")
local eventNames = Analytics.EventNames
require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics/AnalyticsTypes")
local fFlagPymkCarouselExtendProps = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SharedFlags").FFlagPymkCarouselExtendProps

local function useOnActivatedTile(data)
	local v5 = react.useMemo(function()
		if data.recommendation.mutualFriendsCount then
			return data.recommendation.mutualFriendsCount
		end

		if data.recommendation.mutualFriendsList then
			return #data.recommendation.mutualFriendsList
		end

		return nil
	end, { data.recommendation.mutualFriendsCount, data.recommendation.mutualFriendsList })

	local useCallback = react.useCallback
	local function fn()
		local openProfilePeekView = data.openProfilePeekView
		local userId = data.userId
		local v6 = {
			absolutePosition = data.absolutePosition,
			source = 0,
			isRecommendation = true,
			mutualFriendsCount = 0,
			recommendationSessionId = 0,
			recommendationRank = 0,
			recommendationContextType = 0,
			contextualInfoType = 0,
			contactProps = 0,
			profileType = 0
		}
		local v7

		if fFlagPymkCarouselExtendProps then
			if data.analyticsSurface then
				v7 = data.analyticsSurface.source
			else
				v7 = Constants.HomepagePYMKCarouselSourceName
			end
		else
			v7 = Constants.HomepagePYMKCarouselSourceName
		end

		v6.source = v7

		v6.mutualFriendsCount = v5
		v6.recommendationSessionId = data.recommendationSessionId
		v6.recommendationRank = data.recommendation.rank
		v6.recommendationContextType = data.recommendation.contextType
			and data.recommendation.contextType.rawValue()
			or nil

		v6.contextualInfoType = getRecommendationContextualInfoType(data.recommendation)
		local v8

		if data.recommendation.contextType == recommendationContextType.Contacts then
			v8 = { contactId = data.userId, avatarImageUrl = 0, contactName = 0 }
			local v9 = if data.recommendation.thumbnailEntities then data.recommendation.thumbnailEntities.avatarImageUrl else nil
			v8.avatarImageUrl = v9

			v8.contactName = data.recommendation.entityDisplayName
		end

		v6.contactProps = v8

		v6.profileType = data.recommendation.contextType == recommendationContextType.Contacts
			and "FromContacts"
			or nil
		openProfilePeekView(userId, v6)
	end

	local openProfilePeekView = data.openProfilePeekView
	local userId = data.userId
	local absolutePosition = data.absolutePosition

	local recommendationSessionId = data.recommendationSessionId
	local recommendation = data.recommendation
	local v7 = if fFlagPymkCarouselExtendProps then data.analyticsSurface else nil
	local v8 = useCallback(fn, {
		openProfilePeekView,
		userId,
		absolutePosition,
		v5,
		recommendationSessionId,
		recommendation,
		v7
	})

	return (react.useCallback(function()
		v8()
		local fireAnalyticsEvent = data.fireAnalyticsEvent
		local userPressed = eventNames.UserPressed
		local v9 = {
			recommendationId = data.userId,
			friendStatus = getFriendStatus(data.friendshipStatus, data.recommendation.hasIncomingFriendRequest),
			recommendationContextType = data.recommendation.contextType,
			recommendationRank = data.recommendation.rank,
			absolutePosition = data.absolutePosition,
			positionInRow = data.absolutePosition,
			contactId = 0,
			presence = 0,
			interactionUuid = 0
		}
		local v10 = if data.recommendation.contextType == recommendationContextType.Contacts then data.userId else nil
		v9.contactId = v10

		v9.presence = data.userPresenceType
		v9.interactionUuid = HttpService:GenerateGUID(false)
		fireAnalyticsEvent(userPressed, v9)
	end, {
		v8,
		data.fireAnalyticsEvent,
		data.userId,
		data.friendshipStatus,
		data.absolutePosition,
		data.userPresenceType,
		data.recommendation.hasIncomingFriendRequest,
		data.recommendation.contextType,
		data.recommendation.rank
	}))
end

return useOnActivatedTile
