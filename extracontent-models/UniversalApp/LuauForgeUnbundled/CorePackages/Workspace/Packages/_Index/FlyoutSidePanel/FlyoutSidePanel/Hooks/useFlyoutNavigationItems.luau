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
		or FFlagFlyoutHideSortDeeplinkItems and FlyoutContentSettings.itemIsGameSortDeeplink(p3)
		or fFlagFlyoutFilterWebViewsAndBrowserLinks
		and not data.webViewSupported
		and FlyoutContentSettings.itemRequiresWebView(p3, data.externalBrowserAllowed)
	then
		return true
	end

	if
		p2 == FlyoutContentSettings.ItemType.Favorites and not data.hasFavoritesData
		or p2 == FlyoutContentSettings.ItemType.ContinuePlaying and not data.hasContinueData
		or p2 == FlyoutContentSettings.ItemType.Premium and data.disablePremiumEntrypoint
	then
		return true
	end

	if
		p2 == FlyoutContentSettings.ItemType.GiftCards and data.hideGiftCards
		or p2 == FlyoutContentSettings.ItemType.Redeem and not data.redeemTileEnabled
		or p2 == FlyoutContentSettings.ItemType.Trades
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

	local v15 = not fFlagFlyoutFilterWebViewsAndBrowserLinks or useAppPolicy(function(p2)
		return p2.getWebViewSupport()
	end)
	local v16

	if fFlagFlyoutFilterWebViewsAndBrowserLinks then
		v16 = useAppPolicy(function(p2)
			return p2.shouldUseExternalBrowserForMorePageItem()
		end)
	else
		v16 = false
	end

	local v17

	if FFlagFlyoutSidePanelTradesEntry then
		v17 = useSelector(function(p2)
			local user = p2.Users[p2.LocalUserId]

			if not user then
				return false
			end

			local v18 = user.membership == Enum.MembershipType.Premium
			local v19 = fFlagEnableBlackbirdCheck and user.hasRobloxSubscription == true
			return v18 or v19
		end)
	else
		v17 = false
	end

	local v18 = useMomentsGating()
	local isAmpPolicyEnabled = v18.isAmpPolicyEnabled
	local v19 = not fFlagEnableRMOnMorePageGUAC or isAmpPolicyEnabled
	local v20 = not v12 or v12 == ""
	local useMemo = React.useMemo
	local function fn()
		local v21 = {
			hasFavoritesData = v9,
			hasContinueData = v8,
			disablePremiumEntrypoint = v10,
			hideGiftCards = v20,
			redeemTileEnabled = v13,
			hasPaidTradingAccess = v17,
			disableBlackbirdEntrypoints = v11,
			webViewSupported = v15,
			externalBrowserAllowed = v16
		}
		local clones = {}
		local clones2 = {}

		for k, v22 in FLYOUT_DEFAULT_POLICY.MyLibrary do
			local v23 = FlyoutContentSettings.ItemInfo[v22]

			if shouldSkipLibraryItem(v22, v23, v21) then
				continue
			end

			local clone = table.clone(v23)
			updateNotifications(clone, v5, v6, v7)

			table.insert(clones, clone)
		end

		for k, v22 in FLYOUT_DEFAULT_POLICY.AdditionalNavigation do
			local v23 = FlyoutContentSettings.ItemInfo[v22]

			if v23 == nil then
				continue
			end

			if v22 == FlyoutContentSettings.ItemType.Events then
				if not getFFlagPlatformEventEnabled() or getFStringPlatformEventUrl() == "" then
					continue
				end
			elseif v22 == FlyoutContentSettings.ItemType.Learn and fFlagFlyoutGateLearnPlace then
				if not v14 then
					continue
				end
			elseif
				v22 == FlyoutContentSettings.ItemType.Moments
				and (fFlagFlyoutRemoveMomentsForArgoEnabled and fFlagEnableArgus and fFlagArgoEnableMoments or fFlagFlyoutRemoveMomentsForArgoEnabled and v18 ~= nil and not v18.isSupportedOnPlatform or (v18 == nil or not v18.isFlyoutEntryEnabled) and not (fFlagEnableRMOnMorePageForAll or v19))
			then
				continue
			end

			if not (not fFlagFlyoutFilterWebViewsAndBrowserLinks or v15 or not FlyoutContentSettings.itemRequiresWebView(v23, v16)) then
				continue
			end

			local clone = table.clone(v23)

			if v22 == FlyoutContentSettings.ItemType.Moments and v18 ~= nil then
				local v24 = if canRenderNativeMoments(v18) then {
					appPage = appPage.Moments,
					destinationType = FlyoutContentSettings.DestinationType.AppPage
				} else {
					appUri = FlyoutContentSettings.MomentsExperienceUri,
					destinationType = FlyoutContentSettings.DestinationType.PlaceLaunch
				}
				clone.context = v24
			end

			table.insert(clones2, clone)
		end

		return { myLibraryItems = clones, additionalNavigationItems = clones2 }
	end

	local v22 = if fFlagFlyoutFilterWebViewsAndBrowserLinks then v15 else nil
	local v23 = if fFlagFlyoutFilterWebViewsAndBrowserLinks then v16 else nil
	local v24 = if FFlagFlyoutSidePanelTradesEntry then v17 else nil
	local v25 = if fFlagFlyoutGateLearnPlace then v14 else nil
	local v26 = if fFlagLuaAppFixNotificationBadgeCountsSync then v6 else nil
	return useMemo(fn, {
		v9,
		v8,
		FLYOUT_DEFAULT_POLICY,
		v5,
		v10,
		v11,
		v20,
		v22,
		v23,
		v24,
		v19,
		v25,
		v18,
		v26,
		if fFlagLuaAppFixNotificationBadgeCountsSync then v7 else nil
	})
end

return useFlyoutNavigationItems
