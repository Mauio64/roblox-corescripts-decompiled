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
require(parent.Analytics.AnalyticsTypes)
local SharedFlags = require(parent2.SharedFlags)
local FFlagPymkCarouselExtendProps = SharedFlags.FFlagPymkCarouselExtendProps

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

	local useCallback = react.useCallback
	local function fn()
		local openProfilePeekView = data.openProfilePeekView
		local userId = data.userId
		local v = {
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
		local source

		if FFlagPymkCarouselExtendProps then
			if data.analyticsSurface then
				source = data.analyticsSurface.source
			else
				source = Constants.HomepagePYMKCarouselSourceName
			end
		else
			source = Constants.HomepagePYMKCarouselSourceName
		end

		v.source = source

		v.mutualFriendsCount = mutualFriendsCount
		v.recommendationSessionId = data.recommendationSessionId
		v.recommendationRank = data.recommendation.rank
		v.recommendationContextType = data.recommendation.contextType and data.recommendation.contextType.rawValue()
			or nil

		v.contextualInfoType = getRecommendationContextualInfoType(data.recommendation)
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
	end

	local openProfilePeekView = data.openProfilePeekView
	local userId = data.userId
	local absolutePosition = data.absolutePosition

	local recommendationSessionId = data.recommendationSessionId
	local recommendation = data.recommendation
	local v

	if FFlagPymkCarouselExtendProps then
		v = data.analyticsSurface
	end

	local v2 = useCallback(fn, {
		openProfilePeekView,
		userId,
		absolutePosition,
		mutualFriendsCount,
		recommendationSessionId,
		recommendation,
		v
	})

	return (react.useCallback(function()
		v2()
		local fireAnalyticsEvent = data.fireAnalyticsEvent
		local userPressed = EventNames.UserPressed
		local v3 = {
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

		v3.contactId = contactId

		v3.presence = data.userPresenceType
		v3.interactionUuid = HttpService:GenerateGUID(false)
		fireAnalyticsEvent(userPressed, v3)
	end, {
		v2,
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
