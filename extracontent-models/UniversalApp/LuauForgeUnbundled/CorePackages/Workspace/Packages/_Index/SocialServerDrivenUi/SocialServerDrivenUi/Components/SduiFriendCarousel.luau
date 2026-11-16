local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SharedFlags")

local DiscoveryTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/DiscoveryTypes")
local findAnalyticsField = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiCoreSystem").findAnalyticsField
local SocialCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SocialCarousel")

local flyoutSidePanelIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SharedExperimentDefinition").FlyoutSidePanelIXP
local OpenProfileQRCodePageBridge = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/System/OpenProfileQRCodePageBridge")

local fFlagEnableFlyoutFriendsHeaderFix = SharedFlags.FFlagEnableFlyoutFriendsHeaderFix
local fFlagFlyoutHideFriendsHeader = SocialCarousel.Flags.FFlagFlyoutHideFriendsHeader
local fFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways
local fFlagLuaAppFriendsSortHeaderByPosition = SharedFlags.FFlagLuaAppFriendsSortHeaderByPosition
local fFlagLuaAppHomeFriendsRemoveItemImpressions = SharedFlags.FFlagLuaAppHomeFriendsRemoveItemImpressions
local fFlagSocialCarouselShareQREnabled = SharedFlags.FFlagSocialCarouselShareQREnabled

local fIntLuaAppFriendsSortHeaderMaxHiddenPosition = SharedFlags.FIntLuaAppFriendsSortHeaderMaxHiddenPosition

local SORT_INDEX_SELECTION_ORDER_MULTIPLIER = DiscoveryTypes.Constants.SORT_INDEX_SELECTION_ORDER_MULTIPLIER
local SORT_SELECTION_ORDER_BASE = DiscoveryTypes.Constants.SORT_SELECTION_ORDER_BASE

local function getShouldHideCarouselHeader(p2)
	if fIntLuaAppFriendsSortHeaderMaxHiddenPosition < p2 then
		return false
	end

	local v5 = fFlagFlyoutHideFriendsHeader

	if not v5 then
		return v5
	end

	if fFlagEnableFlyoutFriendsHeaderFix then
		return (flyoutSidePanelIXP.isFriendsSortHeaderHiddenInFlyoutIxp())
	end

	v5 = flyoutSidePanelIXP.isFlyoutSidePanelEnabled()
	return v5
end

local function SduiFriendCarousel(props)
	local v5 = tonumber(findAnalyticsField(
			"collectionPosition",
			props.analyticsContext.analyticsData or {},
			-1
		))
		or -1

	local v6 = React.useMemo(function()
		return {
			sortIndex = v5,
			appPage = props.sduiContext.appPage,
			sortId = props.sortId,
			startRow = props.startRow
		}
	end, { v5, props.sduiContext.appPage, props.sortId, props.startRow })

	local createElement = React.createElement
	local entry = SocialCarousel.Entry
	local v7 = {
		unifiedLogging = {
			sortIndex = v5,
			appPage = props.sduiContext.appPage,
			sortId = props.sortId or "",
			scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
			impressionTag = "HomeFriendCarousel",
			skipItemImpressionsLog = fFlagLuaAppHomeFriendsRemoveItemImpressions and true or nil
		},
		sortAnalyticsData = v6,
		refreshSignal = props.refreshSignal,
		selectionOrderBase = SORT_SELECTION_ORDER_BASE + v5 * SORT_INDEX_SELECTION_ORDER_MULTIPLIER,
		source = SocialCarousel.Constants.ANALYTICS.SRC.HOMEPAGE_FRIENDS_CAROUSEL,
		hideCarouselHeader = 0,
		appCompositionEnabled = 0,
		navigateToQRCodePage = 0
	}
	local v8

	if fFlagLuaAppFriendsSortHeaderByPosition then
		if fIntLuaAppFriendsSortHeaderMaxHiddenPosition < v5 then
			v8 = false
		else
			v8 = fFlagFlyoutHideFriendsHeader

			if v8 then
				if fFlagEnableFlyoutFriendsHeaderFix then
					v8 = flyoutSidePanelIXP.isFriendsSortHeaderHiddenInFlyoutIxp()
				else
					v8 = flyoutSidePanelIXP.isFlyoutSidePanelEnabled()
				end
			end
		end
	elseif fFlagFlyoutHideFriendsHeader then
		v8 = (if fFlagEnableFlyoutFriendsHeaderFix then flyoutSidePanelIXP.isFriendsSortHeaderHiddenInFlyoutIxp() else flyoutSidePanelIXP.isFlyoutSidePanelEnabled())
			and true
			or nil
	end

	v7.hideCarouselHeader = v8

	v7.appCompositionEnabled = fFlagLuaAppCompositionAlways and true
		or props.sduiContext.appCompositionEnabled

	local v9 = if fFlagSocialCarouselShareQREnabled then OpenProfileQRCodePageBridge.requestOpen else nil
	v7.navigateToQRCodePage = v9
	return createElement(entry, v7)
end

return SduiFriendCarousel
