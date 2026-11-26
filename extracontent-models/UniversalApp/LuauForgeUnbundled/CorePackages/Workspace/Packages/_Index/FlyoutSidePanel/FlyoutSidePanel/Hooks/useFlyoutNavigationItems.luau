local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RoactUtils").Hooks.RoactRodux.useSelector
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Constants")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RobloxAppEnums").AppPage
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/UniversalAppPolicy").useAppPolicy
local useHomeSortDropDownOptions = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/Home/useHomeSortDropDownOptions")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags")
local getFFlagPlatformEventEnabled = SharedFlags.GetFFlagPlatformEventEnabled
local getFStringPlatformEventUrl = SharedFlags.GetFStringPlatformEventUrl
local fFlagEnableBlackbird = SharedFlags.FFlagEnableBlackbird
local fFlagEnableBlackbirdOnFlyoutMenu = SharedFlags.FFlagEnableBlackbirdOnFlyoutMenu
local fFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local fFlagEnableRMOnMorePageGUAC = SharedFlags.FFlagEnableRMOnMorePageGUAC
local fFlagEnableRMOnMorePageForAll = SharedFlags.FFlagEnableRMOnMorePageForAll
local fFlagLuaAppFixNotificationBadgeCountsSync = SharedFlags.FFlagLuaAppFixNotificationBadgeCountsSync
local fFlagFlyoutRemoveMomentsForArgoEnabled = SharedFlags.FFlagFlyoutRemoveMomentsForArgoEnabled
local fFlagEnableArgus = SharedFlags.FFlagEnableArgus
local fFlagArgoEnableMoments = SharedFlags.FFlagArgoEnableMoments
local fFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage
local fFlagFlyoutFilterWebViewsAndBrowserLinks = SharedFlags.FFlagFlyoutFilterWebViewsAndBrowserLinks
local FFlagFlyoutAddAdjustScreen = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Flags/FFlagFlyoutAddAdjustScreen")
local FFlagFlyoutSidePanelTradesEntry = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Flags/FFlagFlyoutSidePanelTradesEntry")
local FFlagFlyoutHideSortDeeplinkItems = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Flags/FFlagFlyoutHideSortDeeplinkItems")
local fFlagFlyoutGateLearnPlace = SharedFlags.FFlagFlyoutGateLearnPlace
local fFlagEnableTradesEntryForNonPremium = SharedFlags.FFlagEnableTradesEntryForNonPremium
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/MomentsCommon")
local useMomentsGating = MomentsCommon.Hooks.useMomentsGating
local canRenderNativeMoments = MomentsCommon.canRenderNativeMoments

local FlyoutContentSettings = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Config/FlyoutContentSettings")

local function updateNotifications(clone, data, p2, p3)
	local v5 = 0

	if clone.itemType == FlyoutContentSettings.ItemType.Settings then
		v5 = data.MorePageSettings
	elseif clone.itemType == FlyoutContentSettings.ItemType.Connections then
		v5 = if fFlagLuaAppFixNotificationBadgeCountsSync then p2 else data.MorePageFriends
	elseif clone.itemType == FlyoutContentSettings.ItemType.Messages then
		v5 = if fFlagLuaAppFixNotificationBadgeCountsSync then p3 else data.MorePageMessages
	end

	if v5 > 0 and (not clone.notificationCount or clone.notificationCount ~= v5) then
		clone.notificationCount = v5
	end
end

