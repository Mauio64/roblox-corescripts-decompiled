local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent

local React = require(parent.React)
local RoactAppExperiment = require(parent.RoactAppExperiment)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local FriendsRequests = require(parent.DataHydration.FriendsRequests)
local FriendsRequestsStore = FriendsRequests.FriendsRequestsStore
local UnseenRequestsStore = FriendsRequests.UnseenRequestsStore
local SharedFlags = require(parent.SharedFlags)
local FStringNewFriendRequestsBadgeLayer = SharedFlags.FStringNewFriendRequestsBadgeLayer

local SharedFlags2 = require(parent.SharedFlags)
local FFlagAddFriendsPageHighlightUnseenTrustedRequests = SharedFlags2.FFlagAddFriendsPageHighlightUnseenTrustedRequests

local FFlagSocialCarouselEnableNewFriendRequestsBadgeForAll = require(SocialCarousel.Flags.FFlagSocialCarouselEnableNewFriendRequestsBadgeForAll)

return function()
	local v

	if FFlagSocialCarouselEnableNewFriendRequestsBadgeForAll then
		v = true
	else
		v = RoactAppExperiment.useUserExperiment({ FStringNewFriendRequestsBadgeLayer }, function(p)
			return (p[FStringNewFriendRequestsBadgeLayer] or {}).showNewFriendRequestsBadge
		end)
	end

	local v2 = useSignalState(React.useMemo(function()
		if FFlagAddFriendsPageHighlightUnseenTrustedRequests then
			return UnseenRequestsStore.get().getUnseenRequestCount()
		end

		return FriendsRequestsStore.get().getNewFriendsRequestCount()
	end, {}).data) or 0
	local v3 = v2 > 0
	local v4 = tostring(v2)
	return if v and v3 then v4 else nil
end
