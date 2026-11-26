local Players = game:GetService("Players")

local AppComposition = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/AppComposition")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local useCompositionLayout = AppComposition.useCompositionLayout
local useTokens = Foundation.Hooks.useTokens
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useStatusBarHeight = MomentsCommon.Hooks.useStatusBarHeight
local useIsTvRemoteDevice = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/RoactUtils").Hooks.useIsTvRemoteDevice
local useSetDrawerVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Drawer").Hooks.useSetDrawerVisible
local useLocalization = Localization.Hooks.useLocalization

local fFlagMomentsCreateAvatarPosts = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsCreateAvatarPosts
local GetFFlagMomentsAndroidTvEnabled = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/GetFFlagMomentsAndroidTvEnabled")
local FFlagMomentsFtuxTooltipCreateCopy = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFtuxTooltipCreateCopy")
local FFlagMomentsFixFeedForDeviceSafeInsets = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFixFeedForDeviceSafeInsets")
local FFlagMomentsFollowingFeed = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFollowingFeed")
local shouldUseDeviceSafeInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Display").shouldUseDeviceSafeInsets
local MomentsFeedType = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Enums/MomentsFeedType")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/MomentsHeader/MomentsHeaderView")
local useTrendingFeedLabel = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useTrendingFeedLabel")

local analytics = MomentsCommon.Analytics
local eventNames = analytics.EventNames
local fireAnalyticsEvent = analytics.fireAnalyticsEvent

local v5 = {
	title = "Feature.Moments.Tooltip.ShareFirstMomentTitle",
	text = "Feature.Moments.Tooltip.ShareFirstMomentBody"
}

local v6 = { following = "Feature.Moments.Label.FeedFollowing" }

local function noop() end

local function getAnalyticsFields()
	return {
		userId = tostring(not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId),
		timestamp = tostring(os.time()),
		identifier = "create_moment"
	}
end

local function useMomentsHeaderViewModel(data, p2, showHamburger)
	local v7 = useTokens()
	local v8 = useDeviceInsets()
	local v9 = useSetDrawerVisible()
	local v10 = useIsTvRemoteDevice()
	local v11 = useCompositionLayout()
	local v12 = useStatusBarHeight()
	local size_1400 = v7.Size.Size_1400

	local showFtuxTooltip = data.showFtuxTooltip == true
	local v13, v14

	if FFlagMomentsFtuxTooltipCreateCopy then
		local v15 = useLocalization(v5)
		v13 = v15.title
		v14 = v15.text
	else
		v13 = ""
		v14 = ""
	end

	local v15 = nil
	local v16 = false
	local v17 = 0

	if FFlagMomentsFollowingFeed then
		local v18 = useLocalization(v6)

		local v19 = useTrendingFeedLabel()
		local onFeedTypeSelected = data.onFeedTypeSelected

		if onFeedTypeSelected ~= nil then
			local selectedFeedType = data.selectedFeedType or MomentsFeedType.Trending
			v15 = {
				{
					id = MomentsFeedType.Trending,
					text = v19,
					isChecked = selectedFeedType == MomentsFeedType.Trending,
					onActivated = function()
						onFeedTypeSelected(MomentsFeedType.Trending)
					end
				},
				{
					id = MomentsFeedType.Following,
					text = v18.following,
					isChecked = selectedFeedType == MomentsFeedType.Following,
					onActivated = function()
						onFeedTypeSelected(MomentsFeedType.Following)
					end
				}
			}

			v16 = true

			if data.variant == "base" then
				v17 = v7.Size.Size_200
			end
		end
	end

	local onFtuxTooltipDismissed = data.onFtuxTooltipDismissed or noop
	local onCreatePressed = data.onCreatePressed or noop

	React.useEffect(function()
		if showFtuxTooltip then
			fireAnalyticsEvent(eventNames.FTUXTooltipImpression, {
				userId = tostring(not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId),
				timestamp = tostring(os.time()),
				identifier = "create_moment"
			})
		end
	end, { showFtuxTooltip })

	local v18 = React.useCallback(function()
		fireAnalyticsEvent(eventNames.FTUXTooltipDismissed, {
			userId = tostring(not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId),
			timestamp = tostring(os.time()),
			identifier = "create_moment"
		})
		onFtuxTooltipDismissed()
	end, { onFtuxTooltipDismissed })

	local v19 = React.useCallback(function()
		if showFtuxTooltip then
			v18()
		end

		onCreatePressed()
	end, { showFtuxTooltip, v18, onCreatePressed })

	local v20 = React.useCallback(function()
		v9(true)
	end, { v9 })

	local margin = v11.margin

	local v21 = {
		left = UDim.new(0, (math.max(v8.left, margin))),
		right = UDim.new(0, (math.max(v8.right, margin - v17))),
		top = UDim.new(0, v12)
	}

	local v22 = v8.top + v7.Size.Size_2000 + v7.Size.Size_1600

	if v15 ~= nil then
		v22 += v7.Size.Size_800
	end

	local v23 = if FFlagMomentsFixFeedForDeviceSafeInsets and shouldUseDeviceSafeInsets then -v8.top else nil

	local v25 = if not p2 then data.layoutOrder else nil
	local v24 = {
		layoutOrder = v25,
		variant = data.variant,
		showFtuxTooltip = showFtuxTooltip,
		ftuxTooltipTitle = v13,
		ftuxTooltipText = v14,
		onCreateMomentButtonPressed = v19,
		onCreateAvatarMomentPressed = 0,
		onFtuxTooltipClosed = 0,
		onHamburgerPressed = 0,
		onBack = 0,
		onClose = 0,
		onNavigateToTrending = 0,
		onNavigateToMyMoments = 0,
		title = 0,
		showTopScrim = 0,
		showInteractiveButtons = 0,
		showHamburger = 0,
		showCreateButton = 0,
		showNavigationMenu = 0,
		showMyMomentsButton = 0,
		headerHeight = 0,
		headerPadding = 0,
		titleTextStyle = 0,
		scrimHeight = 0,
		scrimTopOffset = 0,
		feedTypeChips = 0
	}

	local v26 = if fFlagMomentsCreateAvatarPosts then data.onCreateAvatarMomentPressed else nil
	v24.onCreateAvatarMomentPressed = v26

	v24.onFtuxTooltipClosed = v18
	v24.onHamburgerPressed = v20
	v24.onBack = data.onBack or noop
	v24.onClose = data.onClose or noop
	v24.onNavigateToTrending = data.onNavigateToTrending or noop
	v24.onNavigateToMyMoments = data.onNavigateToMyMoments or noop
	v24.title = data.title or ""
	v24.showTopScrim = data.showTopScrim == true
	v24.showInteractiveButtons = not (GetFFlagMomentsAndroidTvEnabled() and v10)
	v24.showHamburger = showHamburger
	v24.showCreateButton = data.onCreatePressed ~= nil
	v24.showNavigationMenu = data.onNavigateToTrending ~= nil and data.onNavigateToMyMoments ~= nil
	v24.showMyMomentsButton = v16
	v24.headerHeight = size_1400
	v24.headerPadding = v21
	v24.titleTextStyle = v7.Color.Content.Emphasis
	v24.scrimHeight = v22
	v24.scrimTopOffset = v23
	v24.feedTypeChips = v15
	return v24
end

return useMomentsHeaderViewModel
