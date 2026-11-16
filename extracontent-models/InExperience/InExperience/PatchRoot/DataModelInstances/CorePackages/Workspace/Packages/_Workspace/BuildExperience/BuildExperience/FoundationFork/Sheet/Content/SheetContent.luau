local CorePackages = game:GetService("CorePackages")
local foundation = CorePackages.Packages._Index.Foundation.Foundation
local parent = foundation.Parent
local React = require(parent.React)
local useTokens = require(foundation.Providers.Style.useTokens)

local Constants = require(foundation.Constants)

local Sheet = script:FindFirstAncestor("Sheet")
local SheetContext = require(Sheet.SheetContext)
local SheetType = require(Sheet.SheetType)

local ScrollView = require(foundation.Components.ScrollView)
require(foundation.Components.Types)
local View = require(foundation.Components.View)
local isScrollingFrameOverflowingY = require(foundation.Utility.isScrollingFrameOverflowingY)

local function SheetContent(props, ref)
	local v = useTokens()
	local v2 = React.useContext(SheetContext)

	local innerScrollingEnabled = v2.innerScrollingEnabled
	local setInnerScrollY = v2.setInnerScrollY
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

	local v3, v4 = React.useBinding(false)

	local v5 = React.useCallback(function(p)
		setInnerScrollY(p.CanvasPosition.Y)

		local scrollingFrameOverflowingY = isScrollingFrameOverflowingY(p, 1)

		setHasActionsDivider(scrollingFrameOverflowingY)
		v4(scrollingFrameOverflowingY)
	end, { setHasActionsDivider, setInnerScrollY })

	local v6, v7 = React.useBinding(0)
	local onAbsoluteSizeChanged = React.useCallback(function(p)
		v7(p.AbsoluteSize.Y)
	end, {})

	local v8 = sheetType == SheetType.Bottom

	local v9 = props.Selectable == nil or props.Selectable
	local selectable

	if v3 then
		selectable = v3:map(function(flag: boolean)
			return v9 and flag
		end)
	end

	local createElement = React.createElement

	local v10 = {
		scrollingFrameRef = props.scrollingFrameRef,
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
		padding = 0,
		ClipsDescendants = 0,
		onCanvasPositionChanged = 0,
		onAbsoluteCanvasSizeChanged = 0,
		onAbsoluteWindowSizeChanged = 0,
		testId = 0,
		tag = "fill size-full-0 auto-y",
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
		canvasSize = v6:map(function(p: number)
			return UDim2.new(1, 0, 0, p)
		end)
	else
		canvasSize = UDim2.fromScale(1, 0)
	end

	scroll.CanvasSize = canvasSize

	scroll.ScrollingDirection = Enum.ScrollingDirection.Y
	v10.scroll = scroll
	local size

	if sheetContentHeight then
		size = UDim2.fromScale(1, 1)
	end

	v10.Size = size
	local padding = {
		top = hasHeader:map(function(flag: boolean)
			if flag or hasFullBleed then
				return (UDim.new(0, 0))
			end

			local v11 = if v8 then v.Padding.Small else v.Margin.Small
			return (UDim.new(0, v11))
		end),
		bottom = 0,
		left = 0,
		right = 0
	}
	local bottom

	if v8 then
		bottom = actionsHeight:map(function(p: number)
			return UDim.new(0, p + bottomPadding + v.Margin.Small)
		end)
	else
		bottom = UDim.new(0, v.Padding.Small)
	end

	padding.bottom = bottom

	padding.left = UDim.new(0, v.Padding.Small)
	padding.right = UDim.new(0, v.Padding.Small)
	v10.padding = padding

	v10.ClipsDescendants = not v8 or hasHeader
	function v10.onCanvasPositionChanged(p)
		setInnerScrollY(p.CanvasPosition.Y)
	end
	v10.onAbsoluteCanvasSizeChanged = v5
	v10.onAbsoluteWindowSizeChanged = v5
	v10.testId = `{testId}--content`

	v10.ref = ref

	local createElement2 = React.createElement
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

	return createElement(
		ScrollView,
		v10,
		createElement2(
			View,
			{
				onAbsoluteSizeChanged = onAbsoluteSizeChanged,
				tag = "col align-x-center gap-medium size-full-0 auto-y padding-x-medium"
			},
			{
				FullBleedSpacer = fullBleedSpacer,
				Children = React.createElement(React.Fragment, nil, props.children)
			}
		)
	)
end

return React.memo(React.forwardRef(SheetContent))