local function shouldSkipLibraryItem(p2, p3, data): boolean
	if
		p3 == nil
		or FFlagFlyoutAddAdjustScreen and p2 == FlyoutContentSettings.ItemType.AdjustScreen and not data.supportsOverscan
		or FFlagFlyoutHideSortDeeplinkItems and FlyoutContentSettings.itemIsGameSortDeeplink(p3)
	then
		return true
	end

	if
		fFlagFlyoutFilterWebViewsAndBrowserLinks
		and not data.webViewSupported
		and FlyoutContentSettings.itemRequiresWebView(p3, data.externalBrowserAllowed)
		or p2 == FlyoutContentSettings.ItemType.Favorites and not data.hasFavoritesData
		or p2 == FlyoutContentSettings.ItemType.ContinuePlaying and not data.hasContinueData
	then
		return true
	end

	if
		p2 == FlyoutContentSettings.ItemType.Premium and data.disablePremiumEntrypoint
		or p2 == FlyoutContentSettings.ItemType.GiftCards and data.hideGiftCards
		or p2 == FlyoutContentSettings.ItemType.Redeem and not data.redeemTileEnabled
	then
		return true
	end

	if
		p2 == FlyoutContentSettings.ItemType.Trades
		and not (data.hasPaidTradingAccess or fFlagEnableTradesEntryForNonPremium)
	then
		return true
	end

	if fFlagEnableBlackbird and fFlagEnableBlackbirdOnFlyoutMenu then
		if
			p2 == FlyoutContentSettings.ItemType.Premium
			or p2 == FlyoutContentSettings.ItemType.Blackbird and data.disableBlackbirdEntrypoints
		then
			return true
		end
	end

	return false
end

