local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Constants = require(script.Parent.Parent.Constants)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local useHomeSortDropDownOptions = require(parent.Home.useHomeSortDropDownOptions)
local SharedFlags = require(parent.SharedFlags)
local GetFFlagPlatformEventEnabled = SharedFlags.GetFFlagPlatformEventEnabled
local GetFStringPlatformEventUrl = SharedFlags.GetFStringPlatformEventUrl
local FFlagEnableBlackbird = SharedFlags.FFlagEnableBlackbird
local FFlagEnableBlackbirdOnFlyoutMenu = SharedFlags.FFlagEnableBlackbirdOnFlyoutMenu
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local FFlagEnableRMOnMorePageGUAC = SharedFlags.FFlagEnableRMOnMorePageGUAC
local FFlagEnableRMOnMorePageForAll = SharedFlags.FFlagEnableRMOnMorePageForAll
local FFlagLuaAppFixNotificationBadgeCountsSync = SharedFlags.FFlagLuaAppFixNotificationBadgeCountsSync
local FFlagFlyoutRemoveMomentsForArgoEnabled = SharedFlags.FFlagFlyoutRemoveMomentsForArgoEnabled
local FFlagEnableArgus = SharedFlags.FFlagEnableArgus
local FFlagArgoEnableMoments = SharedFlags.FFlagArgoEnableMoments
local FFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage
local FFlagFlyoutFilterWebViewsAndBrowserLinks = SharedFlags.FFlagFlyoutFilterWebViewsAndBrowserLinks
local FFlagFlyoutAddAdjustScreen = require(script.Parent.Parent.Flags.FFlagFlyoutAddAdjustScreen)
local FFlagFlyoutSidePanelTradesEntry = require(script.Parent.Parent.Flags.FFlagFlyoutSidePanelTradesEntry)
local FFlagFlyoutHideSortDeeplinkItems = require(script.Parent.Parent.Flags.FFlagFlyoutHideSortDeeplinkItems)
local FFlagFlyoutGateLearnPlace = SharedFlags.FFlagFlyoutGateLearnPlace
local FFlagEnableTradesEntryForNonPremium = SharedFlags.FFlagEnableTradesEntryForNonPremium
local MomentsCommon = require(parent.MomentsCommon)
local useMomentsGating = MomentsCommon.Hooks.useMomentsGating
local canRenderNativeMoments = MomentsCommon.canRenderNativeMoments

local FlyoutContentSettings = require(script.Parent.Parent.Config.FlyoutContentSettings)

local function updateNotifications(clone, data, p, p2)
	local notificationCount = 0

	if clone.itemType == FlyoutContentSettings.ItemType.Settings then
		notificationCount = data.MorePageSettings
	elseif clone.itemType == FlyoutContentSettings.ItemType.Connections then
		if FFlagLuaAppFixNotificationBadgeCountsSync then
			notificationCount = p
		else
			notificationCount = data.MorePageFriends
		end
	elseif clone.itemType == FlyoutContentSettings.ItemType.Messages then
		if FFlagLuaAppFixNotificationBadgeCountsSync then
			notificationCount = p2
		else
			notificationCount = data.MorePageMessages
		end
	end

	if notificationCount > 0 and (not clone.notificationCount or clone.notificationCount ~= notificationCount) then
		clone.notificationCount = notificationCount
	end
end

local function shouldSkipLibraryItem(p: string, p2, data): boolean
	if
		p2 == nil
		or FFlagFlyoutAddAdjustScreen and p == FlyoutContentSettings.ItemType.AdjustScreen and not data.supportsOverscan
		or FFlagFlyoutHideSortDeeplinkItems and FlyoutContentSettings.itemIsGameSortDeeplink(p2)
	then
		return true
	end

	if
		FFlagFlyoutFilterWebViewsAndBrowserLinks
		and not data.webViewSupported
		and FlyoutContentSettings.itemRequiresWebView(p2, data.externalBrowserAllowed)
		or p == FlyoutContentSettings.ItemType.Favorites and not data.hasFavoritesData
		or p == FlyoutContentSettings.ItemType.ContinuePlaying and not data.hasContinueData
	then
		return true
	end

	if
		p == FlyoutContentSettings.ItemType.Premium and data.disablePremiumEntrypoint
		or p == FlyoutContentSettings.ItemType.GiftCards and data.hideGiftCards
		or p == FlyoutContentSettings.ItemType.Redeem and not data.redeemTileEnabled
	then
		return true
	end

	if
		p == FlyoutContentSettings.ItemType.Trades
		and not (data.hasPaidTradingAccess or FFlagEnableTradesEntryForNonPremium)
	then
		return true
	end

	if FFlagEnableBlackbird and FFlagEnableBlackbirdOnFlyoutMenu then
		if
			p == FlyoutContentSettings.ItemType.Premium
			or p == FlyoutContentSettings.ItemType.Blackbird and data.disableBlackbirdEntrypoints
		then
			return true
		end
	end

	return false
