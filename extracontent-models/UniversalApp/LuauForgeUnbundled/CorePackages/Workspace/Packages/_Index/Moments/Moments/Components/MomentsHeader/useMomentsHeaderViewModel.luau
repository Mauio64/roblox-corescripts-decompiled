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

	if FFlagMomentsFollowingFeed then
		local v16 = useLocalization(v6)

		local v17 = useTrendingFeedLabel()
		local onFeedTypeSelected = data.onFeedTypeSelected

		if onFeedTypeSelected ~= nil then
			local selectedFeedType = data.selectedFeedType or MomentsFeedType.Trending
			v15 = {
				{
					id = MomentsFeedType.Trending,
					text = v17,
					isChecked = selectedFeedType == MomentsFeedType.Trending,
					onActivated = function()
						onFeedTypeSelected(MomentsFeedType.Trending)
					end
				},
				{
					id = MomentsFeedType.Following,
					text = v16.following,
					isChecked = selectedFeedType == MomentsFeedType.Following,
					onActivated = function()
						onFeedTypeSelected(MomentsFeedType.Following)
					end
				}
			}
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

	local v16 = React.useCallback(function()
		fireAnalyticsEvent(eventNames.FTUXTooltipDismissed, {
			userId = tostring(not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId),
			timestamp = tostring(os.time()),
			identifier = "create_moment"
		})
		onFtuxTooltipDismissed()
	end, { onFtuxTooltipDismissed })

	local v17 = React.useCallback(function()
		if showFtuxTooltip then
			v16()
		end

		onCreatePressed()
	end, { showFtuxTooltip, v16, onCreatePressed })

	local v18 = React.useCallback(function()
		v9(true)
	end, { v9 })

	local margin = v11.margin

	local v19 = {
		left = UDim.new(0, (math.max(v8.left, margin))),
		right = UDim.new(0, (math.max(v8.right, margin))),
		top = UDim.new(0, v12)
	}

	local v20 = v8.top + v7.Size.Size_2000 + v7.Size.Size_1600

	if v15 ~= nil then
		v20 += v7.Size.Size_800
	end

	local v21 = if FFlagMomentsFixFeedForDeviceSafeInsets and shouldUseDeviceSafeInsets then -v8.top else nil

	local v23 = if not p2 then data.layoutOrder else nil
	return {
		layoutOrder = v23,
		variant = data.variant,
		showFtuxTooltip = showFtuxTooltip,
		ftuxTooltipTitle = v13,
		ftuxTooltipText = v14,
		onCreateMomentButtonPressed = v17,
		onFtuxTooltipClosed = v16,
		onHamburgerPressed = v18,
		onBack = data.onBack or noop,
		onClose = data.onClose or noop,
		onNavigateToTrending = data.onNavigateToTrending or noop,
		onNavigateToMyMoments = data.onNavigateToMyMoments or noop,
		title = data.title or "",
		showTopScrim = data.showTopScrim == true,
		showInteractiveButtons = not (GetFFlagMomentsAndroidTvEnabled() and v10),
		showHamburger = showHamburger,
		showCreateButton = data.onCreatePressed ~= nil,
		showNavigationMenu = data.onNavigateToTrending ~= nil and data.onNavigateToMyMoments ~= nil,
		headerHeight = size_1400,
		headerPadding = v19,
		titleTextStyle = v7.Color.Content.Emphasis,
		scrimHeight = v20,
		scrimTopOffset = v21,
		feedTypeChips = v15
	}
end

return useMomentsHeaderViewModel
