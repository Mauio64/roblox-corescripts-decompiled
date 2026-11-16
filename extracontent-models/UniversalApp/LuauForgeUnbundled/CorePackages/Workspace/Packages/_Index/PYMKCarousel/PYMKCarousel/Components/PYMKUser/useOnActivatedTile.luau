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

	local v6 = react.useCallback(function()
		local openProfilePeekView = data.openProfilePeekView
		local userId = data.userId
		local v7 = {
			absolutePosition = data.absolutePosition,
			source = Constants.HomepagePYMKCarouselSourceName,
			isRecommendation = true,
			mutualFriendsCount = v5,
			recommendationSessionId = data.recommendationSessionId,
			recommendationRank = data.recommendation.rank,
			recommendationContextType = data.recommendation.contextType and data.recommendation.contextType.rawValue() or nil,
			contextualInfoType = getRecommendationContextualInfoType(data.recommendation),
			contactProps = 0,
			profileType = 0
		}
		local v8

		if data.recommendation.contextType == recommendationContextType.Contacts then
			v8 = { contactId = data.userId, avatarImageUrl = 0, contactName = 0 }
			local v9 = if data.recommendation.thumbnailEntities then data.recommendation.thumbnailEntities.avatarImageUrl else nil
			v8.avatarImageUrl = v9

			v8.contactName = data.recommendation.entityDisplayName
		end

		v7.contactProps = v8

		v7.profileType = data.recommendation.contextType == recommendationContextType.Contacts
			and "FromContacts"
			or nil
		openProfilePeekView(userId, v7)
	end, {
		data.openProfilePeekView,
		data.userId,
		data.absolutePosition,
		v5,
		data.recommendationSessionId,
		data.recommendation
	})

	return (react.useCallback(function()
		v6()
		local fireAnalyticsEvent = data.fireAnalyticsEvent
		local userPressed = eventNames.UserPressed
		local v7 = {
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
		local v8 = if data.recommendation.contextType == recommendationContextType.Contacts then data.userId else nil
		v7.contactId = v8

		v7.presence = data.userPresenceType
		v7.interactionUuid = HttpService:GenerateGUID(false)
		fireAnalyticsEvent(userPressed, v7)
	end, {
		v6,
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
