local Foundation = game:GetService("CorePackages").Packages._Index.Foundation.Foundation
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local useTokens = require(Foundation.Providers.Style.useTokens)
local Constants = require(Foundation.Constants)
local Sheet = script:FindFirstAncestor("Sheet")
local SheetContext = require(Sheet.SheetContext)
local SheetType = require(Sheet.SheetType)
local ScrollView = require(Foundation.Components.ScrollView)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local isScrollingFrameOverflowingY = require(Foundation.Utility.isScrollingFrameOverflowingY)

local function SheetContent(p1, p2) -- line: 22
	-- upvalues: useTokens (copy), React (copy), SheetContext (copy), isScrollingFrameOverflowingY (copy), SheetType (copy), ScrollView (copy), View (copy), Constants (copy)
	local v15 = useTokens()
	local v16 = React.useContext(SheetContext)
	local innerScrollingEnabled = v16.innerScrollingEnabled
	local setInnerScrollY = v16.setInnerScrollY
	local actionsHeight = v16.actionsHeight
	local sheetContentHeight = v16.sheetContentHeight
	local setHasActionsDivider = v16.setHasActionsDivider
	local bottomPadding = v16.bottomPadding
	local hasHeader = v16.hasHeader
	local hasFullBleed = v16.hasFullBleed
	local fullBleedHeight = v16.fullBleedHeight
	local sheetType = v16.sheetType
	local testId = v16.testId

	assert(innerScrollingEnabled and (setInnerScrollY and (actionsHeight and (setHasActionsDivider and (bottomPadding and (hasHeader and testId))))), "SheetContent must be used within a Sheet")

	local v28, v29 = React.useBinding(false)
	local v30 = React.useCallback(function(p3) -- line: 50
		-- upvalues: setInnerScrollY (copy), isScrollingFrameOverflowingY (copy), setHasActionsDivider (copy), v29 (copy)
		setInnerScrollY(p3.CanvasPosition.Y)

		local v38 = isScrollingFrameOverflowingY(p3, 1)

		setHasActionsDivider(v38)
		v29(v38)
	end, {
		setHasActionsDivider,
		setInnerScrollY
	})
	local v31, v32 = React.useBinding(0)
	local v33 = React.useCallback(function(p4) -- line: 60
		-- upvalues: v32 (copy)
		v32(p4.AbsoluteSize.Y)
	end, {})
	local v34 = sheetType == SheetType.Bottom
	local v35 = p1.Selectable == nil or p1.Selectable
	local v36 = if not v28 then nil else v28:map(function(b1: boolean) -- line: 68
		-- upvalues: v35 (copy)
		return v35 and b1
	end)

	return React.createElement(ScrollView, {
		ZIndex = 1,
		tag = "fill size-full-0 auto-y",
		scrollingFrameRef = p1.scrollingFrameRef,
		selection = {
			Selectable = v36,
			NextSelectionUp = p1.NextSelectionUp,
			NextSelectionDown = p1.NextSelectionDown,
			NextSelectionLeft = p1.NextSelectionLeft,
			NextSelectionRight = p1.NextSelectionRight
		},
		scroll = {
			ScrollingEnabled = innerScrollingEnabled,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = if not sheetContentHeight then UDim2.fromScale(1, 0) else v31:map(function(n1: number) -- line: 89
				return UDim2.new(1, 0, 0, n1)
			end),
			ScrollingDirection = Enum.ScrollingDirection.Y
		},
		Size = if not sheetContentHeight then nil else UDim2.fromScale(1, 1),
		padding = {
			top = hasHeader:map(function(b2: boolean) -- line: 97
				-- upvalues: hasFullBleed (copy), v34 (copy), v15 (copy)
				if b2 or hasFullBleed then
					return (UDim.new(0, 0))
				end

				return (UDim.new(0, if not v34 then v15.Margin.Small else v15.Padding.Small))
			end),
			bottom = if not v34 then UDim.new(0, v15.Padding.Small) else actionsHeight:map(function(n2: number) -- line: 103
				-- upvalues: bottomPadding (copy), v15 (copy)
				return UDim.new(0, n2 + bottomPadding + v15.Margin.Small)
			end),
			left = UDim.new(0, v15.Padding.Small),
			right = UDim.new(0, v15.Padding.Small)
		},
		ClipsDescendants = not v34 or hasHeader,
		onCanvasPositionChanged = function(p5) -- line: 111
			-- upvalues: setInnerScrollY (copy)
			setInnerScrollY(p5.CanvasPosition.Y)
		end,
		onAbsoluteCanvasSizeChanged = v30,
		onAbsoluteWindowSizeChanged = v30,
		testId = `{ testId }--content`,
		ref = p2
	}, React.createElement(View, {
		tag = "col align-x-center gap-medium size-full-0 auto-y padding-x-medium",
		onAbsoluteSizeChanged = v33
	}, {
		FullBleedSpacer = if not hasFullBleed or not fullBleedHeight then nil else React.createElement(View, {
			Size = fullBleedHeight:map(function(n3: number) -- line: 126
				return UDim2.new(1, 0, 0, (math.max(0, n3)))
			end),
			LayoutOrder = Constants.MIN_LAYOUT_ORDER,
			testId = `{ testId }--content--full-bleed-spacer`
		}),
		Children = React.createElement(React.Fragment, nil, p1.children)
	}))
end

return React.memo(React.forwardRef(SheetContent))
