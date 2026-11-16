local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local View = require(Foundation.Components.View)

require(Foundation.Enums.PaginationSize)

local PaginationDirection = require(Foundation.Enums.PaginationDirection)

local NavButton = require(script.Parent.NavButton)
local paginationSlotsUtils = require(script.Parent.Parent.paginationSlotsUtils)
require(script.Parent.Parent.usePaginationSelectionChain)

local v = {
	start = { PaginationDirection.First, PaginationDirection.Backward },
	["end"] = { PaginationDirection.Forward, PaginationDirection.Last }
}

local v2 = { start = "left-nav", ["end"] = "right-nav" }

local function shouldShowNavButton(p, props) -- 1 equivalent call inferred from this helper
	return p ~= PaginationDirection.First and p ~= PaginationDirection.Last or props.hasFirstLastButtons
end

local function getIsDisabled(p, props) -- 1 equivalent call inferred from this helper
	if p == PaginationDirection.First then
		return props.isFirstDisabled
	end

	if p == PaginationDirection.Backward then
		return props.isBackDisabled
	end

	if p == PaginationDirection.Forward then
		return props.isForwardDisabled
	end

	return props.isLastDisabled
end

local function NavControls(props)
	local v3 = v[props.side]
	local count = 0
	local children = {}

	for i = 1, #v3 do
		local direction = v3[i]

		if not shouldShowNavButton(direction, props) then -- inferred equivalent call
			continue
		end

		count += 1
		local v4 = paginationSlotsUtils.NAV_SLOT_IDS[direction]
		local slotBindings = props.selection.getSlotBindings(v4)
		children[direction] = React.createElement(NavButton, {
			baseTestId = props.testId,
			slotSize = props.size,
			direction = direction,
			isDisabled = getIsDisabled(direction, props), -- inferred equivalent call
			LayoutOrder = count,
			onDirectionActivated = props.onDirectionActivated,
			ref = props.selection.getSlotRef(v4),
			Selectable = slotBindings.Selectable,
			NextSelectionLeft = slotBindings.NextSelectionLeft,
			NextSelectionRight = slotBindings.NextSelectionRight,
			NextSelectionUp = slotBindings.NextSelectionUp,
			NextSelectionDown = slotBindings.NextSelectionDown
		})
	end

	return React.createElement(
		View,
		{
			LayoutOrder = props.LayoutOrder,
			tag = "row gap-xsmall auto-xy",
			testId = `{props.testId}--{v2[props.side]}`
		},
		children
	)
end

return React.memo(NavControls)
