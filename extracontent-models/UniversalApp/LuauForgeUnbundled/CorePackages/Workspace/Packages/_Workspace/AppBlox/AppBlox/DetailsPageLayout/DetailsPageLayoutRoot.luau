local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Responsive")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SharedFlags")
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Display")
local AppNavBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppNavBar")
local view = Foundation.View
local withDefaults = Foundation.Utility.withDefaults
local useTokens = Foundation.Hooks.useTokens
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useDeviceInsets = Responsive.useDeviceInsets
local useNavBarSize = AppNavBar.useNavBarSize
local useNavBarPlacement = AppNavBar.useNavBarPlacement

local compositionTags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppComposition").CompositionTags

local DetailsPageLayoutContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPageLayout/DetailsPageLayoutContext")
local DetailsPageLayoutUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPageLayout/DetailsPageLayoutUtils")

local FFlagDetailsPageLayoutUseMeasuredSizeForInitialScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/Flags/FFlagDetailsPageLayoutUseMeasuredSizeForInitialScroll")

local fFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport
local fFlagLuaAppEdpDirectionalGradientMidTransparency = SharedFlags.FFlagLuaAppEdpDirectionalGradientMidTransparency

local v5 = {
	testId = "app-blox-details-page",
	fullBleedAspectRatio = 16 / 9,
	fullBleedOverlapOffset = 180,
	reserveHeaderBarSpace = true
}

