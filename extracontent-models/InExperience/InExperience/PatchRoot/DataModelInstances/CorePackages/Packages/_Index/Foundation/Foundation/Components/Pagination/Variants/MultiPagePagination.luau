local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useChipVariants = require(Foundation.Components.Chip.useChipVariants)
local ChipSize = require(Foundation.Enums.ChipSize)
local ChipVariant = require(Foundation.Enums.ChipVariant)
local PaginationSize = require(Foundation.Enums.PaginationSize)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withDefaults = require(Foundation.Utility.withDefaults)
local Ellipsis = require(script.Parent.Parent.Nav.Ellipsis)
local PageNumberSlot = require(script.Parent.Parent.Nav.PageNumberSlot)
local paginationSlotsUtils = require(script.Parent.Parent.paginationSlotsUtils)
local paginationUtils = require(script.Parent.Parent.paginationUtils)
local usePaginationAnimatedHighlight = require(script.Parent.Parent.usePaginationAnimatedHighlight)
local usePaginationNav = require(script.Parent.Parent.usePaginationNav)
local t1 = {
	hasFirstLastButtons = false,
	testId = "--foundation-pagination",
	size = PaginationSize.Medium
}

local function MultiPagePagination(p1, p2) -- line: 44
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), React (copy), paginationSlotsUtils (copy), usePaginationNav (copy), usePaginationAnimatedHighlight (copy), PaginationSize (copy), ChipSize (copy), useChipVariants (copy), ChipVariant (copy), Ellipsis (copy), PageNumberSlot (copy), View (copy), paginationUtils (copy)
	local v21 = withDefaults(p1, t1)
	local size = v21.size
	local v23 = useTokens()
	local v24 = v21.page <= 1
	local v25 = v21.page >= v21.count
	local v26 = React.useMemo(function() -- line: 52
		-- upvalues: paginationSlotsUtils (copy), v21 (copy)
		return paginationSlotsUtils.getVisiblePageSlots(v21.page, v21.count)
	end, {
		v21.page,
		v21.count
	})
	local v27, v28 = React.useState(nil)
	local v29 = usePaginationNav(v21, {
		hasFirstLastButtons = v21.hasFirstLastButtons,
		currentPage = v21.page,
		pageSlots = v26,
		disabledState = {
			isBackDisabled = v24,
			isFirstDisabled = v24,
			isForwardDisabled = v25,
			isLastDisabled = v25
		}
	}, v28)

	React.useImperativeHandle(p2, function() -- line: 70
		-- upvalues: v27 (copy)
		return v27
	end, { v27 })

	local v30 = React.useRef(nil)
	local v31 = React.useMemo(function() -- line: 76
		-- upvalues: v26 (copy), paginationSlotsUtils (copy), v29 (copy)
		local t2 = {}

		for _, v40 in v26 do
			if v40 ~= "ellipsis" then
				local v41 = paginationSlotsUtils.getPageSlotId(v40)

				t2[v41] = v29.selection.getSlotBindings(v41).ref
			end
		end

		return t2
	end, {
		v26,
		v29.selection
	})
	local v32 = paginationSlotsUtils.getPageSlotId(v21.page)
	local v33 = usePaginationAnimatedHighlight(v32, v30, v31, size, v26)
	local v34 = if size ~= PaginationSize.Small then ChipSize.Medium else ChipSize.Small
	local v35 = useChipVariants(v23, v34, ChipVariant.Utility, true, false, false)
	local v36 = React.useMemo(function() -- line: 94
		-- upvalues: v26 (copy), React (copy), Ellipsis (copy), size (copy), v21 (copy), paginationSlotsUtils (copy), v29 (copy), PageNumberSlot (copy)
		local t3 = {}

		for v43, v44 in v26 do
			if v44 == "ellipsis" then
				t3[v43 ~= 2 and "ellipsis-trailing" or "ellipsis-leading"] = React.createElement(Ellipsis, {
					slotSize = size,
					layoutOrder = v43,
					testId = `{ v21.testId }--ellipsis-{ v43 }`
				})
			else
				local v45 = paginationSlotsUtils.getPageSlotId(v44)
				local v46 = v29.selection.getSlotBindings(v45)

				t3[`Page-{ v44 }`] = React.createElement(PageNumberSlot, {
					slotSize = size,
					isChecked = v44 == v21.page,
					layoutOrder = v43,
					onPageActivated = v21.onActivated,
					page = v44,
					testId = `{ v21.testId }--page-{ v44 }`,
					ref = v29.selection.getSlotRef(v45),
					Selectable = v46.Selectable,
					NextSelectionLeft = v46.NextSelectionLeft,
					NextSelectionRight = v46.NextSelectionRight,
					NextSelectionUp = v46.NextSelectionUp,
					NextSelectionDown = v46.NextSelectionDown
				})
			end
		end

		return t3
	end, {
		v26,
		v21.page,
		size,
		v21.testId,
		v21.onActivated,
		v29.selection
	})
	local v37 = React.useCallback(function() -- line: 138
		-- upvalues: v31 (copy), v32 (copy), v30 (copy), v33 (copy)
		local v47 = v31[v32]

		if v47 and (v47.current and v30.current) then
			v33.updateHighlight(v47, true)
		end
	end, {
		v32,
		v31,
		v33.updateHighlight
	})

	return v29.createLayout(React.createElement(View, {
		LayoutOrder = 2,
		tag = "auto-xy",
		testId = `{ v21.testId }--pages`,
		ref = v30
	}, {
		ActivePageHighlight = if paginationUtils.needsWidePageSlot(v21.page) then nil else React.createElement(View, {
			Active = false,
			tag = "radius-circle clip",
			ZIndex = 1,
			backgroundStyle = v35.chip.backgroundStyle,
			Size = React.joinBindings({
				v33.highlightWidth,
				v33.activeItemHeight
			}):map(function(p3) -- line: 158
				return UDim2.fromOffset(p3[1], p3[2])
			end),
			Position = v33.highlightPosition:map(function(n1: number) -- line: 161
				return UDim2.fromOffset(n1, 0)
			end),
			Visible = v33.isVisible,
			selection = {
				Selectable = false
			},
			testId = `{ v21.testId }--active-page-highlight`
		}),
		PagesRow = React.createElement(View, {
			tag = "row gap-xsmall auto-xy",
			LayoutOrder = 1,
			ZIndex = 2,
			onAbsoluteSizeChanged = v37
		}, v36)
	}), nil)
end

return React.memo(React.forwardRef(MultiPagePagination))