end

local function useFlyoutNavigationItems()
	local FLYOUT_DEFAULT_POLICY = Constants.FLYOUT_DEFAULT_POLICY

	local v = useSelector(function(p)
		return p.NotificationBadgeCounts
	end)

	local v2 = useSelector(function(p)
		if not FFlagLuaAppFixNotificationBadgeCountsSync then
			return 0
		end

		local friendsCarousel = p.FriendsCarousel
		local requests = friendsCarousel and friendsCarousel.Friends and friendsCarousel.Friends.requests
		return requests and requests.receivedCount or 0
	end)

	local v3 = useSelector(function(p)
		if FFlagLuaAppFixNotificationBadgeCountsSync then
			return p.SocialTab and p.SocialTab.UnreadConversationCount or 0
		end

		return 0
	end)
	local hasContinueData, hasFavoritesData

	if FFlagLuaAppEnableSduiHomePage then
		local v4 = useHomeSortDropDownOptions()
		hasContinueData, hasFavoritesData = React.useMemo(function()
			local v5 = nil
			local v6 = nil

			for _, v7 in v4 do
				if v7.topicId == Constants.SORT_ID_CONTINUE_PLAYING then
					v5 = true
				elseif v7.topicId == Constants.SORT_ID_FAVORITES then
					v6 = true
				end
			end

			return v5, v6
		end, { v4 })
	else
		local v4 = useSelector(function(p)
			return p.OmniRecommendations and p.OmniRecommendations.Home
		end)

		local sorts = v4 and v4.sorts or {}
		hasContinueData, hasFavoritesData = React.useMemo(function()
			local v5 = nil
			local v6 = nil

			for _, sort in pairs(sorts) do
				if sort.topicId == Constants.SORT_ID_CONTINUE_PLAYING then
					v5 = true
				elseif sort.topicId == Constants.SORT_ID_FAVORITES then
					v6 = true
				end
			end

			return v5, v6
		end, { sorts })
	end

	local disablePremiumEntrypoint = useAppPolicy(function(p)
		return p.getDisablePremiumEntrypoint() or false
	end)

	local disableBlackbirdEntrypoints = useAppPolicy(function(p)
		return p.getDisableBlackbirdEntrypoints() or false
	end)

	local v4 = useAppPolicy(function(p)
		return p.getGiftCardSourceRefOverride()
	end)

	local redeemTileEnabled = useAppPolicy(function(p)
		return p.getRedeemTileEnabled()
	end)

	local v5 = not FFlagFlyoutGateLearnPlace or useAppPolicy(function(p)
		return p.getLearnPlaceEnabled()
	end)
	local supportsOverscan

	if FFlagFlyoutAddAdjustScreen then
		supportsOverscan = useAppPolicy(function(p)
			return p.getSupportsOverscan()
		end)
	else
		supportsOverscan = false
	end

	local webViewSupported = not FFlagFlyoutFilterWebViewsAndBrowserLinks or useAppPolicy(function(p)
		return p.getWebViewSupport()
	end)
	local externalBrowserAllowed

	if FFlagFlyoutFilterWebViewsAndBrowserLinks then
		externalBrowserAllowed = useAppPolicy(function(p)
			return p.shouldUseExternalBrowserForMorePageItem()
		end)
	else
		externalBrowserAllowed = false
	end

	local hasPaidTradingAccess

	if FFlagFlyoutSidePanelTradesEntry then
		hasPaidTradingAccess = useSelector(function(p)
			local user = p.Users[p.LocalUserId]

			if not user then
				return false
			end

			local v6 = user.membership == Enum.MembershipType.Premium
			local v7 = FFlagEnableBlackbirdCheck and user.hasRobloxSubscription == true
			return v6 or v7
		end)
	else
		hasPaidTradingAccess = false
	end

	local v6 = useMomentsGating()
	local isAmpPolicyEnabled = v6.isAmpPolicyEnabled
	local v7 = not FFlagEnableRMOnMorePageGUAC or isAmpPolicyEnabled
	local hideGiftCards = not v4 or v4 == ""
	local useMemo = React.useMemo
	local function fn()
		local v8 = {
			hasFavoritesData = hasFavoritesData,
			hasContinueData = hasContinueData,
			disablePremiumEntrypoint = disablePremiumEntrypoint,
			hideGiftCards = hideGiftCards,
			redeemTileEnabled = redeemTileEnabled,
			hasPaidTradingAccess = hasPaidTradingAccess,
			disableBlackbirdEntrypoints = disableBlackbirdEntrypoints,
			webViewSupported = webViewSupported,
			externalBrowserAllowed = externalBrowserAllowed,
			supportsOverscan = supportsOverscan
		}
		local clones = {}
		local clones2 = {}

		for _, v9 in FLYOUT_DEFAULT_POLICY.MyLibrary do
			local v10 = FlyoutContentSettings.ItemInfo[v9]

			if shouldSkipLibraryItem(v9, v10, v8) then
				continue
			end

			local clone = table.clone(v10)
			updateNotifications(clone, v, v2, v3)

			table.insert(clones, clone)
		end

		for _, v9 in FLYOUT_DEFAULT_POLICY.AdditionalNavigation do
			local v10 = FlyoutContentSettings.ItemInfo[v9]

			if v10 == nil then
				continue
			end

			if v9 == FlyoutContentSettings.ItemType.Events then
				if not GetFFlagPlatformEventEnabled() or GetFStringPlatformEventUrl() == "" then
					continue
				end
			elseif v9 == FlyoutContentSettings.ItemType.Learn and FFlagFlyoutGateLearnPlace then
				if not v5 then
					continue
				end
			elseif
				v9 == FlyoutContentSettings.ItemType.Moments
				and (FFlagFlyoutRemoveMomentsForArgoEnabled and FFlagEnableArgus and FFlagArgoEnableMoments or FFlagFlyoutRemoveMomentsForArgoEnabled and v6 ~= nil and not v6.isSupportedOnPlatform or (v6 == nil or not v6.isFlyoutEntryEnabled) and not (FFlagEnableRMOnMorePageForAll or v7))
			then
				continue
			end

			if not (not FFlagFlyoutFilterWebViewsAndBrowserLinks or webViewSupported or not FlyoutContentSettings.itemRequiresWebView(
				v10,
				externalBrowserAllowed
			)) then
				continue
			end

			local clone = table.clone(v10)

			if v9 == FlyoutContentSettings.ItemType.Moments and v6 ~= nil then
				local context

				if canRenderNativeMoments(v6) then
					context = {
						appPage = AppPage.Moments,
						destinationType = FlyoutContentSettings.DestinationType.AppPage
					}
				else
					context = {
						appUri = FlyoutContentSettings.MomentsExperienceUri,
						destinationType = FlyoutContentSettings.DestinationType.PlaceLaunch
					}
				end

				clone.context = context
			end

			table.insert(clones2, clone)
		end

		return { myLibraryItems = clones, additionalNavigationItems = clones2 }
	end

	local v8

	if FFlagFlyoutFilterWebViewsAndBrowserLinks then
		v8 = webViewSupported
	end

	local v9

	if FFlagFlyoutFilterWebViewsAndBrowserLinks then
		v9 = externalBrowserAllowed
	end

	local v10

	if FFlagFlyoutSidePanelTradesEntry then
		v10 = hasPaidTradingAccess
	end

	local v11

	if FFlagFlyoutGateLearnPlace then
		v11 = v5
	end

	local v12

	if FFlagFlyoutAddAdjustScreen then
		v12 = supportsOverscan
	end

	local v13

	if FFlagLuaAppFixNotificationBadgeCountsSync then
		v13 = v2
	end

	local v14

	if FFlagLuaAppFixNotificationBadgeCountsSync then
		v14 = v3
	end

	return useMemo(fn, {
		hasFavoritesData,
		hasContinueData,
		FLYOUT_DEFAULT_POLICY,
		v,
		disablePremiumEntrypoint,
		disableBlackbirdEntrypoints,
		hideGiftCards,
		v8,
		v9,
		v10,
		v7,
		v11,
		v12,
		v6,
		v13,
		v14
	})
end

return useFlyoutNavigationItems
