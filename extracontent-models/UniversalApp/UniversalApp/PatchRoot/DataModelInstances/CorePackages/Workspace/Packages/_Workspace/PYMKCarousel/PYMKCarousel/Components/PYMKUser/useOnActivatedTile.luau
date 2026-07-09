local HttpService = game:GetService("HttpService")
local ParentParent = script.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local ParentParentParent = ParentParent.Parent
local React = dependencies.React
local Constants = require(ParentParent.Common.Constants)
local SocialCommon = require(ParentParentParent.SocialCommon)

require(ParentParentParent.UserList)

local RecommendationContextType = dependencies.RoduxFriends.Enums.RecommendationContextType
local getRecommendationContextualInfoType = SocialCommon.Utils.getRecommendationContextualInfoType
local Analytics = require(ParentParent.Analytics)
local getFriendStatus = require(ParentParent.Analytics.getFriendStatus)
local EventNames = Analytics.EventNames
local FFlagHomepagePYMKPresenceAnalytics = require(ParentParentParent.SharedFlags).FFlagHomepagePYMKPresenceAnalytics

local function useOnActivatedTile(t1: {[any]: any}) -- line: 44
	-- upvalues: React (copy), Constants (copy), getRecommendationContextualInfoType (copy), RecommendationContextType (copy), EventNames (copy), getFriendStatus (copy), FFlagHomepagePYMKPresenceAnalytics (copy), HttpService (copy)
	local v16 = React.useMemo(function() -- line: 45
		-- upvalues: t1 (copy)
		if t1.recommendation.mutualFriendsCount then
			return t1.recommendation.mutualFriendsCount
		end

		if t1.recommendation.mutualFriendsList then
			return #t1.recommendation.mutualFriendsList
		end

		return nil
	end, {
		t1.recommendation.mutualFriendsCount,
		t1.recommendation.mutualFriendsList
	})
	local v17 = React.useCallback(function() -- line: 58
		-- upvalues: t1 (copy), Constants (copy), v16 (copy), getRecommendationContextualInfoType (copy), RecommendationContextType (copy)
		t1.openProfilePeekView(t1.userId, {
			isRecommendation = true,
			absolutePosition = t1.absolutePosition,
			source = Constants.HomepagePYMKCarouselSourceName,
			mutualFriendsCount = v16,
			recommendationSessionId = t1.recommendationSessionId,
			recommendationRank = t1.recommendation.rank,
			recommendationContextType = t1.recommendation.contextType and t1.recommendation.contextType.rawValue() or nil,
			contextualInfoType = getRecommendationContextualInfoType(t1.recommendation),
			contactProps = if t1.recommendation.contextType ~= RecommendationContextType.Contacts then nil else {
				contactId = t1.userId,
				avatarImageUrl = if not t1.recommendation.thumbnailEntities then nil else t1.recommendation.thumbnailEntities.avatarImageUrl,
				contactName = t1.recommendation.entityDisplayName
			},
			profileType = if t1.recommendation.contextType ~= RecommendationContextType.Contacts then nil else "FromContacts"
		})
	end, {
		t1.openProfilePeekView,
		t1.userId,
		t1.absolutePosition,
		v16,
		t1.recommendationSessionId,
		t1.recommendation
	})

	return (React.useCallback(function() -- line: 98
		-- upvalues: v17 (copy), t1 (copy), EventNames (copy), getFriendStatus (copy), RecommendationContextType (copy), FFlagHomepagePYMKPresenceAnalytics (copy), HttpService (copy)
		v17()
		t1.fireAnalyticsEvent(EventNames.UserPressed, {
			recommendationId = t1.userId,
			friendStatus = getFriendStatus(t1.friendshipStatus, t1.recommendation.hasIncomingFriendRequest),
			recommendationContextType = t1.recommendation.contextType,
			recommendationRank = t1.recommendation.rank,
			absolutePosition = t1.absolutePosition,
			positionInRow = t1.absolutePosition,
			contactId = if t1.recommendation.contextType ~= RecommendationContextType.Contacts then nil else t1.userId,
			presence = if not FFlagHomepagePYMKPresenceAnalytics then nil else t1.userPresenceType,
			interactionUuid = HttpService:GenerateGUID(false)
		})
	end, {
		v17,
		t1.fireAnalyticsEvent,
		t1.userId,
		t1.friendshipStatus,
		t1.absolutePosition,
		t1.userPresenceType,
		t1.recommendation.hasIncomingFriendRequest,
		t1.recommendation.contextType,
		t1.recommendation.rank
	}))
end

return useOnActivatedTile
