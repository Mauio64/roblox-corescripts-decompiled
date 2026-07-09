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

local function v11(t1: {[any]: any}, t2: {[any]: any}) -- line: 28
	return t1.rank < t2.rank
end

return function(s1: string) -- line: 32
	-- upvalues: useSelector (copy), getDeepValue (copy), Constants (copy), RecommendationSourceEnum (copy), React (copy), Cryo (copy), v11 (copy)
	local v15 = useSelector(function(p1) -- line: 33
		-- upvalues: getDeepValue (copy), Constants (copy), s1 (copy), RecommendationSourceEnum (copy)
		return {
			recommendationsDict = getDeepValue(p1, string.format("%s.Friends.recommendations.byUserId.%s", Constants.RODUX_KEY, s1 or "")) or {},
			friendshipStatus = getDeepValue(p1, string.format("%s.Friends.friendshipStatus", Constants.RODUX_KEY)) or {},
			friendsCarouselRecommendationIds = getDeepValue(p1, string.format("%s.Friends.recommendations.bySource.%s", Constants.RODUX_KEY, RecommendationSourceEnum.HomepageFriendsCarousel)) or {},
			hasIncomingFriendRequest = getDeepValue(p1, string.format("%s.Friends.recommendations.hasIncomingFriendRequest", Constants.RODUX_KEY)),
			users = getDeepValue(p1, string.format("%s.Users.byUserId", Constants.RODUX_KEY))
		}
	end)
	local v16 = React.useMemo(function() -- line: 57
		-- upvalues: Cryo (copy), v15 (copy)
		return Cryo.List.filter(Cryo.Dictionary.keys(v15.recommendationsDict), function(p2) -- line: 58
			-- upvalues: v15 (copy)
			return v15.friendsCarouselRecommendationIds[p2]
		end)
	end, {
		v15.recommendationsDict,
		v15.friendsCarouselRecommendationIds
	})
	local v17 = React.useCallback(function(p3) -- line: 66
		-- upvalues: v15 (copy), Cryo (copy)
		local v20 = v15.recommendationsDict[p3]
		local v21 = v15.friendshipStatus[p3]

		return Cryo.Dictionary.join(v15.users[p3], v20, {
			isFriendWithUser = not not v21 and v21 == Enum.FriendStatus.Friend,
			hasPendingFriendRequest = not not v21 and v21 == Enum.FriendStatus.FriendRequestSent,
			canSendFriendRequest = not v21 or v21 == Enum.FriendStatus.NotFriend,
			hasIncomingFriendRequest = v15.hasIncomingFriendRequest[p3]
		})
	end, {
		v15.recommendationsDict,
		v15.friendshipStatus,
		v15.users,
		v15.hasIncomingFriendRequest
	})

	return (React.useMemo(function() -- line: 87
		-- upvalues: Cryo (copy), v16 (copy), v17 (copy), v11 (copy)
		return Cryo.List.sort(Cryo.List.map(v16, v17), v11)
	end, {
		v16,
		v17
	}))
end
