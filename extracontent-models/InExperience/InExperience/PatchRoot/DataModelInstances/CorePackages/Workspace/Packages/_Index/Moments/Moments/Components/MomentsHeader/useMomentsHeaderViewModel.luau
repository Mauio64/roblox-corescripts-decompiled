local Players = game:GetService("Players")
local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local AppComposition = require(MomentsParent.AppComposition)
local Foundation = require(MomentsParent.Foundation)
local MomentsCommon = require(MomentsParent.MomentsCommon)
local React = require(MomentsParent.React)
local useCompositionLayout = AppComposition.useCompositionLayout
local useTokens = Foundation.Hooks.useTokens
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useStatusBarHeight = MomentsCommon.Hooks.useStatusBarHeight
local useIsTvRemoteDevice = require(MomentsParent.RoactUtils).Hooks.useIsTvRemoteDevice
local useSetDrawerVisible = require(MomentsParent.Drawer).Hooks.useSetDrawerVisible
local GetFFlagMomentsAndroidTvEnabled = require(Moments.Flags.GetFFlagMomentsAndroidTvEnabled)
local FFlagMomentsUseCompositionLibrary = require(Moments.Flags.FFlagMomentsUseCompositionLibrary)
local FFlagMomentsUseFoundationHeaderBar = require(Moments.Flags.FFlagMomentsUseFoundationHeaderBar)

require(script.Parent.MomentsHeaderView)

local Analytics = MomentsCommon.Analytics
local EventNames = Analytics.EventNames
local fireAnalyticsEvent = Analytics.fireAnalyticsEvent

local function noop() -- line: 47
end
local function getAnalyticsFields() -- line: 49
	-- upvalues: Players (copy)
	return {
		userId = tostring(not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId),
		timestamp = tostring(os.time())
	}
end
local function useMomentsHeaderViewModel(t1: {[any]: any}, b1: boolean, b2: boolean) -- line: 56
	-- upvalues: useTokens (copy), useDeviceInsets (copy), useSetDrawerVisible (copy), useIsTvRemoteDevice (copy), FFlagMomentsUseCompositionLibrary (copy), FFlagMomentsUseFoundationHeaderBar (copy), useCompositionLayout (copy), useStatusBarHeight (copy), noop (copy), React (copy), fireAnalyticsEvent (copy), EventNames (copy), Players (copy), GetFFlagMomentsAndroidTvEnabled (copy)
	local v26 = useTokens()
	local v27 = useDeviceInsets()
	local v28 = useSetDrawerVisible()
	local v29 = useIsTvRemoteDevice()
	local v30 = FFlagMomentsUseCompositionLibrary and FFlagMomentsUseFoundationHeaderBar
	local v31 = nil
	local v32 = nil
	local n1 = 0

	if v30 then
		v31 = useCompositionLayout()
		v32 = useStatusBarHeight()
		n1 = v26.Size.Size_1400
	end

	local v34 = t1.showFtuxTooltip == true
	local v35 = t1.onFtuxTooltipDismissed or noop
	local v36 = t1.onCreatePressed or noop

	React.useEffect(function() -- line: 79
		-- upvalues: v34 (copy), fireAnalyticsEvent (copy), EventNames (copy), Players (copy)
		if v34 then
			fireAnalyticsEvent(EventNames.FTUXTooltipImpression, {
				userId = tostring(not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId),
				timestamp = tostring(os.time())
			})
		end
	end, { v34 })

	local v37 = React.useCallback(function() -- line: 85
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), Players (copy), v35 (copy)
		fireAnalyticsEvent(EventNames.FTUXTooltipDismissed, {
			userId = tostring(not Players.LocalPlayer and 0 or Players.LocalPlayer.UserId),
			timestamp = tostring(os.time())
		})
		v35()
	end, { v35 })
	local v38 = React.useCallback(function() -- line: 90
		-- upvalues: v34 (copy), v37 (copy), v36 (copy)
		if v34 then
			v37()
		end

		v36()
	end, {
		v34,
		v37,
		v36
	})
	local v39 = React.useCallback(function() -- line: 97
		-- upvalues: v28 (copy)
		v28(true)
	end, { v28 })
	local v40 = v31 == nil and 0 or v31.margin
	local top = v27.top

	if v30 then
		top = v32
	end

	local t2 = {
		left = UDim.new(0, (math.max(v27.left, v40))),
		right = UDim.new(0, (math.max(v27.right, v40))),
		top = UDim.new(0, top)
	}
	local v43 = v27.top + v26.Size.Size_2000 + v26.Size.Size_1600

	return {
		layoutOrder = if not b1 then t1.layoutOrder else nil,
		variant = t1.variant,
		showFtuxTooltip = v34,
		onCreateMomentButtonPressed = v38,
		onFtuxTooltipClosed = v37,
		onHamburgerPressed = v39,
		onBack = t1.onBack or noop,
		onClose = t1.onClose or noop,
		onNavigateToTrending = t1.onNavigateToTrending or noop,
		onNavigateToMyMoments = t1.onNavigateToMyMoments or noop,
		title = t1.title or "",
		showTopScrim = t1.showTopScrim == true,
		showInteractiveButtons = not (GetFFlagMomentsAndroidTvEnabled() and v29),
		showHamburger = b2,
		headerHeight = n1,
		headerPadding = t2,
		titleTextStyle = v26.Color.Content.Emphasis,
		scrimHeight = v43
	}
end

return useMomentsHeaderViewModel
