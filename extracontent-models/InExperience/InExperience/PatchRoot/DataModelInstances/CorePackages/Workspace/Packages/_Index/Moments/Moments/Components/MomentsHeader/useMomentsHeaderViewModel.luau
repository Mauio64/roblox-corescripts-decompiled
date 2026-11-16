local Players = game:GetService("Players")

local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local AppComposition = require(parent.AppComposition)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local useCompositionLayout = AppComposition.useCompositionLayout
local useTokens = Foundation.Hooks.useTokens
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useStatusBarHeight = MomentsCommon.Hooks.useStatusBarHeight
local RoactUtils = require(parent.RoactUtils)
local useIsTvRemoteDevice = RoactUtils.Hooks.useIsTvRemoteDevice
local Drawer = require(parent.Drawer)
local useSetDrawerVisible = Drawer.Hooks.useSetDrawerVisible
local useLocalization = Localization.Hooks.useLocalization

local GetFFlagMomentsAndroidTvEnabled = require(Moments.Flags.GetFFlagMomentsAndroidTvEnabled)
local FFlagMomentsFtuxTooltipCreateCopy = require(Moments.Flags.FFlagMomentsFtuxTooltipCreateCopy)
local FFlagMomentsFixFeedForDeviceSafeInsets = require(Moments.Flags.FFlagMomentsFixFeedForDeviceSafeInsets)
local FFlagMomentsFollowingFeed = require(Moments.Flags.FFlagMomentsFollowingFeed)
local Display = require(parent.Display)
local shouldUseDeviceSafeInsets = Display.shouldUseDeviceSafeInsets
local MomentsFeedType = require(Moments.Enums.MomentsFeedType)
require(script.Parent.MomentsHeaderView)
local useTrendingFeedLabel = require(Moments.Hooks.useTrendingFeedLabel)

local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent

local v = {
	title = "Feature.Moments.Tooltip.ShareFirstMomentTitle",
	text = "Feature.Moments.Tooltip.ShareFirstMomentBody"
}

local v2 = { following = "Feature.Moments.Label.FeedFollowing" }

local function noop() end

local function getAnalyticsFields() -- 2 equivalent calls inferred from this helper
	return {
		userId = tostring(not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId),
		timestamp = tostring(os.time()),
		identifier = "create_moment"
	}
end

local function useMomentsHeaderViewModel(data, flag: boolean, showHamburger: boolean)
	local v3 = useTokens()
	local v4 = useDeviceInsets()
	local v5 = useSetDrawerVisible()
	local v6 = useIsTvRemoteDevice()
	local v7 = useCompositionLayout()
	local v8 = useStatusBarHeight()
	local size_1400 = v3.Size.Size_1400

	local showFtuxTooltip = data.showFtuxTooltip == true
	local ftuxTooltipTitle, ftuxTooltipText

	if FFlagMomentsFtuxTooltipCreateCopy then
		local v9 = useLocalization(v)
		ftuxTooltipTitle = v9.title
		ftuxTooltipText = v9.text
	else
		ftuxTooltipTitle = ""
		ftuxTooltipText = ""
	end

	local feedTypeChips = nil

	if FFlagMomentsFollowingFeed then
		local v9 = useLocalization(v2)

		local text = useTrendingFeedLabel()
		local onFeedTypeSelected = data.onFeedTypeSelected

		if onFeedTypeSelected ~= nil then
			local selectedFeedType = data.selectedFeedType or MomentsFeedType.Trending
			feedTypeChips = {
				{
					id = MomentsFeedType.Trending,
					text = text,
					isChecked = selectedFeedType == MomentsFeedType.Trending,
					onActivated = function()
						onFeedTypeSelected(MomentsFeedType.Trending)
					end
				},
				{
					id = MomentsFeedType.Following,
					text = v9.following,
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
			fireAnalyticsEvent(EventNames.FTUXTooltipImpression, getAnalyticsFields()) -- inferred equivalent call
		end
	end, { showFtuxTooltip })

	local onFtuxTooltipClosed = React.useCallback(function()
		fireAnalyticsEvent(EventNames.FTUXTooltipDismissed, getAnalyticsFields()) -- inferred equivalent call
		onFtuxTooltipDismissed()
	end, { onFtuxTooltipDismissed })

	local onCreateMomentButtonPressed = React.useCallback(function()
		if showFtuxTooltip then
			onFtuxTooltipClosed()
		end

		onCreatePressed()
	end, { showFtuxTooltip, onFtuxTooltipClosed, onCreatePressed })

	local onHamburgerPressed = React.useCallback(function()
		v5(true)
	end, { v5 })

	local margin = v7.margin

	local headerPadding = {
		left = UDim.new(0, (math.max(v4.left, margin))),
		right = UDim.new(0, (math.max(v4.right, margin))),
		top = UDim.new(0, v8)
	}

	local scrimHeight = v4.top + v3.Size.Size_2000 + v3.Size.Size_1600

	if feedTypeChips ~= nil then
		scrimHeight += v3.Size.Size_800
	end

	local scrimTopOffset

	if FFlagMomentsFixFeedForDeviceSafeInsets and shouldUseDeviceSafeInsets then
		scrimTopOffset = -v4.top
	end

	local layoutOrder

	if not flag then
		layoutOrder = data.layoutOrder
	end

	return {
		layoutOrder = layoutOrder,
		variant = data.variant,
		showFtuxTooltip = showFtuxTooltip,
		ftuxTooltipTitle = ftuxTooltipTitle,
		ftuxTooltipText = ftuxTooltipText,
		onCreateMomentButtonPressed = onCreateMomentButtonPressed,
		onFtuxTooltipClosed = onFtuxTooltipClosed,
		onHamburgerPressed = onHamburgerPressed,
		onBack = data.onBack or noop,
		onClose = data.onClose or noop,
		onNavigateToTrending = data.onNavigateToTrending or noop,
		onNavigateToMyMoments = data.onNavigateToMyMoments or noop,
		title = data.title or "",
		showTopScrim = data.showTopScrim == true,
		showInteractiveButtons = not (GetFFlagMomentsAndroidTvEnabled() and v6),
		showHamburger = showHamburger,
		showCreateButton = data.onCreatePressed ~= nil,
		showNavigationMenu = data.onNavigateToTrending ~= nil and data.onNavigateToMyMoments ~= nil,
		headerHeight = size_1400,
		headerPadding = headerPadding,
		titleTextStyle = v3.Color.Content.Emphasis,
		scrimHeight = scrimHeight,
		scrimTopOffset = scrimTopOffset,
		feedTypeChips = feedTypeChips
	}
end

return useMomentsHeaderViewModel
