local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ReactUtils = require(FoundationParent.ReactUtils)
local useTokens = require(Foundation.Providers.Style.useTokens)
local Constants = require(Foundation.Constants)
local Flags = require(Foundation.Utility.Flags)
local Sheet = script:FindFirstAncestor("Sheet")
local SheetContext = require(Sheet.SheetContext)
local SheetType = require(Sheet.SheetType)
local ScrollView = require(Foundation.Components.ScrollView)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local isScrollingFrameOverflowingY = require(Foundation.Utility.isScrollingFrameOverflowingY)
local useComposedRef = ReactUtils.useComposedRef

local function SheetContent(p1, p2) -- line: 28
	-- upvalues: useTokens (copy), React (copy), SheetContext (copy), Flags (copy), isScrollingFrameOverflowingY (copy), SheetType (copy), useComposedRef (copy), ScrollView (copy), View (copy), Constants (copy)
	local v18 = useTokens()
	local v19 = React.useContext(SheetContext)
	local innerScrollingEnabled = v19.innerScrollingEnabled
	local setInnerScrollY = v19.setInnerScrollY
	local innerScrollingRef = v19.innerScrollingRef
	local actionsHeight = v19.actionsHeight
	local sheetContentHeight = v19.sheetContentHeight
	local setHasActionsDivider = v19.setHasActionsDivider
	local bottomPadding = v19.bottomPadding
	local hasHeader = v19.hasHeader
	local v28 = not not Flags.FoundationSheetFullBleed and v19.hasFullBleed
	local v29 = if not Flags.FoundationSheetFullBleed then nil else v19.fullBleedHeight
	local sheetType = v19.sheetType
	local testId = v19.testId

	assert(innerScrollingEnabled and (setInnerScrollY and (actionsHeight and (setHasActionsDivider and (bottomPadding and (hasHeader and testId))))), "SheetContent must be used within a Sheet")

	local v32, v33 = React.useBinding(false)
	local v34 = React.useCallback(function(p3) -- line: 57
		-- upvalues: setInnerScrollY (copy), isScrollingFrameOverflowingY (copy), setHasActionsDivider (copy), v33 (copy)
		setInnerScrollY(p3.CanvasPosition.Y)

		local v44 = isScrollingFrameOverflowingY(p3, 1)

		setHasActionsDivider(v44)
		v33(v44)
	end, {
		setHasActionsDivider,
		setInnerScrollY
	})
	local v35, v36 = React.useBinding(0)
	local v37 = React.useCallback(function(p4) -- line: 67
		-- upvalues: v36 (copy)
		v36(p4.AbsoluteSize.Y)
	end, {})
	local v38 = sheetType == SheetType.Bottom
	local v39 = if not Flags.FoundationFullBleedSheetContent or not p1.isContentFullBleed then UDim.new(0, v18.Padding.Small) else nil
	local v40 = p1.Selectable == nil or p1.Selectable
	local v41 = if not v32 then nil else v32:map(function(b1: boolean) -- line: 79
		-- upvalues: v40 (copy)
		return v40 and b1
	end)
	local v42 = if not Flags.FoundationBottomSheetInnerScrollingSync then nil else useComposedRef(innerScrollingRef, p1.scrollingFrameRef)

	return React.createElement(ScrollView, {
		ZIndex = 1,
		tag = "fill size-full-0 auto-y",
		scrollingFrameRef = if not Flags.FoundationBottomSheetInnerScrollingSync then p1.scrollingFrameRef else v42,
		selection = {
			Selectable = v41,
			NextSelectionUp = p1.NextSelectionUp,
			NextSelectionDown = p1.NextSelectionDown,
			NextSelectionLeft = p1.NextSelectionLeft,
			NextSelectionRight = p1.NextSelectionRight
		},
		scroll = {
			ScrollingEnabled = innerScrollingEnabled,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = if not sheetContentHeight then UDim2.fromScale(1, 0) else v35:map(function(n1: number) -- line: 109
				return UDim2.new(1, 0, 0, n1)
			end),
			ScrollingDirection = Enum.ScrollingDirection.Y
		},
		Size = if not sheetContentHeight then nil else UDim2.fromScale(1, 1),
		padding = {
			top = hasHeader:map(function(b2: boolean) -- line: 117
				-- upvalues: v28 (copy), v38 (copy), v18 (copy)
				if b2 or v28 then
					return (UDim.new(0, 0))
				end

				return (UDim.new(0, if not v38 then v18.Margin.Small else v18.Padding.Small))
			end),
			bottom = if not v38 then UDim.new(0, v18.Padding.Small) else actionsHeight:map(function(n2: number) -- line: 123
				-- upvalues: bottomPadding (copy), v18 (copy)
				return UDim.new(0, n2 + bottomPadding + v18.Margin.Small)
			end),
			left = v39,
			right = v39
		},
		ClipsDescendants = not v38 or hasHeader,
		onCanvasPositionChanged = function(p5) -- line: 131
			-- upvalues: setInnerScrollY (copy)
			setInnerScrollY(p5.CanvasPosition.Y)
		end,
		onAbsoluteCanvasSizeChanged = v34,
		onAbsoluteWindowSizeChanged = v34,
		testId = `{ testId }--content`,
		ref = p2
	}, React.createElement(View, {
		onAbsoluteSizeChanged = v37,
		tag = not Flags.FoundationFullBleedSheetContent and "col align-x-center gap-medium size-full-0 auto-y padding-x-medium" or {
			["col align-x-center gap-medium size-full-0 auto-y"] = true,
			["padding-x-medium"] = not p1.isContentFullBleed
		}
	}, if not Flags.FoundationSheetFullBleed then p1.children else {
		FullBleedSpacer = if not v28 or not v29 then nil else React.createElement(View, {
			Size = v29:map(function(n3: number) -- line: 155
				return UDim2.new(1, 0, 0, (math.max(0, n3)))
			end),
			LayoutOrder = Constants.MIN_LAYOUT_ORDER,
			testId = `{ testId }--content--full-bleed-spacer`
		}),
		Children = React.createElement(React.Fragment, nil, p1.children)
	}))
end

return React.memo(React.forwardRef(SheetContent))
