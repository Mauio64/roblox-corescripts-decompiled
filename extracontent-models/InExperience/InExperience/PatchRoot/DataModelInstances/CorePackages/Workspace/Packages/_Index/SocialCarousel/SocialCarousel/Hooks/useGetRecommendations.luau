local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local SocialCarouselParent = SocialCarousel.Parent
local SocialCommon = require(SocialCarouselParent.SocialCommon)
local React = require(SocialCarouselParent.React)
local Cryo = require(SocialCarouselParent.Cryo)
local RoactUtils = require(SocialCarouselParent.RoactUtils)
local getDeepValue = require(SocialCarousel.Utils.getDeepValue)
local Constants = require(SocialCarousel.Common.Constants)
local RecommendationSourceEnum = SocialCommon.Enums.RecommendationSourceEnum
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local FFlagFriendsCarouselDeprecateUnusedReducers = require(SocialCarouselParent.SharedFlags).FFlagFriendsCarouselDeprecateUnusedReducers

local function v12(t1: {[any]: any}, t2: {[any]: any}) -- line: 30
	return t1.rank < t2.rank
end

return function(s1: string) -- line: 34
	-- upvalues: useSelector (copy), getDeepValue (copy), Constants (copy), RecommendationSourceEnum (copy), FFlagFriendsCarouselDeprecateUnusedReducers (copy), React (copy), Cryo (copy), v12 (copy)
	local v16 = useSelector(function(p1) -- line: 35
		-- upvalues: getDeepValue (copy), Constants (copy), s1 (copy), RecommendationSourceEnum (copy), FFlagFriendsCarouselDeprecateUnusedReducers (copy)
		return {
			recommendationsDict = getDeepValue(p1, string.format("%s.Friends.recommendations.byUserId.%s", Constants.RODUX_KEY, s1 or "")) or {},
			friendshipStatus = getDeepValue(p1, string.format("%s.Friends.friendshipStatus", Constants.RODUX_KEY)) or {},
			friendsCarouselRecommendationIds = getDeepValue(p1, string.format("%s.Friends.recommendations.bySource.%s", Constants.RODUX_KEY, RecommendationSourceEnum.HomepageFriendsCarousel)) or {},
			hasIncomingFriendRequest = getDeepValue(p1, string.format("%s.Friends.recommendations.hasIncomingFriendRequest", Constants.RODUX_KEY)),
			users = if not FFlagFriendsCarouselDeprecateUnusedReducers then getDeepValue(p1, string.format("%s.Users.byUserId", Constants.RODUX_KEY)) else nil
		}
	end)
	local v17 = React.useMemo(function() -- line: 61
		-- upvalues: Cryo (copy), v16 (copy)
		return Cryo.List.filter(Cryo.Dictionary.keys(v16.recommendationsDict), function(p2) -- line: 62
			-- upvalues: v16 (copy)
			return v16.friendsCarouselRecommendationIds[p2]
		end)
	end, {
		v16.recommendationsDict,
		v16.friendsCarouselRecommendationIds
	})
	local v18 = React.useCallback(function(p3) -- line: 70
		-- upvalues: v16 (copy), Cryo (copy), FFlagFriendsCarouselDeprecateUnusedReducers (copy)
		local v21 = v16.recommendationsDict[p3]
		local v22 = v16.friendshipStatus[p3]

		return Cryo.Dictionary.join(if not FFlagFriendsCarouselDeprecateUnusedReducers then v16.users[p3] else {}, v21, {
			isFriendWithUser = not not v22 and v22 == Enum.FriendStatus.Friend,
			hasPendingFriendRequest = not not v22 and v22 == Enum.FriendStatus.FriendRequestSent,
			canSendFriendRequest = not v22 or v22 == Enum.FriendStatus.NotFriend,
			hasIncomingFriendRequest = v16.hasIncomingFriendRequest[p3]
		})
	end, {
		v16.recommendationsDict,
		v16.friendshipStatus,
		if not FFlagFriendsCarouselDeprecateUnusedReducers then v16.users else nil,
		v16.hasIncomingFriendRequest
	})

	return (React.useMemo(function() -- line: 97
		-- upvalues: Cryo (copy), v17 (copy), v18 (copy), v12 (copy)
		return Cryo.List.sort(Cryo.List.map(v17, v18), v12)
	end, {
		v17,
		v18
	}))
end
