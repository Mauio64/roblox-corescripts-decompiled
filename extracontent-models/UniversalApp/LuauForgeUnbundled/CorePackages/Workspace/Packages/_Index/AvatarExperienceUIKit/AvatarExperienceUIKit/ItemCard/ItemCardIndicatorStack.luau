local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local view = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Foundation").View

local function ItemCardIndicatorStack(p2)
	local createElement = React.createElement

	local v8 = if p2.statusSlot then React.cloneElement(p2.statusSlot, {
		LayoutOrder = 1
	}) else nil

	local v9 = if p2.itemTypeSlot then React.cloneElement(p2.itemTypeSlot, {
		LayoutOrder = 2
	}) else nil
	return createElement(
		view,
		{
			tag = "row align-x-right align-y-center gap-xsmall auto-xy",
			testId = "item-card-indicator-stack"
		},
		{ ItemCardIndicatorStackStatus = v8, ItemCardIndicatorStackItemType = v9 }
	)
end

return ItemCardIndicatorStack
