local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local SocialCarouselParent = SocialCarousel.Parent
local RoactAppExperiment = require(SocialCarouselParent.RoactAppExperiment)
local getDeepValue = require(SocialCarousel.Utils.getDeepValue)
local useSelector = require(SocialCarouselParent.RoactUtils).Hooks.RoactRodux.useSelector
local FStringNewFriendRequestsBadgeLayer = require(SocialCarouselParent.SharedFlags).FStringNewFriendRequestsBadgeLayer
local FFlagSocialCarouselEnableNewFriendRequestsBadgeForAll = require(SocialCarousel.Flags.FFlagSocialCarouselEnableNewFriendRequestsBadgeForAll)

return function() -- line: 11
	-- upvalues: FFlagSocialCarouselEnableNewFriendRequestsBadgeForAll (copy), RoactAppExperiment (copy), FStringNewFriendRequestsBadgeLayer (copy), useSelector (copy), getDeepValue (copy)
	local v8 = not not FFlagSocialCarouselEnableNewFriendRequestsBadgeForAll or RoactAppExperiment.useUserExperiment({ FStringNewFriendRequestsBadgeLayer }, function(p1) -- line: 19
		-- upvalues: FStringNewFriendRequestsBadgeLayer (copy)
		return (p1[FStringNewFriendRequestsBadgeLayer] or {}).showNewFriendRequestsBadge
	end)
	local v9 = useSelector(function(p2) -- line: 25
		-- upvalues: getDeepValue (copy)
		return getDeepValue(p2, "FriendsCarousel.Friends.requests.newFriendRequestsCount") or 0
	end)
	local v10 = v9 > 0
	local str = tostring(v9)

	if v8 and v10 then
		return str
	end

	return nil
end