local function DetailsPageLayoutRoot(p2, p3)
	local v6 = useDeviceInsets()
	local v7 = useTokens()

	local v8 = withDefaults(p2, v5)
	local compositionLayoutTag = v8.compositionLayoutTag or compositionTags.Layout.Detail

	local fullBleedAspectRatio = v8.fullBleedAspectRatio
	local v9 = (fullBleedAspectRatio == nil or not (fullBleedAspectRatio > 0)) and 16 / 9
		or fullBleedAspectRatio
	local v10 = not (v8.fullBleedContent == nil) and not v8.isFullscreen

	local v11, v12 = React.useBinding(false)
	local v13, v14 = React.useBinding(false)
	local v15, v16 = React.useBinding(0)

	local scale = v7.Config.UI.Scale
	local v17 = v8.fullBleedOverlapOffset * scale
	local v18 = if v8.gradientTopBleedOffset then v8.gradientTopBleedOffset * scale else v7.Size.Size_2000

	local v19 = v7.Size.Size_1000 + v7.Padding.Large + v7.Padding.Medium
	local v20 = Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small)

	if fFlagLuaAppMediaGalleryGamepadSupport then
		if v8.reserveHeaderBarSpace then
			if not v20 then
				v19 = v7.Size.Size_2000
			end
		else
			v19 = 0
		end
	elseif not v20 then
		v19 = v7.Size.Size_2000
	end

	local v21 = v19 + v6.top

	local state, setState = React.useState(nil)
	local v22 = state ~= nil
	local state2, setState2 = React.useState(nil)

	local state3, setState3 = React.useState(false)
	local v23 = not v10 or state3 or v22
	local v24 = useNavBarSize()
	local v25 = useNavBarPlacement()

	local v26 = React.useMemo(function()
		local viewportSize = Display.GetDisplayStore(false).getViewportSize(false)
		local v27

		if v25 == AppNavBar.Placement.Left then
			v27 = math.max(0, viewportSize.X - v24)
		else
			v27 = viewportSize.X
		end

		local vector2 = Vector2.new(v27, viewportSize.Y)

		return {
			containerSize = vector2,
			initialScrollY = not v10 and 0 or DetailsPageLayoutUtils.computeInitialScrollYForSize(vector2, {
				fullBleedAspectRatio = v9,
				headerBarHeight = v21,
				fullBleedOverlapOffset = v17,
				hasFullBleed = v10,
				bannerBottomVisiblePercent = p2.bannerBottomVisiblePercent
			})
		}
	end, {})
	local containerSize = v26.containerSize
	local initialScrollY = v26.initialScrollY

	local v27, v28 = React.useBinding(containerSize)
	local v29, v30 = React.useBinding(initialScrollY)
	local v31, v32 = React.useBinding(0)
	local state4, setState4 = React.useState(initialScrollY)
	local state5, setState5 = React.useState(true)

	local ref = React.useRef(v10 and not FFlagDetailsPageLayoutUseMeasuredSizeForInitialScroll)

	local mapped = v27:map(function(p4)
		return p4.Y
	end)

	local mapped2 = v27:map(function(p4)
		return UDim2.new(0, p4.X, 0, p4.X / v9)
	end)

	local mapped3 = v27:map(function(p4)
		if v10 then
			return DetailsPageLayoutUtils.computeContentTopOffset(p4.X, v9, v21)
		end

		return 0
	end)

	local mapped4 = React.joinBindings({ mapped3, v29 }):map(function(list)
		local item = list[1]
		local item2 = list[2]
		local v33 = math.max(0, item + v21 - item2) / 2
		return UDim2.new(0.5, 0, 0, v33)
	end)

	local mapped5 = React.joinBindings({ v29, mapped3, v31 }):map(function(list)
		local item = list[1]
		local item2 = list[2]
		local item3 = list[3]

		if item2 == 0 then
			return (math.clamp(item / DetailsPageLayoutUtils.getNoBannerFadeParams(v21), 0, 1))
		end

		local headerFadeParams, v33 = DetailsPageLayoutUtils.getHeaderFadeParams(item2, item3, v17)
		return (math.clamp((item - headerFadeParams) / v33, 0, 1))
	end)

	local v33 = React.useCallback(function(p4)
		local absoluteSize = p4.AbsoluteSize
		v28(absoluteSize)

		if absoluteSize.X > 0 and absoluteSize.Y > 0 then
			setState5(true)

			if v10 and not ref.current then
				ref.current = true
				local initialScrollYForSize = DetailsPageLayoutUtils.computeInitialScrollYForSize(absoluteSize, {
					fullBleedAspectRatio = v9,
					headerBarHeight = v21,
					fullBleedOverlapOffset = v17,
					hasFullBleed = v10,
					bannerBottomVisiblePercent = p2.bannerBottomVisiblePercent
				})

				setState4(initialScrollYForSize)
				v30(initialScrollYForSize)
			end
		end
	end, { v10, v9, v21, v17, p2.bannerBottomVisiblePercent, containerSize })

	local ref2 = React.useRef(0)
	local v34 = React.useCallback(function(current)
		if math.abs(current - ref2.current) > 0.5 then
			ref2.current = current
			v32(current)
		end
	end, {})

	local v35 = React.useCallback(function(p4)
		local y = p4.CanvasPosition.Y
		v30(y)

		if v10 then
			local value = mapped3:getValue()
			local value2 = v31:getValue()

			local headerFadeParams, v36 = DetailsPageLayoutUtils.getHeaderFadeParams(value, value2, v17)
			setState3(DetailsPageLayoutUtils.shouldShowStickyBar(y, value, headerFadeParams, v36))
		end
	end, { v10, v17 })

	local useMemo = React.useMemo
	local function fn()
		local v36 = {
			hasFullBleed = v10,
			hasHeader = v11,
			setHasHeader = v12,
			hasActions = v13,
			setHasActions = v14,
			isFullscreen = v8.isFullscreen,
			headerBarHeight = v21,
			actionBarHeight = v15,
			setActionBarHeight = v16,
			onCanvasPositionChanged = v35,
			contentTopOffset = mapped3,
			fullBleedOverlapOffset = v17,
			gradientTopBleedOffset = v18,
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

		local v37 = if fFlagLuaAppEdpDirectionalGradientMidTransparency then v8.gradientMidTransparency else nil
		v36.gradientMidTransparency = v37

		v36.initialScrollY = state4
		v36.hasValidContainerSize = state5

		local v38 = if fFlagLuaAppMediaGalleryGamepadSupport then v8.disableFocusNavEngineScroll else nil
		v36.disableFocusNavEngineScroll = v38

		v36.containerHeight = mapped
		v36.headerOpacity = mapped5
		v36.stickyHeaderActive = v23
		v36.onClose = v8.onClose
		v36.testId = v8.testId
		v36.onCanvasSizeChanged = v34
		v36.isFullscreenOverlay = v22
		v36.setFullscreenContent = setState
		v36.onExitFullscreenOverlay = state2
		v36.setOnExitFullscreenOverlay = setState2
		return v36
	end

	local isFullscreen = v8.isFullscreen

	local v37 = if fFlagLuaAppEdpDirectionalGradientMidTransparency then v8.gradientMidTransparency else nil
	local v36 = {
		v10,
		isFullscreen,
		v21,
		v17,
		v18,
		v37,
		state4,
		state5,
		v23,
		v8.onClose,
		v8.testId,
		mapped,
		mapped5,
		v35,
		v34,
		v22,
		nil,
		nil
	}

	local v38 = if fFlagLuaAppMediaGalleryGamepadSupport then v8.disableFocusNavEngineScroll else nil
	v36[17], v36[18] = state2, v38
	local v39 = useMemo(fn, v36)

	local createElement = React.createElement
	local provider = DetailsPageLayoutContext.Provider

	local createElement2 = React.createElement
	local v42 = {
		tag = `size-full clip bg-surface-0 {compositionLayoutTag}`,
		stateLayer = { affordance = stateLayerAffordance.None },
		onAbsoluteSizeChanged = v33,
		ref = p3,
		selectionGroup = v8.selectionGroup,
		testId = `{v8.testId}--root`
	}

	local v44 = if v10 then React.createElement(
		view,
		{
			tag = "position-top-center anchor-top-center size-full clip",
			ZIndex = 0,
			testId = `{v8.testId}--fullbleed`
		},
		{
			ParallaxFrame = React.createElement(
				view,
				{
					Position = mapped4,
					Size = mapped2,
					tag = "anchor-center-center clip"
				},
				v8.fullBleedContent
			)
		}
	) else nil
	local v43 = {
		FullBleed = v44,
		Children = React.createElement(React.Fragment, nil, v8.children),
		FullscreenOverlay = 0
	}
	local v45

	if v22 then
		v45 = React.createElement(view, {
			Size = v11:map(function(p4)
				if p4 then
					return (UDim2.new(1, 0, 1, -v21))
				end

				return (UDim2.fromScale(1, 1))
			end),
			Position = v11:map(function(p4)
				if p4 then
					return (UDim2.fromOffset(0, v21))
				end

				return (UDim2.fromOffset(0, 0))
			end),
			ZIndex = 10,
			tag = "clip",
			testId = `{v8.testId}--fullscreen-overlay`
		}, state)
	end

	v43.FullscreenOverlay = v45
	return createElement(provider, { value = v39 }, createElement2(view, v42, v43))
end

return React.memo(React.forwardRef(DetailsPageLayoutRoot))
