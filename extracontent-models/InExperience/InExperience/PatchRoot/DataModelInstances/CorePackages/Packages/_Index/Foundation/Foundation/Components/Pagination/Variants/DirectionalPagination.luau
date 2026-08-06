local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
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
local t1 = {
	testId = "--foundation-pagination",
	size = PaginationSize.Medium
}

local function DirectionalPagination(p1, p2) -- line: 37
	-- upvalues: withDefaults (copy), t1 (copy), PaginationVariant (copy), React (copy), usePaginationNav (copy), paginationUtils (copy), Chip (copy), PaginationSize (copy), ChipSize (copy), ChipVariant (copy), View (copy), Text (copy)
	local v18 = withDefaults(p1, t1)
	local size = v18.size
	local count = v18.count
	local v21 = count ~= nil and v18.hasFirstLastButtons == true
	local v22 = v18.variant == PaginationVariant.SinglePage
	local v23 = if v18.hasPreviousPage == nil then v18.page <= 1 else v18.hasPreviousPage ~= true
	local v24 = if count == nil then v18.hasNextPage == nil or v18.hasNextPage ~= true else count <= v18.page
	local v25, v26 = React.useState(nil)
	local v27 = usePaginationNav(v18, {
		hasFirstLastButtons = v21,
		currentPage = v18.page,
		disabledState = {
			isBackDisabled = v23,
			isFirstDisabled = v23,
			isForwardDisabled = v24,
			isLastDisabled = v24
		}
	}, v26)

	React.useImperativeHandle(p2, function() -- line: 64
		-- upvalues: v25 (copy)
		return v25
	end, { v25 })

	local v28 = React.useMemo(function() -- line: 68
		-- upvalues: v22 (copy), v18 (copy), paginationUtils (copy), React (copy), Chip (copy), size (copy), PaginationSize (copy), ChipSize (copy), ChipVariant (copy), View (copy), Text (copy)
		if not v22 then
			return nil
		end

		local str = tostring(v18.page)

		if paginationUtils.needsWidePageSlot(v18.page) then
			return React.createElement(Chip, {
				LayoutOrder = 2,
				isChecked = false,
				isDisabled = true,
				onActivated = function() -- line: 80
				end,
				size = if size ~= PaginationSize.Small then ChipSize.Medium else ChipSize.Small,
				testId = `{ v18.testId }--page-label`,
				text = str,
				variant = ChipVariant.Utility
			})
		end

		return React.createElement(View, {
			LayoutOrder = 2,
			tag = paginationUtils.getCircularSlotTag(size),
			testId = `{ v18.testId }--page-label`
		}, {
			Text = React.createElement(Text, {
				LayoutOrder = 1,
				Text = str,
				tag = paginationUtils.getPageLabelTag(size)
			})
		})
	end, {
		v22,
		v18.page,
		size,
		v18.testId
	})

	return v27.createLayout(v28)
end

return React.memo(React.forwardRef(DirectionalPagination))
