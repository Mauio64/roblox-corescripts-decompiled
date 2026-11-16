local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local RoactAppExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RoactAppExperiment")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SignalsReact").useSignalState
local FriendsRequests = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/DataHydration/FriendsRequests")
local friendsRequestsStore = FriendsRequests.FriendsRequestsStore
local unseenRequestsStore = FriendsRequests.UnseenRequestsStore
local fStringNewFriendRequestsBadgeLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FStringNewFriendRequestsBadgeLayer

local fFlagAddFriendsPageHighlightUnseenTrustedRequests = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagAddFriendsPageHighlightUnseenTrustedRequests

local FFlagSocialCarouselEnableNewFriendRequestsBadgeForAll = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselEnableNewFriendRequestsBadgeForAll")

return function()
	local v5 = FFlagSocialCarouselEnableNewFriendRequestsBadgeForAll and true
		or RoactAppExperiment.useUserExperiment({ fStringNewFriendRequestsBadgeLayer }, function(p2)
			return (p2[fStringNewFriendRequestsBadgeLayer] or {}).showNewFriendRequestsBadge
		end)

	local v7 = useSignalState(React.useMemo(function()
		if fFlagAddFriendsPageHighlightUnseenTrustedRequests then
			return unseenRequestsStore.get().getUnseenRequestCount()
		end

		return friendsRequestsStore.get().getNewFriendsRequestCount()
	end, {}).data) or 0
	local v8 = v7 > 0
	local v9 = tostring(v7)

	if v5 and v8 then
		return v9
	end

	return nil
end
