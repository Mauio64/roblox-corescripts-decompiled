local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation")
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/ReactUtils")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SharedFlags")
local fFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport
local fFlagLuaAppEdpDirectionalGradientMidTransparency = SharedFlags.FFlagLuaAppEdpDirectionalGradientMidTransparency

local scrollView = Foundation.ScrollView
local view = Foundation.View

local DetailsPageLayoutContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPageLayout/DetailsPageLayoutContext")
local DetailsPageLayoutUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPageLayout/DetailsPageLayoutUtils")

local FFlagDetailsPageLayoutUseMeasuredSizeForInitialScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/Flags/FFlagDetailsPageLayoutUseMeasuredSizeForInitialScroll")

local v5 = { Selectable = false }
local binding = React.createBinding(0)

local function DetailsPageLayoutContent(p2, p3)
	local v6 = React.useContext(DetailsPageLayoutContext)

	local contentTopOffset = v6.contentTopOffset
	local hasFullBleed = v6.hasFullBleed
	local isFullscreen = v6.isFullscreen
	local isFullscreenOverlay = v6.isFullscreenOverlay
	local headerBarHeight = v6.headerBarHeight
	local hasHeader = v6.hasHeader
	local onCanvasPositionChanged = v6.onCanvasPositionChanged
	local fullBleedOverlapOffset = v6.fullBleedOverlapOffset
	local initialScrollY = v6.initialScrollY
	local hasValidContainerSize = v6.hasValidContainerSize
	local containerHeight = v6.containerHeight
	local onCanvasSizeChanged = v6.onCanvasSizeChanged
	local hasActions = v6.hasActions
	local actionBarHeight = v6.actionBarHeight
	local testId = v6.testId
	local gradientTopBleedOffset = v6.gradientTopBleedOffset
	local gradientMidTransparency = v6.gradientMidTransparency
	assert(testId, "DetailsPageLayout.Content must be used within DetailsPageLayout.Root")

	local function fn(p4)
		if p4 and (FFlagDetailsPageLayoutUseMeasuredSizeForInitialScroll and hasFullBleed or initialScrollY > 0) then
			p4.CanvasPosition = Vector2.new(0, initialScrollY)
		end
	end

	local v9 = React.useCallback(fn, { initialScrollY, if FFlagDetailsPageLayoutUseMeasuredSizeForInitialScroll then hasFullBleed else nil })

	local v10 = ReactUtils.useComposedRef(p2.scrollingFrameRef, v9)

	local v11, v12 = React.useBinding(initialScrollY)
	local v13, v14 = React.useBinding(0)

	local v15 = React.useCallback(function(p4)
		v12(p4.CanvasPosition.Y)

		if onCanvasPositionChanged then
			onCanvasPositionChanged(p4)
		end
	end, { onCanvasPositionChanged })

	local v16 = React.useMemo(function()
		if hasHeader and hasActions and actionBarHeight then
			return React.joinBindings({ hasHeader, hasActions, actionBarHeight }):map(function(list)
				local item = list[1]
				local item2 = list[2]
				local item3 = list[3]

				return UDim2.new(
					1,
					0,
					1,
					-((not item and 0 or headerBarHeight) + (not item2 and 0 or item3))
				)
			end)
		end

		return nil
	end, { hasHeader, hasActions, actionBarHeight, headerBarHeight })

	local v17 = React.useMemo(function()
		if hasHeader then
			return hasHeader:map(function(p4)
				return UDim2.new(0, 0, 0, not p4 and 0 or headerBarHeight)
			end)
		end

		return nil
	end, { hasHeader, headerBarHeight })

	local v18 = React.useMemo(function()
		if contentTopOffset then
			return React.joinBindings({ contentTopOffset, containerHeight or binding }):map(function(list)
				local item = list[1]
				local item2 = list[2]
				local canvasPaddingTop = DetailsPageLayoutUtils.computeCanvasPaddingTop(
					item,
					hasFullBleed,
					fullBleedOverlapOffset,
					headerBarHeight
				)

				if item2 > 0 then
					canvasPaddingTop = math.min(canvasPaddingTop, item2 * 0.75)
				end

				return UDim.new(0, canvasPaddingTop)
			end)
		end

		return nil
	end, {
		contentTopOffset,
		containerHeight,
		hasFullBleed,
		fullBleedOverlapOffset,
		headerBarHeight
	})

	local v19 = React.useMemo(function()
		if hasActions and actionBarHeight then
			return React.joinBindings({ hasActions, actionBarHeight }):map(function(list)
				local item = list[1]
				local item2 = list[2]

				if item then
					return (UDim.new(0, item2))
				end

				return (UDim.new(0, 0))
			end)
		end

		return nil
	end, { hasActions, actionBarHeight })

	local v20 = React.useMemo(function()
		if v18 then
			return React.joinBindings({ v18, v11 }):map(function(list)
				local item = list[1]
				local item2 = list[2]
				return UDim2.new(0, 0, 0, item.Offset - item2 - gradientTopBleedOffset)
			end)
		end

		return nil
	end, { v18, v11, gradientTopBleedOffset })

	local v21 = React.useMemo(function()
		if containerHeight then
			return React.joinBindings({ v13, containerHeight }):map(function(list)
				local v22 = list[1]
				local item = list[2]

				if not (v22 > 0) then
					v22 = math.max(item, 1)
				end

				return UDim2.new(1, 0, 0, v22 + gradientTopBleedOffset)
			end)
		end

		return nil
	end, { v13, containerHeight, gradientTopBleedOffset })

	if isFullscreen then
		assert(v16 and v17, "bindings required in fullscreen mode")

		return React.createElement(view, {
			Size = v16,
			Position = v17,
			ZIndex = 1,
			tag = "col bg-surface-0",
			testId = `{testId}--content`,
			ref = p3
		}, {
			Children = React.createElement(React.Fragment, nil, p2.children)
		})
	end

	assert(
		v18 and onCanvasPositionChanged and containerHeight and hasActions and actionBarHeight,
		"DetailsPageLayout.Content requires bindings in scroll mode"
	)

	if hasFullBleed and not hasValidContainerSize then
		return React.createElement(view, {
			tag = "size-full clip bg-surface-0",
			ZIndex = 1,
			testId = `{testId}--content`,
			ref = p3
		})
	end

	local createElement = React.createElement
	local v25

	if hasFullBleed and contentTopOffset then
		v25 = React.createElement(view, {
			Size = contentTopOffset:map(function(p4)
				return UDim2.new(1, 0, 0, math.min(p4, fullBleedOverlapOffset) + gradientTopBleedOffset)
			end),
			tag = "bg-surface-0",
			LayoutOrder = 0
		}, {
			Gradient = React.createElement("UIGradient", {
				Rotation = 270,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(
						0.5,
						fFlagLuaAppEdpDirectionalGradientMidTransparency and gradientMidTransparency or 0.25
					),
					NumberSequenceKeypoint.new(1, 1)
				})
			})
		})
	end

	local element = createElement(view, {
		Position = v20,
		Size = v21,
		tag = "col",
		ZIndex = 0
	}, {
		GradientBar = v25,
		SolidFill = React.createElement(view, {
			tag = "fill size-full-0 bg-surface-0",
			LayoutOrder = 1
		})
	})

	local createElement2 = React.createElement
	local v27 = {
		tag = "size-full clip",
		ZIndex = 1,
		ref = p3,
		testId = `{testId}--content`
	}

	local createElement3 = React.createElement

	local v30 = {
		scrollingFrameRef = v10,
		selection = v5,
		scroll = 0,
		onAbsoluteCanvasSizeChanged = 0,
		onCanvasPositionChanged = 0,
		tag = "size-full clip",
		ZIndex = 1
	}

	local v31 = {
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(1, 0, 0, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollingEnabled = 0
	}
	local v32

	if fFlagLuaAppMediaGalleryGamepadSupport then
		v32 = not isFullscreenOverlay

		if v32 then
			local disableFocusNavEngineScroll = v6.disableFocusNavEngineScroll == true
			v32 = not disableFocusNavEngineScroll
		end
	else
		v32 = not isFullscreenOverlay
	end

	v31.ScrollingEnabled = v32
	v30.scroll = v31

	function v30.onAbsoluteCanvasSizeChanged(p4)
		v14(p4.AbsoluteCanvasSize.Y)

		if onCanvasSizeChanged then
			onCanvasSizeChanged(p4.AbsoluteCanvasSize.Y - p4.AbsoluteSize.Y)
		end
	end
	v30.onCanvasPositionChanged = v15
	return createElement2(view, v27, {
		BackgroundLayers = element,
		ScrollContent = createElement3(
			scrollView,
			v30,
			React.createElement(view, { tag = "col size-full-0 auto-y" }, {
				CanvasPadding = React.createElement("UIPadding", {
					PaddingTop = v18,
					PaddingBottom = v19
				}),
				ContentSection = React.createElement(view, {
					Size = containerHeight:map(function(p4)
						return UDim2.new(1, 0, 0, p4)
					end),
					tag = "auto-y",
					LayoutOrder = 1
				}, {
					ContentBackground = React.createElement(
						view,
						{ tag = "col align-x-center size-full-0 auto-y" },
						{
							Children = React.createElement(React.Fragment, nil, p2.children)
						}
					)
				})
			})
		)
	})
end

return React.memo(React.forwardRef(DetailsPageLayoutContent))
