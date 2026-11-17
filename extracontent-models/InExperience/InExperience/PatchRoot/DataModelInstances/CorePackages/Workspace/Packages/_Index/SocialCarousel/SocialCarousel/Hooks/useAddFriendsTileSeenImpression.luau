local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent
local React = require(parent.React)
local Navigation = require(parent.Navigation)
local RoactAppExperiment = require(parent.RoactAppExperiment)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local FriendsRequests = require(parent.DataHydration.FriendsRequests)
local FriendsRequestsStore = FriendsRequests.FriendsRequestsStore
local UnseenRequestsStore = FriendsRequests.UnseenRequestsStore

local useNavigationFocus = Navigation.useNavigationFocus
local useSocialCarouselAnalytics = require(SocialCarousel.Analytics.useSocialCarouselAnalytics)
local getBadgeAnalyticsFields = require(SocialCarousel.Analytics.getBadgeAnalyticsFields)
local SharedFlags = require(parent.SharedFlags)
local FStringNewFriendRequestsBadgeLayer = SharedFlags.FStringNewFriendRequestsBadgeLayer

local SharedFlags2 = require(parent.SharedFlags)
local FFlagAddFriendsPageHighlightUnseenTrustedRequests = SharedFlags2.FFlagAddFriendsPageHighlightUnseenTrustedRequests

local FFlagSocialCarouselEnableNewFriendRequestsBadgeForAll = require(SocialCarousel.Flags.FFlagSocialCarouselEnableNewFriendRequestsBadgeForAll)

local function useAddFriendsTileSeenImpression(absolutePosition: number?)
	local addFriendsTileSeen = useSocialCarouselAnalytics().addFriendsTileSeen
	local v = useNavigationFocus()
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local v2 = FFlagSocialCarouselEnableNewFriendRequestsBadgeForAll and true
		or RoactAppExperiment.useUserExperiment({ FStringNewFriendRequestsBadgeLayer }, function(p): boolean
			return (p[FStringNewFriendRequestsBadgeLayer] or {}).showNewFriendRequestsBadge == true
		end)

	local v3 = React.useMemo(function()
		if FFlagAddFriendsPageHighlightUnseenTrustedRequests then
			return UnseenRequestsStore.get().getUnseenRequestCount()
		end

		return FriendsRequestsStore.get().getNewFriendsRequestCount()
	end, {})

	local v4 = useSignalState(v3.data)
	local v5 = useSignalState(v3.status) == "Ready"

	local current2 = v4 or 0

	React.useEffect(function()
		if not v5 or absolutePosition == nil then
			return
		end

		local badgeAnalyticsFields = getBadgeAnalyticsFields(current2, v2)
		local current = ref.current

		if
			current == current2 and ref2.current == badgeAnalyticsFields.badgeShown
			or not v
			or not addFriendsTileSeen
		then
			return
		end

		addFriendsTileSeen({
			newRequestCount = badgeAnalyticsFields.newRequestCount,
			previousCount = current,
			trigger = current == nil and "initial" or "valueChanged",
			badgeEnabled = badgeAnalyticsFields.badgeEnabled,
			badgeShown = badgeAnalyticsFields.badgeShown,
			badgeCapped = badgeAnalyticsFields.badgeCapped,
			absolutePosition = absolutePosition
		})

		ref.current = current2
		ref2.current = badgeAnalyticsFields.badgeShown
	end, { absolutePosition, v, current2, v2, v5, addFriendsTileSeen })
end

return useAddFriendsTileSeenImpression
