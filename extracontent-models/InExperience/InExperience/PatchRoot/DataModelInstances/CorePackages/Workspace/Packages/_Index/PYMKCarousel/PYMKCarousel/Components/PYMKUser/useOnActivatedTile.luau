local HttpService = game:GetService("HttpService")
local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
local parent2 = parent.Parent

local react = dependencies.React
local Constants = require(parent.Common.Constants)
local SocialCommon = require(parent2.SocialCommon)
require(parent2.UserList)
local recommendationContextType = dependencies.RoduxFriends.Enums.RecommendationContextType
local getRecommendationContextualInfoType = SocialCommon.Utils.getRecommendationContextualInfoType
local Analytics = require(parent.Analytics)
local getFriendStatus = require(parent.Analytics.getFriendStatus)
local EventNames = Analytics.EventNames

local function useOnActivatedTile(data)
	local mutualFriendsCount = react.useMemo(function()
		if data.recommendation.mutualFriendsCount then
			return data.recommendation.mutualFriendsCount
		end

		if data.recommendation.mutualFriendsList then
			return #data.recommendation.mutualFriendsList
		end

		return nil
	end, { data.recommendation.mutualFriendsCount, data.recommendation.mutualFriendsList })

	local v = react.useCallback(function()
		local openProfilePeekView = data.openProfilePeekView
		local userId = data.userId
		local v = {
			absolutePosition = data.absolutePosition,
			source = Constants.HomepagePYMKCarouselSourceName,
			isRecommendation = true,
			mutualFriendsCount = mutualFriendsCount,
			recommendationSessionId = data.recommendationSessionId,
			recommendationRank = data.recommendation.rank,
			recommendationContextType = data.recommendation.contextType and data.recommendation.contextType.rawValue() or nil,
			contextualInfoType = getRecommendationContextualInfoType(data.recommendation),
			contactProps = 0,
			profileType = 0
		}
		local contactProps

		if data.recommendation.contextType == recommendationContextType.Contacts then
			contactProps = { contactId = data.userId, avatarImageUrl = 0, contactName = 0 }
			local avatarImageUrl

			if data.recommendation.thumbnailEntities then
				avatarImageUrl = data.recommendation.thumbnailEntities.avatarImageUrl
			end

			contactProps.avatarImageUrl = avatarImageUrl

			contactProps.contactName = data.recommendation.entityDisplayName
		end

		v.contactProps = contactProps

		v.profileType = data.recommendation.contextType == recommendationContextType.Contacts and "FromContacts" or nil
		openProfilePeekView(userId, v)
	end, {
		data.openProfilePeekView,
		data.userId,
		data.absolutePosition,
		mutualFriendsCount,
		data.recommendationSessionId,
		data.recommendation
	})

	return (react.useCallback(function()
		v()
		local fireAnalyticsEvent = data.fireAnalyticsEvent
		local userPressed = EventNames.UserPressed
		local v2 = {
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
		local contactId

		if data.recommendation.contextType == recommendationContextType.Contacts then
			contactId = data.userId
		end

		v2.contactId = contactId

		v2.presence = data.userPresenceType
		v2.interactionUuid = HttpService:GenerateGUID(false)
		fireAnalyticsEvent(userPressed, v2)
	end, {
		v,
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
