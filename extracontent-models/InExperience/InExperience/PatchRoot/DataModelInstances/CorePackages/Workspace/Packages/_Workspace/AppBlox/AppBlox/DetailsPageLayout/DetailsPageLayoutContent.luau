local AppBlox = script:FindFirstAncestor("AppBlox")
local parent = AppBlox.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local ReactUtils = require(parent.ReactUtils)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport
local FFlagLuaAppEdpDirectionalGradientMidTransparency = SharedFlags.FFlagLuaAppEdpDirectionalGradientMidTransparency

local ScrollView = Foundation.ScrollView
local View = Foundation.View

local DetailsPageLayoutContext = require(script.Parent.DetailsPageLayoutContext)
local DetailsPageLayoutUtils = require(script.Parent.DetailsPageLayoutUtils)

local FFlagDetailsPageLayoutUseMeasuredSizeForInitialScroll = require(AppBlox.Flags.FFlagDetailsPageLayoutUseMeasuredSizeForInitialScroll)

local selection = { Selectable = false }
local binding = React.createBinding(0)

local function DetailsPageLayoutContent(p, ref)
	local v = React.useContext(DetailsPageLayoutContext)

	local contentTopOffset = v.contentTopOffset
	local hasFullBleed = v.hasFullBleed
	local isFullscreen = v.isFullscreen
	local isFullscreenOverlay = v.isFullscreenOverlay
	local headerBarHeight = v.headerBarHeight
	local hasHeader = v.hasHeader
	local onCanvasPositionChanged = v.onCanvasPositionChanged
	local fullBleedOverlapOffset = v.fullBleedOverlapOffset
	local initialScrollY = v.initialScrollY
	local hasValidContainerSize = v.hasValidContainerSize
	local containerHeight = v.containerHeight
	local onCanvasSizeChanged = v.onCanvasSizeChanged
	local hasActions = v.hasActions
	local actionBarHeight = v.actionBarHeight
	local testId = v.testId
	local gradientTopBleedOffset = v.gradientTopBleedOffset
	local gradientMidTransparency = v.gradientMidTransparency
	assert(testId, "DetailsPageLayout.Content must be used within DetailsPageLayout.Root")

	local useCallback = React.useCallback
	local function fn(p2)
		if p2 and (FFlagDetailsPageLayoutUseMeasuredSizeForInitialScroll and hasFullBleed or initialScrollY > 0) then
			p2.CanvasPosition = Vector2.new(0, initialScrollY)
		end
	end

	local v2

	if FFlagDetailsPageLayoutUseMeasuredSizeForInitialScroll then
		v2 = hasFullBleed
	end

	local v3 = useCallback(fn, { initialScrollY, v2 })

	local scrollingFrameRef = ReactUtils.useComposedRef(p.scrollingFrameRef, v3)

	local v4, v5 = React.useBinding(initialScrollY)
	local v6, v7 = React.useBinding(0)

	local onCanvasPositionChanged2 = React.useCallback(function(p2)
		v5(p2.CanvasPosition.Y)

		if onCanvasPositionChanged then
			onCanvasPositionChanged(p2)
		end
	end, { onCanvasPositionChanged })

	local size = React.useMemo(function()
		if hasHeader and hasActions and actionBarHeight then
			return React.joinBindings({ hasHeader, hasActions, actionBarHeight }):map(function(list)
				local item = list[1]
				local item2 = list[2]
				local item3 = list[3]

				return UDim2.new(1, 0, 1, -((not item and 0 or headerBarHeight) + (not item2 and 0 or item3)))
			end)
		end

		return nil
	end, { hasHeader, hasActions, actionBarHeight, headerBarHeight })

	local position = React.useMemo(function()
		if hasHeader then
			return hasHeader:map(function(flag: boolean)
				return UDim2.new(0, 0, 0, not flag and 0 or headerBarHeight)
			end)
		end

		return nil
	end, { hasHeader, headerBarHeight })

	local paddingTop = React.useMemo(function()
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

	local paddingBottom = React.useMemo(function()
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

	local position2 = React.useMemo(function()
		if paddingTop then
			return React.joinBindings({ paddingTop, v4 }):map(function(list)
				local item = list[1]
				local item2 = list[2]
				return UDim2.new(0, 0, 0, item.Offset - item2 - gradientTopBleedOffset)
			end)
		end

		return nil
	end, { paddingTop, v4, gradientTopBleedOffset })

	local size2 = React.useMemo(function()
		if containerHeight then
			return React.joinBindings({ v6, containerHeight }):map(function(list)
				local v8 = list[1]
				local item = list[2]

				if not (v8 > 0) then
					v8 = math.max(item, 1)
				end

				return UDim2.new(1, 0, 0, v8 + gradientTopBleedOffset)
			end)
		end

		return nil
	end, { v6, containerHeight, gradientTopBleedOffset })

	if isFullscreen then
		assert(size and position, "bindings required in fullscreen mode")

		return React.createElement(View, {
			Size = size,
			Position = position,
			ZIndex = 1,
			tag = "col bg-surface-0",
			testId = `{testId}--content`,
			ref = ref
		}, {
			Children = React.createElement(React.Fragment, nil, p.children)
		})
	end

	assert(
		paddingTop and onCanvasPositionChanged and containerHeight and hasActions and actionBarHeight,
		"DetailsPageLayout.Content requires bindings in scroll mode"
	)

	if hasFullBleed and not hasValidContainerSize then
		return React.createElement(View, {
			tag = "size-full clip bg-surface-0",
			ZIndex = 1,
			testId = `{testId}--content`,
			ref = ref
		})
	end

	local createElement = React.createElement
	local gradientBar

	if hasFullBleed and contentTopOffset then
		gradientBar = React.createElement(View, {
			Size = contentTopOffset:map(function(p2: number)
				return UDim2.new(1, 0, 0, math.min(p2, fullBleedOverlapOffset) + gradientTopBleedOffset)
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
						FFlagLuaAppEdpDirectionalGradientMidTransparency and gradientMidTransparency or 0.25
					),
					NumberSequenceKeypoint.new(1, 1)
				})
			})
		})
	end

	local element = createElement(View, {
		Position = position2,
		Size = size2,
		tag = "col",
		ZIndex = 0
	}, {
		GradientBar = gradientBar,
		SolidFill = React.createElement(View, {
			tag = "fill size-full-0 bg-surface-0",
			LayoutOrder = 1
		})
	})

	local createElement2 = React.createElement
	local v8 = { tag = "size-full clip", ZIndex = 1, ref = ref, testId = `{testId}--content` }

	local createElement3 = React.createElement

	local v9 = {
		scrollingFrameRef = scrollingFrameRef,
		selection = selection,
		scroll = 0,
		onAbsoluteCanvasSizeChanged = 0,
		onCanvasPositionChanged = 0,
		tag = "size-full clip",
		ZIndex = 1
	}

	local scroll = {
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(1, 0, 0, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollingEnabled = 0
	}
	local scrollingEnabled

	if FFlagLuaAppMediaGalleryGamepadSupport then
		scrollingEnabled = not isFullscreenOverlay

		if scrollingEnabled then
			local disableFocusNavEngineScroll = v.disableFocusNavEngineScroll == true
			scrollingEnabled = not disableFocusNavEngineScroll
		end
	else
		scrollingEnabled = not isFullscreenOverlay
	end

	scroll.ScrollingEnabled = scrollingEnabled
	v9.scroll = scroll

	function v9.onAbsoluteCanvasSizeChanged(p2)
		v7(p2.AbsoluteCanvasSize.Y)

		if onCanvasSizeChanged then
			onCanvasSizeChanged(p2.AbsoluteCanvasSize.Y - p2.AbsoluteSize.Y)
		end
	end
	v9.onCanvasPositionChanged = onCanvasPositionChanged2
	return createElement2(View, v8, {
		BackgroundLayers = element,
		ScrollContent = createElement3(ScrollView, v9, React.createElement(View, {
			tag = "col size-full-0 auto-y"
		}, {
			CanvasPadding = React.createElement("UIPadding", {
				PaddingTop = paddingTop,
				PaddingBottom = paddingBottom
			}),
			ContentSection = React.createElement(View, {
				Size = containerHeight:map(function(p2: number)
					return UDim2.new(1, 0, 0, p2)
				end),
				tag = "auto-y",
				LayoutOrder = 1
			}, {
				ContentBackground = React.createElement(View, {
					tag = "col align-x-center size-full-0 auto-y"
				}, {
					Children = React.createElement(React.Fragment, nil, p.children)
				})
			})
		}))
	})
end

return React.memo(React.forwardRef(DetailsPageLayoutContent))
