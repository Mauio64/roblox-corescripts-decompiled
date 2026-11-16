local AppBlox = script:FindFirstAncestor("AppBlox")
local parent = AppBlox.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Responsive = require(parent.Responsive)
local SharedFlags = require(parent.SharedFlags)
local Display = require(parent.Display)
local AppNavBar = require(parent.AppNavBar)
local View = Foundation.View
local withDefaults = Foundation.Utility.withDefaults
local useTokens = Foundation.Hooks.useTokens
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useDeviceInsets = Responsive.useDeviceInsets
local useNavBarSize = AppNavBar.useNavBarSize
local useNavBarPlacement = AppNavBar.useNavBarPlacement

local AppComposition = require(parent.AppComposition)
local CompositionTags = AppComposition.CompositionTags

local DetailsPageLayoutContext = require(script.Parent.DetailsPageLayoutContext)
local DetailsPageLayoutUtils = require(script.Parent.DetailsPageLayoutUtils)

local FFlagDetailsPageLayoutUseMeasuredSizeForInitialScroll = require(AppBlox.Flags.FFlagDetailsPageLayoutUseMeasuredSizeForInitialScroll)

local FFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport
local FFlagLuaAppEdpDirectionalGradientMidTransparency = SharedFlags.FFlagLuaAppEdpDirectionalGradientMidTransparency

local v = {
	testId = "app-blox-details-page",
	fullBleedAspectRatio = 16 / 9,
	fullBleedOverlapOffset = 180,
	reserveHeaderBarSpace = true
}

