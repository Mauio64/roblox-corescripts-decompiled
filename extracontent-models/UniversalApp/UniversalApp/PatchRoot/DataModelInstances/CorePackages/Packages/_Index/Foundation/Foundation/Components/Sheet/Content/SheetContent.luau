local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local React = require(FoundationParent.React)
local ReactUtils = require(FoundationParent.ReactUtils)
local useTokens = require(Foundation.Providers.Style.useTokens)
local Constants = require(Foundation.Constants)
local Flags = require(Foundation.Utility.Flags)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local Sheet = script:FindFirstAncestor("Sheet")
local SheetContext = require(Sheet.SheetContext)
local SheetType = require(Sheet.SheetType)
local ScrollView = require(Foundation.Components.ScrollView)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local isScrollingFrameOverflowingY = require(Foundation.Utility.isScrollingFrameOverflowingY)
local useComposedRef = ReactUtils.useComposedRef

local function SheetContent(p1, p2) -- line: 30
	-- upvalues: useTokens (copy), React (copy), SheetContext (copy), Flags (copy), isScrollingFrameOverflowingY (copy), SheetType (copy), View (copy), StateLayerAffordance (copy), Dash (copy), useComposedRef (copy), ScrollView (copy), Constants (copy)
	local v20 = useTokens()
	local v21 = React.useContext(SheetContext)
	local innerScrollingEnabled = v21.innerScrollingEnabled
	local setInnerScrollY = v21.setInnerScrollY
	local innerScrollingRef = v21.innerScrollingRef
	local actionsHeight = v21.actionsHeight
	local sheetContentHeight = v21.sheetContentHeight
	local setHasActionsDivider = v21.setHasActionsDivider
	local bottomPadding = v21.bottomPadding
	local hasHeader = v21.hasHeader
	local v30 = not not Flags.FoundationSheetFullBleed and v21.hasFullBleed
	local v31 = if not Flags.FoundationSheetFullBleed then nil else v21.fullBleedHeight
	local sheetType = v21.sheetType
	local testId = v21.testId

	assert(innerScrollingEnabled and (setInnerScrollY and (actionsHeight and (setHasActionsDivider and (bottomPadding and (hasHeader and testId))))), "SheetContent must be used within a Sheet")

	local v34, v35 = React.useBinding(false)
	local v36 = React.useCallback(function(p3) -- line: 59
		-- upvalues: setInnerScrollY (copy), isScrollingFrameOverflowingY (copy), setHasActionsDivider (copy), v35 (copy)
		setInnerScrollY(p3.CanvasPosition.Y)

		local v48 = isScrollingFrameOverflowingY(p3, 1)

		setHasActionsDivider(v48)
		v35(v48)
	end, {
		setHasActionsDivider,
		setInnerScrollY
	})
	local v37, v38 = React.useBinding(0)
	local v39 = React.useCallback(function(p4) -- line: 69
		-- upvalues: v38 (copy)
		v38(p4.AbsoluteSize.Y)
	end, {})
	local v40 = sheetType == SheetType.Bottom
	local v41 = if not Flags.FoundationFullBleedSheetContent or not p1.isContentFullBleed then UDim.new(0, v20.Padding.Small) else nil
	local v42 = p1.Selectable == nil or p1.Selectable
	local v43 = if not v34 then nil else v34:map(function(b1: boolean) -- line: 81
		-- upvalues: v42 (copy)
		return v42 and b1
	end)
	local v44 = if not Flags.FoundationBottomSheetGestureInteractionSink then nil else v21.isVerticalSheetGesture
	local v45 = if not Flags.FoundationBottomSheetGestureInteractionSink then nil else React.createElement("Folder", nil, {
		ContentInteractionSink = if not v44 then nil else React.createElement(View, {
			Selectable = false,
			ZIndex = 2,
			Size = UDim2.fromScale(1, 1),
			testId = `{ testId }--content--interaction-sink`,
			stateLayer = {
				affordance = StateLayerAffordance.None
			},
			onActivated = Dash.noop
		})
	})
	local v46 = if not Flags.FoundationBottomSheetInnerScrollingSync then nil else useComposedRef(innerScrollingRef, p1.scrollingFrameRef)

	return React.createElement(ScrollView, {
		ZIndex = 1,
		tag = "fill size-full-0 auto-y",
		scrollingFrameRef = if not Flags.FoundationBottomSheetInnerScrollingSync then p1.scrollingFrameRef else v46,
		selection = {
			Selectable = v43,
			NextSelectionUp = p1.NextSelectionUp,
			NextSelectionDown = p1.NextSelectionDown,
			NextSelectionLeft = p1.NextSelectionLeft,
			NextSelectionRight = p1.NextSelectionRight
		},
		scroll = {
			ScrollingEnabled = innerScrollingEnabled,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = if not sheetContentHeight then UDim2.fromScale(1, 0) else v37:map(function(n1: number) -- line: 134
				return UDim2.new(1, 0, 0, n1)
			end),
			ScrollingDirection = Enum.ScrollingDirection.Y
		},
		Size = if not sheetContentHeight then nil else UDim2.fromScale(1, 1),
		padding = {
			top = hasHeader:map(function(b2: boolean) -- line: 142
				-- upvalues: v30 (copy), v40 (copy), v20 (copy)
				if b2 or v30 then
					return (UDim.new(0, 0))
				end

				return (UDim.new(0, if not v40 then v20.Margin.Small else v20.Padding.Small))
			end),
			bottom = if not v40 then UDim.new(0, v20.Padding.Small) else actionsHeight:map(function(n2: number) -- line: 148
				-- upvalues: bottomPadding (copy), v20 (copy)
				return UDim.new(0, n2 + bottomPadding + v20.Margin.Small)
			end),
			left = v41,
			right = v41
		},
		ClipsDescendants = not v40 or hasHeader,
		onCanvasPositionChanged = function(p5) -- line: 156
			-- upvalues: setInnerScrollY (copy)
			setInnerScrollY(p5.CanvasPosition.Y)
		end,
		onAbsoluteCanvasSizeChanged = v36,
		onAbsoluteWindowSizeChanged = v36,
		testId = `{ testId }--content`,
		ref = p2
	}, React.createElement(View, {
		onAbsoluteSizeChanged = v39,
		tag = not Flags.FoundationFullBleedSheetContent and "col align-x-center gap-medium size-full-0 auto-y padding-x-medium" or {
			["col align-x-center gap-medium size-full-0 auto-y"] = true,
			["padding-x-medium"] = not p1.isContentFullBleed
		}
	}, if not Flags.FoundationSheetFullBleed then if not Flags.FoundationBottomSheetGestureInteractionSink then p1.children else {
		Children = React.createElement(React.Fragment, nil, p1.children),
		ContentInteractionSinkContainer = v45
	} else {
		FullBleedSpacer = if not v30 or not v31 then nil else React.createElement(View, {
			Size = v31:map(function(n3: number) -- line: 180
				return UDim2.new(1, 0, 0, (math.max(0, n3)))
			end),
			LayoutOrder = Constants.MIN_LAYOUT_ORDER,
			testId = `{ testId }--content--full-bleed-spacer`
		}),
		Children = React.createElement(React.Fragment, nil, p1.children),
		ContentInteractionSinkContainer = if not Flags.FoundationBottomSheetGestureInteractionSink then nil else v45
	}))
end

return React.memo(React.forwardRef(SheetContent))
