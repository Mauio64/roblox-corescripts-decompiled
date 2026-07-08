local Foundation = game:GetService("CorePackages").Packages._Index.Foundation.Foundation
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
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

local function SheetContent(p1, p2) -- line: 23
	-- upvalues: useTokens (copy), React (copy), SheetContext (copy), Flags (copy), isScrollingFrameOverflowingY (copy), SheetType (copy), ScrollView (copy), View (copy), Constants (copy)
	local v16 = useTokens()
	local v17 = React.useContext(SheetContext)
	local innerScrollingEnabled = v17.innerScrollingEnabled
	local setInnerScrollY = v17.setInnerScrollY
	local actionsHeight = v17.actionsHeight
	local sheetContentHeight = v17.sheetContentHeight
	local setHasActionsDivider = v17.setHasActionsDivider
	local bottomPadding = v17.bottomPadding
	local hasHeader = v17.hasHeader
	local v25 = not not Flags.FoundationSheetFullBleed and v17.hasFullBleed
	local v26 = if not Flags.FoundationSheetFullBleed then nil else v17.fullBleedHeight
	local sheetType = v17.sheetType
	local testId = v17.testId

	assert(innerScrollingEnabled and (setInnerScrollY and (actionsHeight and (setHasActionsDivider and (bottomPadding and (hasHeader and testId))))), "SheetContent must be used within a Sheet")

	local v29, v30 = React.useBinding(false)
	local v31 = React.useCallback(function(p3) -- line: 51
		-- upvalues: setInnerScrollY (copy), isScrollingFrameOverflowingY (copy), setHasActionsDivider (copy), v30 (copy)
		setInnerScrollY(p3.CanvasPosition.Y)

		local v39 = isScrollingFrameOverflowingY(p3, 1)

		setHasActionsDivider(v39)
		v30(v39)
	end, {
		setHasActionsDivider,
		setInnerScrollY
	})
	local v32, v33 = React.useBinding(0)
	local v34 = React.useCallback(function(p4) -- line: 61
		-- upvalues: v33 (copy)
		v33(p4.AbsoluteSize.Y)
	end, {})
	local v35 = sheetType == SheetType.Bottom
	local v36 = p1.Selectable == nil or p1.Selectable
	local v37 = if not v29 then nil else v29:map(function(b1: boolean) -- line: 69
		-- upvalues: v36 (copy)
		return v36 and b1
	end)

	return React.createElement(ScrollView, {
		ZIndex = 1,
		tag = "fill size-full-0 auto-y",
		scrollingFrameRef = p1.scrollingFrameRef,
		selection = {
			Selectable = v37,
			NextSelectionUp = p1.NextSelectionUp,
			NextSelectionDown = p1.NextSelectionDown,
			NextSelectionLeft = p1.NextSelectionLeft,
			NextSelectionRight = p1.NextSelectionRight
		},
		scroll = {
			ScrollingEnabled = innerScrollingEnabled,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = if not sheetContentHeight then UDim2.fromScale(1, 0) else v32:map(function(n1: number) -- line: 90
				return UDim2.new(1, 0, 0, n1)
			end),
			ScrollingDirection = Enum.ScrollingDirection.Y
		},
		Size = if not sheetContentHeight then nil else UDim2.fromScale(1, 1),
		padding = {
			top = hasHeader:map(function(b2: boolean) -- line: 98
				-- upvalues: v25 (copy), v35 (copy), v16 (copy)
				if b2 or v25 then
					return (UDim.new(0, 0))
				end

				return (UDim.new(0, if not v35 then v16.Margin.Small else v16.Padding.Small))
			end),
			bottom = if not v35 then UDim.new(0, v16.Padding.Small) else actionsHeight:map(function(n2: number) -- line: 104
				-- upvalues: bottomPadding (copy), v16 (copy)
				return UDim.new(0, n2 + bottomPadding + v16.Margin.Small)
			end),
			left = UDim.new(0, v16.Padding.Small),
			right = UDim.new(0, v16.Padding.Small)
		},
		ClipsDescendants = not v35 or hasHeader,
		onCanvasPositionChanged = function(p5) -- line: 112
			-- upvalues: setInnerScrollY (copy)
			setInnerScrollY(p5.CanvasPosition.Y)
		end,
		onAbsoluteCanvasSizeChanged = v31,
		onAbsoluteWindowSizeChanged = v31,
		testId = `{ testId }--content`,
		ref = p2
	}, React.createElement(View, {
		tag = "col align-x-center gap-medium size-full-0 auto-y padding-x-medium",
		onAbsoluteSizeChanged = v34
	}, if not Flags.FoundationSheetFullBleed then p1.children else {
		FullBleedSpacer = if not v25 or not v26 then nil else React.createElement(View, {
			Size = v26:map(function(n3: number) -- line: 131
				return UDim2.new(1, 0, 0, (math.max(0, n3)))
			end),
			LayoutOrder = Constants.MIN_LAYOUT_ORDER,
			testId = `{ testId }--content--full-bleed-spacer`
		}),
		Children = React.createElement(React.Fragment, nil, p1.children)
	}))
end

return React.memo(React.forwardRef(SheetContent))
