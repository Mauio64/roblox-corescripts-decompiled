local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View

local function ItemCardIndicatorStack(p)
	local createElement = React.createElement
	local itemCardIndicatorStackStatus

	if p.statusSlot then
		itemCardIndicatorStackStatus = React.cloneElement(p.statusSlot, { LayoutOrder = 1 })
	end

	local itemCardIndicatorStackItemType

	if p.itemTypeSlot then
		itemCardIndicatorStackItemType = React.cloneElement(p.itemTypeSlot, { LayoutOrder = 2 })
	end

	return createElement(
		View,
		{
			tag = "row align-x-right align-y-center gap-xsmall auto-xy",
			testId = "item-card-indicator-stack"
		},
		{
			ItemCardIndicatorStackStatus = itemCardIndicatorStackStatus,
			ItemCardIndicatorStackItemType = itemCardIndicatorStackItemType
		}
	)
end

return ItemCardIndicatorStack
