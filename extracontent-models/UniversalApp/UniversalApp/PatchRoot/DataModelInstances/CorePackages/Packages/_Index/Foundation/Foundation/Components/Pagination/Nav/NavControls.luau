local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local View = require(Foundation.Components.View)

require(Foundation.Enums.PaginationSize)

local PaginationDirection = require(Foundation.Enums.PaginationDirection)
local NavButton = require(script.Parent.NavButton)
local paginationSlotsUtils = require(script.Parent.Parent.paginationSlotsUtils)

require(script.Parent.Parent.usePaginationSelectionChain)

local t1 = {
	PaginationDirection.First,
	PaginationDirection.Backward
}
local t2 = {
	PaginationDirection.Forward,
	PaginationDirection.Last
}
local t3 = {
	start = t1,
	["end"] = t2
}
local t4 = {
	start = "left-nav",
	["end"] = "right-nav"
}

local function shouldShowNavButton(p1, t5: {[any]: any}) -- line: 56
	-- upvalues: PaginationDirection (copy)
	if p1 == PaginationDirection.First or p1 == PaginationDirection.Last then
		return t5.hasFirstLastButtons
	end

	return true
end
local function getIsDisabled(p2, t6: {[any]: any}) -- line: 64
	-- upvalues: PaginationDirection (copy)
	if p2 == PaginationDirection.First then
		return t6.isFirstDisabled
	end

	if p2 == PaginationDirection.Backward then
		return t6.isBackDisabled
	end

	if p2 == PaginationDirection.Forward then
		return t6.isForwardDisabled
	end

	return t6.isLastDisabled
end
local function NavControls(t7: {[any]: any}) -- line: 76
	-- upvalues: t3 (copy), PaginationDirection (copy), paginationSlotsUtils (copy), React (copy), NavButton (copy), View (copy), t4 (copy)
	local v20 = t3[t7.side]
	local t8 = {}
	local n1 = 0

	for i = 1, #v20 do
		local v24 = v20[i]

		if v24 ~= PaginationDirection.First and v24 ~= PaginationDirection.Last or t7.hasFirstLastButtons then
			n1 += 1

			local v25 = paginationSlotsUtils.NAV_SLOT_IDS[v24]
			local v26 = t7.selection.getSlotBindings(v25)

			t8[v24] = React.createElement(NavButton, {
				baseTestId = t7.testId,
				slotSize = t7.size,
				direction = v24,
				isDisabled = if v24 ~= PaginationDirection.First then if v24 ~= PaginationDirection.Backward then if v24 ~= PaginationDirection.Forward then t7.isLastDisabled else t7.isForwardDisabled else t7.isBackDisabled else t7.isFirstDisabled,
				layoutOrder = n1,
				onDirectionActivated = t7.onDirectionActivated,
				ref = t7.selection.getSlotRef(v25),
				Selectable = v26.Selectable,
				NextSelectionLeft = v26.NextSelectionLeft,
				NextSelectionRight = v26.NextSelectionRight,
				NextSelectionUp = v26.NextSelectionUp,
				NextSelectionDown = v26.NextSelectionDown
			})
		end
	end

	return React.createElement(View, {
		tag = "row gap-xsmall auto-xy",
		LayoutOrder = t7.layoutOrder,
		testId = `{ t7.testId }--{ t4[t7.side] }`
	}, t8)
end

return React.memo(NavControls)
