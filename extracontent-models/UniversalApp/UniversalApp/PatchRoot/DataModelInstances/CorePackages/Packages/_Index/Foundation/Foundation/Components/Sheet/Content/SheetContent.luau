local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local Dash = require(parent.Dash)
local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local useTokens = require(Foundation.Providers.Style.useTokens)

local Constants = require(Foundation.Constants)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)

local Sheet = script:FindFirstAncestor("Sheet")
local SheetContext = require(Sheet.SheetContext)
local SheetType = require(Sheet.SheetType)

local Flags = require(Foundation.Utility.Flags)
local ScrollView = require(Foundation.Components.ScrollView)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local devAssert = require(Foundation.Utility.devAssert)
local isScrollingFrameOverflowingY = require(Foundation.Utility.isScrollingFrameOverflowingY)

local useComposedRef = ReactUtils.useComposedRef

local function getMaxCanvasPositionY(p) -- 3 equivalent calls inferred from this helper
	return (math.max(0, p.AbsoluteCanvasSize.Y - p.AbsoluteWindowSize.Y))
end

local function SheetContent(props, ref)
	local v = useTokens()
	local v2 = React.useContext(SheetContext)

	local innerScrollingEnabled = v2.innerScrollingEnabled
	local setInnerScrollY = v2.setInnerScrollY
	local innerScrollingRef = v2.innerScrollingRef
	local actionsHeight = v2.actionsHeight
	local sheetContentHeight = v2.sheetContentHeight
	local setHasActionsDivider = v2.setHasActionsDivider
	local bottomPadding = v2.bottomPadding
	local hasHeader = v2.hasHeader
	local hasFullBleed = v2.hasFullBleed
	local fullBleedHeight = v2.fullBleedHeight
	local sheetType = v2.sheetType
	local testId = v2.testId
	assert(
		innerScrollingEnabled and setInnerScrollY and actionsHeight and setHasActionsDivider and bottomPadding and hasHeader and testId,
		"SheetContent must be used within a Sheet"
	)
	local alignybottom

	if Flags.FoundationSheetReversedContent then
		alignybottom = props.isReversed == true
	else
		alignybottom = false
	end

	local contentRevealOffset

	if alignybottom then
		contentRevealOffset = v2.contentRevealOffset
	end

	if Flags.FoundationSheetReversedContent then
		devAssert(
			not (alignybottom and hasFullBleed),
			"Sheet.Content with isReversed=true is unsupported when used with Sheet.FullBleed"
		)
	end

	if Flags.FoundationSheetReversedContent then
		local setIsContentReversed = v2.setIsContentReversed
		React.useLayoutEffect(function()
			if alignybottom and setIsContentReversed then
				setIsContentReversed(true)
				return function()
					setIsContentReversed(false)
				end
			end

			return nil
		end, { alignybottom, setIsContentReversed })
	end

	local v3, v4 = React.useBinding(false)
	local ref2

	if Flags.FoundationSheetReversedContent then
		ref2 = React.useRef(true)
	else
		ref2 = nil
	end

	local windowSizeY, v5

	if Flags.FoundationSheetReversedContent then
		windowSizeY, v5 = React.useBinding(0)
	else
		v5 = nil
	end

	local v6 = React.useCallback(function(state)
		if alignybottom and ref2.current then
			state.CanvasPosition = Vector2.new(0, getMaxCanvasPositionY(state)) -- inferred equivalent call
		end

		setInnerScrollY(state.CanvasPosition.Y)

		local scrollingFrameOverflowingY = isScrollingFrameOverflowingY(state, 1)

		if alignybottom then
			v5(state.AbsoluteWindowSize.Y)
			setHasActionsDivider(getMaxCanvasPositionY(state) - state.CanvasPosition.Y > 1) -- inferred equivalent call
		else
			setHasActionsDivider(scrollingFrameOverflowingY)
		end

		v4(scrollingFrameOverflowingY)
	end, { alignybottom, setHasActionsDivider, setInnerScrollY })

	local v7, v8 = React.useBinding(0)
	local onAbsoluteSizeChanged = React.useCallback(function(p)
		v8(p.AbsoluteSize.Y)
	end, {})
	local position

	if contentRevealOffset then
		position = contentRevealOffset:map(function(p: number)
			return UDim2.fromOffset(0, p)
		end)
	end

	local size

	if contentRevealOffset then
		size = React.joinBindings({ windowSizeY = windowSizeY, revealOffset = contentRevealOffset }):map(function(p)
			return UDim2.new(1, 0, 0, (math.max(0, p.windowSizeY - p.revealOffset)))
		end)
	elseif alignybottom then
		size = windowSizeY:map(function(p: number)
			return UDim2.new(1, 0, 0, p)
		end)
	end

	local v9 = sheetType == SheetType.Bottom
	local udim

	if not props.isContentFullBleed then
		udim = UDim.new(0, v.Padding.Small)
	end

	local v10

	if sheetType == SheetType.Side then
		v10 = not props.isContentFullBleed
	else
		v10 = false
	end

	local v11 = props.Selectable == nil or props.Selectable
	local selectable

	if v3 then
		selectable = v3:map(function(flag: boolean)
			return v11 and flag
		end)
	end

	local isVerticalSheetGesture = v2.isVerticalSheetGesture

	local createElement = React.createElement
	local contentInteractionSink

	if isVerticalSheetGesture then
		contentInteractionSink = React.createElement(View, {
			Size = UDim2.fromScale(1, 1),
			Selectable = false,
			ZIndex = 2,
			testId = `{testId}--content--interaction-sink`,
			stateLayer = { affordance = StateLayerAffordance.None },
			onActivated = Dash.noop
		})
	end

	local element = createElement("Folder", nil, { ContentInteractionSink = contentInteractionSink })

	local scrollingFrameRef = useComposedRef(innerScrollingRef, props.scrollingFrameRef)

	local createElement2 = React.createElement
	local v12 = {
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		Position = position,
		Size = size,
		padding = Flags.FoundationSideSheetInternalDrawer and v10 and {
			left = UDim.new(0, v.Padding.Medium),
			right = UDim.new(0, v.Padding.Medium + v.Padding.Small)
		} or nil,
		tag = 0
	}
	local paddingxmedium

	if Flags.FoundationSideSheetInternalDrawer then
		paddingxmedium = not (props.isContentFullBleed or v10)
	else
		paddingxmedium = not props.isContentFullBleed
	end

	v12.tag = {
		["col align-x-center gap-medium size-full-0 auto-y"] = true,
		["padding-x-medium"] = paddingxmedium,
		["align-y-bottom"] = alignybottom
	}
	local fullBleedSpacer

	if hasFullBleed and fullBleedHeight then
		fullBleedSpacer = React.createElement(View, {
			Size = fullBleedHeight:map(function(p: number)
				return UDim2.new(1, 0, 0, (math.max(0, p)))
			end),
			LayoutOrder = Constants.MIN_LAYOUT_ORDER,
			testId = `{testId}--content--full-bleed-spacer`
		})
	end

	local element2 = createElement2(View, v12, {
		FullBleedSpacer = fullBleedSpacer,
		Children = React.createElement(React.Fragment, nil, props.children),
		ContentInteractionSinkContainer = element
	})

	local createElement3 = React.createElement
	local v13 = {
		scrollingFrameRef = scrollingFrameRef,
		ZIndex = 1,
		selection = {
			Selectable = selectable,
			NextSelectionUp = props.NextSelectionUp,
			NextSelectionDown = props.NextSelectionDown,
			NextSelectionLeft = props.NextSelectionLeft,
			NextSelectionRight = props.NextSelectionRight
		},
		scroll = 0,
		Size = 0,
		Position = 0,
		padding = 0,
		ClipsDescendants = 0,
		onCanvasPositionChanged = 0,
		onAbsoluteCanvasSizeChanged = 0,
		onAbsoluteWindowSizeChanged = 0,
		testId = 0,
		tag = 0,
		ref = 0
	}

	local scroll = {
		ScrollingEnabled = innerScrollingEnabled,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = 0,
		ScrollingDirection = 0
	}
	local canvasSize

	if sheetContentHeight then
		canvasSize = v7:map(function(p: number)
			return UDim2.new(1, 0, 0, p)
		end)
	else
		canvasSize = UDim2.fromScale(1, 0)
	end

	scroll.CanvasSize = canvasSize

	scroll.ScrollingDirection = Enum.ScrollingDirection.Y
	v13.scroll = scroll
	local size2

	if sheetContentHeight then
		size2 = UDim2.fromScale(1, 1)
	end

	v13.Size = size2
	local position2

	if contentRevealOffset then
		position2 = contentRevealOffset:map(function(p: number)
			return UDim2.fromOffset(0, -p)
		end)
	end

	v13.Position = position2

	local padding = {
		top = hasHeader:map(function(flag: boolean)
			if flag or hasFullBleed then
				return (UDim.new(0, 0))
			end

			local v14 = if v9 then v.Padding.Small else v.Margin.Small
			return (UDim.new(0, v14))
		end),
		bottom = 0,
		left = 0,
		right = 0
	}
	local bottom

	if v9 then
		bottom = actionsHeight:map(function(p: number)
			return UDim.new(0, p + bottomPadding + v.Margin.Small)
		end)
	else
		bottom = UDim.new(0, v.Padding.Small)
	end

	padding.bottom = bottom

	padding.left = udim

	if Flags.FoundationSideSheetInternalDrawer and v10 then
		udim = nil
	end

	padding.right = udim
	v13.padding = padding

	v13.ClipsDescendants = not v9 or hasHeader
	function v13.onCanvasPositionChanged(p)
		if alignybottom then
			ref2.current = getMaxCanvasPositionY(p) - p.CanvasPosition.Y <= 1 -- inferred equivalent call
			setHasActionsDivider(not ref2.current)
		end

		setInnerScrollY(p.CanvasPosition.Y)
	end
	v13.onAbsoluteCanvasSizeChanged = v6
	v13.onAbsoluteWindowSizeChanged = v6
	v13.testId = `{testId}--content`
	v13.tag = contentRevealOffset and "size-full" or "fill size-full-0 auto-y"
	v13.ref = ref
	local element3 = createElement3(ScrollView, v13, element2)

	if contentRevealOffset then
		return React.createElement(
			View,
			{
				ClipsDescendants = true,
				ZIndex = 1,
				tag = "fill size-full-0",
				testId = `{testId}--content--viewport`
			},
			{ ScrollView = element3 }
		)
	end

	return element3
end

return React.memo(React.forwardRef(SheetContent))