local function useFlyoutNavigationItems()
	local FLYOUT_DEFAULT_POLICY = Constants.FLYOUT_DEFAULT_POLICY

	local v5 = useSelector(function(p2)
		return p2.NotificationBadgeCounts
	end)

	local v6 = useSelector(function(p2)
		if not fFlagLuaAppFixNotificationBadgeCountsSync then
			return 0
		end

		local friendsCarousel = p2.FriendsCarousel
		local requests = friendsCarousel and friendsCarousel.Friends and friendsCarousel.Friends.requests
		return requests and requests.receivedCount or 0
	end)

	local v7 = useSelector(function(p2)
		if fFlagLuaAppFixNotificationBadgeCountsSync then
			return p2.SocialTab and p2.SocialTab.UnreadConversationCount or 0
		end

		return 0
	end)
	local v8, v9

	if fFlagLuaAppEnableSduiHomePage then
		local v10 = useHomeSortDropDownOptions()
		v8, v9 = React.useMemo(function()
			local v11 = nil
			local v12 = nil

			for k, v13 in v10 do
				if v13.topicId == Constants.SORT_ID_CONTINUE_PLAYING then
					v11 = true
				elseif v13.topicId == Constants.SORT_ID_FAVORITES then
					v12 = true
				end
			end

			return v11, v12
		end, { v10 })
	else
		local v10 = useSelector(function(p2)
			return p2.OmniRecommendations and p2.OmniRecommendations.Home
		end)

		local sorts = v10 and v10.sorts or {}
		v8, v9 = React.useMemo(function()
			local v11 = nil
			local v12 = nil

			for k, sort in pairs(sorts) do
				if sort.topicId == Constants.SORT_ID_CONTINUE_PLAYING then
					v11 = true
				elseif sort.topicId == Constants.SORT_ID_FAVORITES then
					v12 = true
				end
			end

			return v11, v12
		end, { sorts })
	end

	local v10 = useAppPolicy(function(p2)
		return p2.getDisablePremiumEntrypoint() or false
	end)

	local v11 = useAppPolicy(function(p2)
		return p2.getDisableBlackbirdEntrypoints() or false
	end)

	local v12 = useAppPolicy(function(p2)
		return p2.getGiftCardSourceRefOverride()
	end)

	local v13 = useAppPolicy(function(p2)
		return p2.getRedeemTileEnabled()
	end)

	local v14 = not fFlagFlyoutGateLearnPlace or useAppPolicy(function(p2)
		return p2.getLearnPlaceEnabled()
	end)
	local v15

	if FFlagFlyoutAddAdjustScreen then
		v15 = useAppPolicy(function(p2)
			return p2.getSupportsOverscan()
		end)
	else
		v15 = false
	end

	local v16 = not fFlagFlyoutFilterWebViewsAndBrowserLinks or useAppPolicy(function(p2)
		return p2.getWebViewSupport()
	end)
	local v17

	if fFlagFlyoutFilterWebViewsAndBrowserLinks then
		v17 = useAppPolicy(function(p2)
			return p2.shouldUseExternalBrowserForMorePageItem()
		end)
	else
		v17 = false
	end

	local v18

	if FFlagFlyoutSidePanelTradesEntry then
		v18 = useSelector(function(p2)
			local user = p2.Users[p2.LocalUserId]

			if not user then
				return false
			end

			local v19 = user.membership == Enum.MembershipType.Premium
			local v20 = fFlagEnableBlackbirdCheck and user.hasRobloxSubscription == true
			return v19 or v20
		end)
	else
		v18 = false
	end

	local v19 = useMomentsGating()
	local isAmpPolicyEnabled = v19.isAmpPolicyEnabled
	local v20 = not fFlagEnableRMOnMorePageGUAC or isAmpPolicyEnabled
	local v21 = not v12 or v12 == ""
	local useMemo = React.useMemo
	local function fn()
		local v22 = {
			hasFavoritesData = v9,
			hasContinueData = v8,
			disablePremiumEntrypoint = v10,
			hideGiftCards = v21,
			redeemTileEnabled = v13,
			hasPaidTradingAccess = v18,
			disableBlackbirdEntrypoints = v11,
			webViewSupported = v16,
			externalBrowserAllowed = v17,
			supportsOverscan = v15
		}
		local clones = {}
		local clones2 = {}

		for k, v23 in FLYOUT_DEFAULT_POLICY.MyLibrary do
			local v24 = FlyoutContentSettings.ItemInfo[v23]

			if shouldSkipLibraryItem(v23, v24, v22) then
				continue
			end

			local clone = table.clone(v24)
			updateNotifications(clone, v5, v6, v7)

			table.insert(clones, clone)
		end

		for k, v23 in FLYOUT_DEFAULT_POLICY.AdditionalNavigation do
			local v24 = FlyoutContentSettings.ItemInfo[v23]

			if v24 == nil then
				continue
			end

			if v23 == FlyoutContentSettings.ItemType.Events then
				if not getFFlagPlatformEventEnabled() or getFStringPlatformEventUrl() == "" then
					continue
				end
			elseif v23 == FlyoutContentSettings.ItemType.Learn and fFlagFlyoutGateLearnPlace then
				if not v14 then
					continue
				end
			elseif
				v23 == FlyoutContentSettings.ItemType.Moments
				and (fFlagFlyoutRemoveMomentsForArgoEnabled and fFlagEnableArgus and fFlagArgoEnableMoments or fFlagFlyoutRemoveMomentsForArgoEnabled and v19 ~= nil and not v19.isSupportedOnPlatform or (v19 == nil or not v19.isFlyoutEntryEnabled) and not (fFlagEnableRMOnMorePageForAll or v20))
			then
				continue
			end

			if not (not fFlagFlyoutFilterWebViewsAndBrowserLinks or v16 or not FlyoutContentSettings.itemRequiresWebView(v24, v17)) then
				continue
			end

			local clone = table.clone(v24)

			if v23 == FlyoutContentSettings.ItemType.Moments and v19 ~= nil then
				local v25 = if canRenderNativeMoments(v19) then {
					appPage = appPage.Moments,
					destinationType = FlyoutContentSettings.DestinationType.AppPage
				} else {
					appUri = FlyoutContentSettings.MomentsExperienceUri,
					destinationType = FlyoutContentSettings.DestinationType.PlaceLaunch
				}
				clone.context = v25
			end

			table.insert(clones2, clone)
		end

		return { myLibraryItems = clones, additionalNavigationItems = clones2 }
	end

	local v25 = if fFlagFlyoutFilterWebViewsAndBrowserLinks then v16 else nil
	local v26 = if fFlagFlyoutFilterWebViewsAndBrowserLinks then v17 else nil
	local v27 = if FFlagFlyoutSidePanelTradesEntry then v18 else nil
	local v28 = if fFlagFlyoutGateLearnPlace then v14 else nil
	local v29 = if FFlagFlyoutAddAdjustScreen then v15 else nil
	local v30 = if fFlagLuaAppFixNotificationBadgeCountsSync then v6 else nil
	return useMemo(fn, {
		v9,
		v8,
		FLYOUT_DEFAULT_POLICY,
		v5,
		v10,
		v11,
		v21,
		v25,
		v26,
		v27,
		v20,
		v28,
		v29,
		v19,
		v30,
		if fFlagLuaAppFixNotificationBadgeCountsSync then v7 else nil
	})
end

return useFlyoutNavigationItems
