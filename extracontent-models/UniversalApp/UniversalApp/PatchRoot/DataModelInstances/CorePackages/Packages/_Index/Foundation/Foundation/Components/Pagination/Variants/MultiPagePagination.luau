local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

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

local v = {
	size = PaginationSize.Medium,
	hasFirstLastButtons = false,
	testId = "--foundation-pagination"
}

local function MultiPagePagination(p, p2)
	local v2 = withDefaults(p, v)
	local size = v2.size
	local v3 = useTokens()

	local v4 = v2.page <= 1
	local v5 = v2.page >= v2.count

	local pageSlots = React.useMemo(function()
		return paginationSlotsUtils.getVisiblePageSlots(v2.page, v2.count)
	end, { v2.page, v2.count })

	local state, setState = React.useState(nil)

	local v6 = usePaginationNav(v2, {
		hasFirstLastButtons = v2.hasFirstLastButtons,
		currentPage = v2.page,
		pageSlots = pageSlots,
		disabledState = {
			isBackDisabled = v4,
			isFirstDisabled = v4,
			isForwardDisabled = v5,
			isLastDisabled = v5
		}
	}, setState)

	React.useImperativeHandle(p2, function()
		return state
	end, { state })

	local ref = React.useRef(nil)

	local v7 = React.useMemo(function()
		local refsByPageSlotId = {}

		for _, v7 in pageSlots do
			if v7 == "ellipsis" then
				continue
			end

			local pageSlotId = paginationSlotsUtils.getPageSlotId(v7)
			refsByPageSlotId[pageSlotId] = v6.selection.getSlotBindings(pageSlotId).ref
		end

		return refsByPageSlotId
	end, { pageSlots, v6.selection })

	local pageSlotId = paginationSlotsUtils.getPageSlotId(v2.page)
	local v8 = usePaginationAnimatedHighlight(pageSlotId, ref, v7, size, pageSlots)
	local v9

	if size == PaginationSize.Small then
		v9 = ChipSize.Small
	else
		v9 = ChipSize.Medium
	end

	local v10 = useChipVariants(v3, v9, ChipVariant.Utility, true, false, false)

	local v11 = React.useMemo(function()
		local children = {}

		for k, page in pageSlots do
			if page == "ellipsis" then
				children[k == 2 and "ellipsis-leading" or "ellipsis-trailing"] = React.createElement(Ellipsis, {
					slotSize = size,
					LayoutOrder = k,
					testId = `{v2.testId}--ellipsis-{k}`
				})
			else
				local pageSlotId2 = paginationSlotsUtils.getPageSlotId(page)
				local slotBindings = v6.selection.getSlotBindings(pageSlotId2)
				children[`Page-{page}`] = React.createElement(PageNumberSlot, {
					slotSize = size,
					isChecked = page == v2.page,
					LayoutOrder = k,
					onPageActivated = v2.onActivated,
					page = page,
					testId = `{v2.testId}--page-{page}`,
					ref = v6.selection.getSlotRef(pageSlotId2),
					Selectable = slotBindings.Selectable,
					NextSelectionLeft = slotBindings.NextSelectionLeft,
					NextSelectionRight = slotBindings.NextSelectionRight,
					NextSelectionUp = slotBindings.NextSelectionUp,
					NextSelectionDown = slotBindings.NextSelectionDown
				})
			end
		end

		return children
	end, { pageSlots, v2.page, size, v2.testId, v2.onActivated, v6.selection })

	local onAbsoluteSizeChanged = React.useCallback(function()
		local v12 = v7[pageSlotId]

		if v12 and v12.current and ref.current then
			v8.updateHighlight(v12, true)
		end
	end, { pageSlotId, v7, v8.updateHighlight })

	local createLayout = v6.createLayout
	local createElement = React.createElement
	local v12 = { LayoutOrder = 2, tag = "auto-xy", testId = `{v2.testId}--pages`, ref = ref }
	local activePageHighlight

	if not paginationUtils.needsWidePageSlot(v2.page) then
		activePageHighlight = React.createElement(View, {
			Active = false,
			backgroundStyle = v10.chip.backgroundStyle,
			tag = "radius-circle clip",
			Size = React.joinBindings({ v8.highlightWidth, v8.activeItemHeight }):map(function(list)
				return UDim2.fromOffset(list[1], list[2])
			end),
			Position = v8.highlightPosition:map(function(p3: number)
				return UDim2.fromOffset(p3, 0)
			end),
			Visible = v8.isVisible,
			ZIndex = 1,
			selection = { Selectable = false },
			testId = `{v2.testId}--active-page-highlight`
		})
	end

	return createLayout(createElement(View, v12, {
		ActivePageHighlight = activePageHighlight,
		PagesRow = React.createElement(
			View,
			{
				tag = "row gap-xsmall auto-xy",
				LayoutOrder = 1,
				ZIndex = 2,
				onAbsoluteSizeChanged = onAbsoluteSizeChanged
			},
			v11
		)
	}), nil)
end

return React.memo(React.forwardRef(MultiPagePagination))
