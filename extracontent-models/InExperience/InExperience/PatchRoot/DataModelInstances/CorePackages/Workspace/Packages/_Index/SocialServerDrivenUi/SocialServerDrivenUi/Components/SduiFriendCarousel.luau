local SocialServerDrivenUi = script:FindFirstAncestor("SocialServerDrivenUi")
local parent = SocialServerDrivenUi.Parent

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local DiscoveryTypes = require(parent.DiscoveryTypes)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local findAnalyticsField = SduiCoreSystem.findAnalyticsField
local SocialCarousel = require(parent.SocialCarousel)

local SharedExperimentDefinition = require(parent.SharedExperimentDefinition)
local FlyoutSidePanelIXP = SharedExperimentDefinition.FlyoutSidePanelIXP
local OpenProfileQRCodePageBridge = require(SocialServerDrivenUi.System.OpenProfileQRCodePageBridge)

local FFlagEnableFlyoutFriendsHeaderFix = SharedFlags.FFlagEnableFlyoutFriendsHeaderFix
local FFlagFlyoutHideFriendsHeader = SocialCarousel.Flags.FFlagFlyoutHideFriendsHeader
local FFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways
local FFlagMobileGameJoinCardVideo = SharedFlags.FFlagMobileGameJoinCardVideo
local FFlagLuaAppFriendsSortHeaderByPosition = SharedFlags.FFlagLuaAppFriendsSortHeaderByPosition
local FFlagLuaAppHomeFriendsRemoveItemImpressions = SharedFlags.FFlagLuaAppHomeFriendsRemoveItemImpressions
local FFlagSocialCarouselShareQREnabled = SharedFlags.FFlagSocialCarouselShareQREnabled

local FIntLuaAppFriendsSortHeaderMaxHiddenPosition = SharedFlags.FIntLuaAppFriendsSortHeaderMaxHiddenPosition

local SORT_INDEX_SELECTION_ORDER_MULTIPLIER = DiscoveryTypes.Constants.SORT_INDEX_SELECTION_ORDER_MULTIPLIER
local SORT_SELECTION_ORDER_BASE = DiscoveryTypes.Constants.SORT_SELECTION_ORDER_BASE

local function getShouldHideCarouselHeader(p: number)
	if FIntLuaAppFriendsSortHeaderMaxHiddenPosition < p then
		return false
	end

	local fFlagFlyoutHideFriendsHeader = FFlagFlyoutHideFriendsHeader

	if not fFlagFlyoutHideFriendsHeader then
		return fFlagFlyoutHideFriendsHeader
	end

	if FFlagEnableFlyoutFriendsHeaderFix then
		return (FlyoutSidePanelIXP.isFriendsSortHeaderHiddenInFlyoutIxp())
	end

	return (FlyoutSidePanelIXP.isFlyoutSidePanelEnabled())
end

local function SduiFriendCarousel(props)
	local sortIndex = tonumber(findAnalyticsField(
			"collectionPosition",
			props.analyticsContext.analyticsData or {},
			-1
		))
		or -1

	local sortAnalyticsData = React.useMemo(function()
		return {
			sortIndex = sortIndex,
			appPage = props.sduiContext.appPage,
			sortId = props.sortId,
			startRow = props.startRow
		}
	end, { sortIndex, props.sduiContext.appPage, props.sortId, props.startRow })

	local createElement = React.createElement
	local entry = SocialCarousel.Entry
	local v = {
		unifiedLogging = {
			sortIndex = sortIndex,
			appPage = props.sduiContext.appPage,
			sortId = props.sortId or "",
			scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
			impressionTag = "HomeFriendCarousel",
			skipItemImpressionsLog = FFlagLuaAppHomeFriendsRemoveItemImpressions and true or nil
		},
		sortAnalyticsData = sortAnalyticsData,
		refreshSignal = props.refreshSignal,
		selectionOrderBase = SORT_SELECTION_ORDER_BASE + sortIndex * SORT_INDEX_SELECTION_ORDER_MULTIPLIER,
		source = SocialCarousel.Constants.ANALYTICS.SRC.HOMEPAGE_FRIENDS_CAROUSEL,
		hideCarouselHeader = 0,
		appCompositionEnabled = 0,
		navigateToQRCodePage = 0,
		isJoinCardVideoEnabled = 0,
		videoPlaybackContext = 0
	}
	local hideCarouselHeader

	if FFlagLuaAppFriendsSortHeaderByPosition then
		if FIntLuaAppFriendsSortHeaderMaxHiddenPosition < sortIndex then
			hideCarouselHeader = false
		else
			hideCarouselHeader = FFlagFlyoutHideFriendsHeader

			if hideCarouselHeader then
				if FFlagEnableFlyoutFriendsHeaderFix then
					hideCarouselHeader = FlyoutSidePanelIXP.isFriendsSortHeaderHiddenInFlyoutIxp()
				else
					hideCarouselHeader = FlyoutSidePanelIXP.isFlyoutSidePanelEnabled()
				end
			end
		end
	elseif FFlagFlyoutHideFriendsHeader then
		local v2

		if FFlagEnableFlyoutFriendsHeaderFix then
			v2 = FlyoutSidePanelIXP.isFriendsSortHeaderHiddenInFlyoutIxp()
		else
			v2 = FlyoutSidePanelIXP.isFlyoutSidePanelEnabled()
		end

		hideCarouselHeader = v2 and true or nil
	end

	v.hideCarouselHeader = hideCarouselHeader

	v.appCompositionEnabled = FFlagLuaAppCompositionAlways and true or props.sduiContext.appCompositionEnabled
	local navigateToQRCodePage

	if FFlagSocialCarouselShareQREnabled then
		navigateToQRCodePage = OpenProfileQRCodePageBridge.requestOpen
	end

	v.navigateToQRCodePage = navigateToQRCodePage
	local isJoinCardVideoEnabled

	if FFlagMobileGameJoinCardVideo then
		isJoinCardVideoEnabled = props.sduiContext.appPage == AppPage.Home
	end

	v.isJoinCardVideoEnabled = isJoinCardVideoEnabled
	local videoPlaybackContext

	if FFlagMobileGameJoinCardVideo then
		videoPlaybackContext = props.sduiContext.videoPlaybackContext
	end

	v.videoPlaybackContext = videoPlaybackContext
	return createElement(entry, v)
end

return SduiFriendCarousel