local function DetailsPageLayoutRoot(p, ref3)
	local v2 = useDeviceInsets()
	local v3 = useTokens()

	local v4 = withDefaults(p, v)
	local compositionLayoutTag = v4.compositionLayoutTag or CompositionTags.Layout.Detail

	local fullBleedAspectRatio = v4.fullBleedAspectRatio
	local fullBleedAspectRatio2 = (fullBleedAspectRatio == nil or not (fullBleedAspectRatio > 0)) and 16 / 9
		or fullBleedAspectRatio
	local hasFullBleed

	if v4.fullBleedContent == nil then
		hasFullBleed = false
	else
		hasFullBleed = not v4.isFullscreen
	end

	local hasHeader, setHasHeader = React.useBinding(false)
	local hasActions, setHasActions = React.useBinding(false)
	local actionBarHeight, setActionBarHeight = React.useBinding(0)

	local scale = v3.Config.UI.Scale
	local fullBleedOverlapOffset = v4.fullBleedOverlapOffset * scale
	local gradientTopBleedOffset

	if v4.gradientTopBleedOffset then
		gradientTopBleedOffset = v4.gradientTopBleedOffset * scale
	else
		gradientTopBleedOffset = v3.Size.Size_2000
	end

	local v5 = v3.Size.Size_1000 + v3.Padding.Large + v3.Padding.Medium
	local v6 = Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small)

	if FFlagLuaAppMediaGalleryGamepadSupport then
		if v4.reserveHeaderBarSpace then
			if not v6 then
				v5 = v3.Size.Size_2000
			end
		else
			v5 = 0
		end
	elseif not v6 then
		v5 = v3.Size.Size_2000
	end

	local headerBarHeight = v5 + v2.top

	local state, setState = React.useState(nil)
	local isFullscreenOverlay = state ~= nil
	local state2, setState2 = React.useState(nil)

	local state3, setState3 = React.useState(false)
	local stickyHeaderActive = not hasFullBleed or state3 or isFullscreenOverlay
	local v7 = useNavBarSize()
	local v8 = useNavBarPlacement()

	local v9 = React.useMemo(function()
		local viewportSize = Display.GetDisplayStore(false).getViewportSize(false)
		local v9

		if v8 == AppNavBar.Placement.Left then
			v9 = math.max(0, viewportSize.X - v7)
		else
			v9 = viewportSize.X
		end

		local vector2 = Vector2.new(v9, viewportSize.Y)

		return {
			containerSize = vector2,
			initialScrollY = not hasFullBleed and 0 or DetailsPageLayoutUtils.computeInitialScrollYForSize(vector2, {
				fullBleedAspectRatio = fullBleedAspectRatio2,
				headerBarHeight = headerBarHeight,
				fullBleedOverlapOffset = fullBleedOverlapOffset,
				hasFullBleed = hasFullBleed,
				bannerBottomVisiblePercent = p.bannerBottomVisiblePercent
			})
		}
	end, {})
	local containerSize = v9.containerSize
	local initialScrollY = v9.initialScrollY

	local v10, v11 = React.useBinding(containerSize)
	local v12, v13 = React.useBinding(initialScrollY)
	local v14, v15 = React.useBinding(0)
	local state4, setState4 = React.useState(initialScrollY)
	local state5, setState5 = React.useState(true)

	local ref = React.useRef(hasFullBleed and not FFlagDetailsPageLayoutUseMeasuredSizeForInitialScroll)

	local mapped = v10:map(function(vector2: Vector2)
		return vector2.Y
	end)

	local mapped2 = v10:map(function(vector2: Vector2)
		return UDim2.new(0, vector2.X, 0, vector2.X / fullBleedAspectRatio2)
	end)

	local mapped3 = v10:map(function(vector2: Vector2)
		if hasFullBleed then
			return DetailsPageLayoutUtils.computeContentTopOffset(vector2.X, fullBleedAspectRatio2, headerBarHeight)
		end

		return 0
	end)

	local mapped4 = React.joinBindings({ mapped3, v12 }):map(function(list)
		local item = list[1]
		local item2 = list[2]
		local v16 = math.max(0, item + headerBarHeight - item2) / 2
		return UDim2.new(0.5, 0, 0, v16)
	end)

	local mapped5 = React.joinBindings({ v12, mapped3, v14 }):map(function(list)
		local item = list[1]
		local item2 = list[2]
		local item3 = list[3]

		if item2 == 0 then
			return (math.clamp(item / DetailsPageLayoutUtils.getNoBannerFadeParams(headerBarHeight), 0, 1))
		end

		local headerFadeParams, v16 = DetailsPageLayoutUtils.getHeaderFadeParams(item2, item3, fullBleedOverlapOffset)
		return (math.clamp((item - headerFadeParams) / v16, 0, 1))
	end)

	local onAbsoluteSizeChanged = React.useCallback(function(p2)
		local absoluteSize = p2.AbsoluteSize
		v11(absoluteSize)

		if absoluteSize.X > 0 and absoluteSize.Y > 0 then
			setState5(true)

			if hasFullBleed and not ref.current then
				ref.current = true
				local initialScrollYForSize = DetailsPageLayoutUtils.computeInitialScrollYForSize(absoluteSize, {
					fullBleedAspectRatio = fullBleedAspectRatio2,
					headerBarHeight = headerBarHeight,
					fullBleedOverlapOffset = fullBleedOverlapOffset,
					hasFullBleed = hasFullBleed,
					bannerBottomVisiblePercent = p.bannerBottomVisiblePercent
				})

				setState4(initialScrollYForSize)
				v13(initialScrollYForSize)
			end
		end
	end, {
		hasFullBleed,
		fullBleedAspectRatio2,
		headerBarHeight,
		fullBleedOverlapOffset,
		p.bannerBottomVisiblePercent,
		containerSize
	})

	local ref2 = React.useRef(0)
	local onCanvasSizeChanged = React.useCallback(function(current: number)
		if math.abs(current - ref2.current) > 0.5 then
			ref2.current = current
			v15(current)
		end
	end, {})

	local onCanvasPositionChanged = React.useCallback(function(p2)
		local y = p2.CanvasPosition.Y
		v13(y)

		if hasFullBleed then
			local value = mapped3:getValue()
			local value2 = v14:getValue()

			local headerFadeParams, v16 = DetailsPageLayoutUtils.getHeaderFadeParams(
				value,
				value2,
				fullBleedOverlapOffset
			)
			setState3(DetailsPageLayoutUtils.shouldShowStickyBar(y, value, headerFadeParams, v16))
		end
	end, { hasFullBleed, fullBleedOverlapOffset })

	local useMemo = React.useMemo
	local function fn()
		local v16 = {
			hasFullBleed = hasFullBleed,
			hasHeader = hasHeader,
			setHasHeader = setHasHeader,
			hasActions = hasActions,
			setHasActions = setHasActions,
			isFullscreen = v4.isFullscreen,
			headerBarHeight = headerBarHeight,
			actionBarHeight = actionBarHeight,
			setActionBarHeight = setActionBarHeight,
			onCanvasPositionChanged = onCanvasPositionChanged,
			contentTopOffset = mapped3,
			fullBleedOverlapOffset = fullBleedOverlapOffset,
			gradientTopBleedOffset = gradientTopBleedOffset,
			gradientMidTransparency = 0,
			initialScrollY = 0,
			hasValidContainerSize = 0,
			disableFocusNavEngineScroll = 0,
			containerHeight = 0,
			headerOpacity = 0,
			stickyHeaderActive = 0,
			onClose = 0,
			testId = 0,
			onCanvasSizeChanged = 0,
			isFullscreenOverlay = 0,
			setFullscreenContent = 0,
			onExitFullscreenOverlay = 0,
			setOnExitFullscreenOverlay = 0
		}
		local gradientMidTransparency

		if FFlagLuaAppEdpDirectionalGradientMidTransparency then
			gradientMidTransparency = v4.gradientMidTransparency
		end

		v16.gradientMidTransparency = gradientMidTransparency

		v16.initialScrollY = state4
		v16.hasValidContainerSize = state5
		local disableFocusNavEngineScroll

		if FFlagLuaAppMediaGalleryGamepadSupport then
			disableFocusNavEngineScroll = v4.disableFocusNavEngineScroll
		end

		v16.disableFocusNavEngineScroll = disableFocusNavEngineScroll

		v16.containerHeight = mapped
		v16.headerOpacity = mapped5
		v16.stickyHeaderActive = stickyHeaderActive
		v16.onClose = v4.onClose
		v16.testId = v4.testId
		v16.onCanvasSizeChanged = onCanvasSizeChanged
		v16.isFullscreenOverlay = isFullscreenOverlay
		v16.setFullscreenContent = setState
		v16.onExitFullscreenOverlay = state2
		v16.setOnExitFullscreenOverlay = setState2
		return v16
	end

	local isFullscreen = v4.isFullscreen
	local v16

	if FFlagLuaAppEdpDirectionalGradientMidTransparency then
		v16 = v4.gradientMidTransparency
	end

	local v17 = {
		hasFullBleed,
		isFullscreen,
		headerBarHeight,
		fullBleedOverlapOffset,
		gradientTopBleedOffset,
		v16,
		state4,
		state5,
		stickyHeaderActive,
		v4.onClose,
		v4.testId,
		mapped,
		mapped5,
		onCanvasPositionChanged,
		onCanvasSizeChanged,
		isFullscreenOverlay,
		nil,
		nil
	}
	local v18

	if FFlagLuaAppMediaGalleryGamepadSupport then
		v18 = v4.disableFocusNavEngineScroll
	end

	v17[17], v17[18] = state2, v18
	local v19 = useMemo(fn, v17)

	local createElement = React.createElement
	local provider = DetailsPageLayoutContext.Provider

	local createElement2 = React.createElement
	local v20 = {
		tag = `size-full clip bg-surface-0 {compositionLayoutTag}`,
		stateLayer = { affordance = StateLayerAffordance.None },
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		ref = ref3,
		selectionGroup = v4.selectionGroup,
		testId = `{v4.testId}--root`
	}
	local fullBleed

	if hasFullBleed then
		fullBleed = React.createElement(
			View,
			{
				tag = "position-top-center anchor-top-center size-full clip",
				ZIndex = 0,
				testId = `{v4.testId}--fullbleed`
			},
			{
				ParallaxFrame = React.createElement(
					View,
					{ Position = mapped4, Size = mapped2, tag = "anchor-center-center clip" },
					v4.fullBleedContent
				)
			}
		)
	end

	local v21 = {
		FullBleed = fullBleed,
		Children = React.createElement(React.Fragment, nil, v4.children),
		FullscreenOverlay = 0
	}
	local fullscreenOverlay

	if isFullscreenOverlay then
		fullscreenOverlay = React.createElement(View, {
			Size = hasHeader:map(function(flag: boolean)
				if flag then
					return (UDim2.new(1, 0, 1, -headerBarHeight))
				end

				return (UDim2.fromScale(1, 1))
			end),
			Position = hasHeader:map(function(flag: boolean)
				if flag then
					return (UDim2.fromOffset(0, headerBarHeight))
				end

				return (UDim2.fromOffset(0, 0))
			end),
			ZIndex = 10,
			tag = "clip",
			testId = `{v4.testId}--fullscreen-overlay`
		}, state)
	end

	v21.FullscreenOverlay = fullscreenOverlay
	return createElement(provider, { value = v19 }, createElement2(View, v20, v21))
end

return React.memo(React.forwardRef(DetailsPageLayoutRoot))
