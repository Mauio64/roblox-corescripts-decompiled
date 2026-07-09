local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View

local function SduiSubscriptionCell(t1: {[any]: any}) -- line: 49
	-- upvalues: React (copy), View (copy), Foundation (copy)
	return React.createElement(View, {
		tag = not t1.tag and "col size-full-0 auto-y gap-medium padding-medium bg-surface-100 radius-medium" or t1.tag,
		LayoutOrder = t1.layoutOrder,
		Position = t1.position,
		ZIndex = t1.zIndex,
		Active = t1.onActivated ~= nil,
		onActivated = t1.onActivated,
		selection = {
			Selectable = false
		},
		stateLayer = {
			affordance = Foundation.Enums.StateLayerAffordance.None
		},
		testId = t1.testId
	}, {
		ContentRowSlot = if not t1.contentRowComponent then nil else React.createElement(View, {
			LayoutOrder = 1,
			tag = not t1.contentRowSlotTag and "size-full-0 auto-y" or t1.contentRowSlotTag
		}, t1.contentRowComponent),
		ButtonSlot = if not t1.buttonComponent then nil else React.createElement(View, {
			LayoutOrder = 2,
			tag = not t1.buttonSlotTag and "size-full-0 auto-y" or t1.buttonSlotTag
		}, t1.buttonComponent)
	})
end

return React.memo(SduiSubscriptionCell)
