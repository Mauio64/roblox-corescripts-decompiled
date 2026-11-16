local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Navigation")
local RoactAppExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RoactAppExperiment")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SignalsReact").useSignalState
local FriendsRequests = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/DataHydration/FriendsRequests")
local friendsRequestsStore = FriendsRequests.FriendsRequestsStore
local unseenRequestsStore = FriendsRequests.UnseenRequestsStore

local useNavigationFocus = Navigation.useNavigationFocus
local useSocialCarouselAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Analytics/useSocialCarouselAnalytics")
local getBadgeAnalyticsFields = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Analytics/getBadgeAnalyticsFields")
local fStringNewFriendRequestsBadgeLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FStringNewFriendRequestsBadgeLayer

local fFlagAddFriendsPageHighlightUnseenTrustedRequests = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagAddFriendsPageHighlightUnseenTrustedRequests

local FFlagSocialCarouselEnableNewFriendRequestsBadgeForAll = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselEnableNewFriendRequestsBadgeForAll")

local function useAddFriendsTileSeenImpression(p2)
	local addFriendsTileSeen = useSocialCarouselAnalytics().addFriendsTileSeen
	local v5 = useNavigationFocus()
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local v6 = FFlagSocialCarouselEnableNewFriendRequestsBadgeForAll and true
		or RoactAppExperiment.useUserExperiment({ fStringNewFriendRequestsBadgeLayer }, function(p3): boolean
			return (p3[fStringNewFriendRequestsBadgeLayer] or {}).showNewFriendRequestsBadge == true
		end)

	local v7 = React.useMemo(function()
		if fFlagAddFriendsPageHighlightUnseenTrustedRequests then
			return unseenRequestsStore.get().getUnseenRequestCount()
		end

		return friendsRequestsStore.get().getNewFriendsRequestCount()
	end, {})

	local v8 = useSignalState(v7.data)
	local v9 = useSignalState(v7.status) == "Ready"

	local v10 = v8 or 0

	React.useEffect(function()
		if not v9 or p2 == nil then
			return
		end

		local v11 = getBadgeAnalyticsFields(v10, v6)
		local current = ref.current

		if current == v10 and ref2.current == v11.badgeShown or not v5 or not addFriendsTileSeen then
			return
		end

		addFriendsTileSeen({
			newRequestCount = v11.newRequestCount,
			previousCount = current,
			trigger = current == nil and "initial" or "valueChanged",
			badgeEnabled = v11.badgeEnabled,
			badgeShown = v11.badgeShown,
			badgeCapped = v11.badgeCapped,
			absolutePosition = p2
		})

		ref.current = v10
		ref2.current = v11.badgeShown
	end, { p2, v5, v10, v6, v9, addFriendsTileSeen })
end

return useAddFriendsTileSeenImpression
