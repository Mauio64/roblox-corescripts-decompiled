local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Chip = require(Foundation.Components.Chip)
local Text = require(Foundation.Components.Text)
local View = require(Foundation.Components.View)

local ChipSize = require(Foundation.Enums.ChipSize)
local ChipVariant = require(Foundation.Enums.ChipVariant)
local PaginationSize = require(Foundation.Enums.PaginationSize)

local PaginationVariant = require(Foundation.Enums.PaginationVariant)

local withDefaults = require(Foundation.Utility.withDefaults)

require(script.Parent.MultiPagePagination)
local paginationUtils = require(script.Parent.Parent.paginationUtils)
local usePaginationNav = require(script.Parent.Parent.usePaginationNav)

local v = { size = PaginationSize.Medium, testId = "--foundation-pagination" }

local function DirectionalPagination(p, p2)
	local v2 = withDefaults(p, v)
	local size = v2.size

	local count = v2.count
	local hasFirstLastButtons

	if count == nil then
		hasFirstLastButtons = false
	else
		hasFirstLastButtons = v2.hasFirstLastButtons == true
	end

	local v3 = v2.variant == PaginationVariant.SinglePage
	local v4

	if v2.hasPreviousPage == nil then
		v4 = v2.page <= 1
	else
		v4 = v2.hasPreviousPage ~= true
	end

	local v5

	if count == nil then
		v5 = v2.hasNextPage == nil or v2.hasNextPage ~= true
	else
		v5 = count <= v2.page
	end

	local state, setState = React.useState(nil)

	local v6 = usePaginationNav(v2, {
		hasFirstLastButtons = hasFirstLastButtons,
		currentPage = v2.page,
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

	local v7 = React.useMemo(function()
		if not v3 then
			return nil
		end

		local page = tostring(v2.page)

		if not paginationUtils.needsWidePageSlot(v2.page) then
			return React.createElement(
				View,
				{
					LayoutOrder = 2,
					tag = paginationUtils.getCircularSlotTag(size),
					testId = `{v2.testId}--page-label`
				},
				{
					Text = React.createElement(Text, {
						Text = page,
						tag = paginationUtils.getPageLabelTag(size),
						LayoutOrder = 1
					})
				}
			)
		end

		local createElement = React.createElement
		local v7 = {
			LayoutOrder = 2,
			isChecked = false,
			isDisabled = true,
			onActivated = function() end,
			size = 0,
			testId = 0,
			text = 0,
			variant = 0
		}
		local size2

		if size == PaginationSize.Small then
			size2 = ChipSize.Small
		else
			size2 = ChipSize.Medium
		end

		v7.size = size2
		v7.testId = `{v2.testId}--page-label`
		v7.text = page
		v7.variant = ChipVariant.Utility
		return createElement(Chip, v7)
	end, { v3, v2.page, size, v2.testId })

	return v6.createLayout(v7)
end

return React.memo(React.forwardRef(DirectionalPagination))
