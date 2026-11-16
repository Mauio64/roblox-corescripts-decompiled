local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View

local function SduiSubscriptionCell(props)
	local createElement = React.createElement
	local v = {
		tag = not props.tag and "col size-full-0 auto-y gap-medium padding-medium bg-surface-100 radius-medium" or props.tag,
		LayoutOrder = props.layoutOrder,
		Position = props.position,
		ZIndex = props.zIndex,
		Active = props.onActivated ~= nil,
		onActivated = props.onActivated,
		selection = { Selectable = false },
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		testId = props.testId
	}
	local contentRowSlot

	if props.contentRowComponent then
		contentRowSlot = React.createElement(View, {
			LayoutOrder = 1,
			tag = not props.contentRowSlotTag and "size-full-0 auto-y" or props.contentRowSlotTag
		}, props.contentRowComponent)
	end

	local buttonSlot

	if props.buttonComponent then
		buttonSlot = React.createElement(View, {
			LayoutOrder = 2,
			tag = not props.buttonSlotTag and "size-full-0 auto-y" or props.buttonSlotTag
		}, props.buttonComponent)
	end

	return createElement(View, v, { ContentRowSlot = contentRowSlot, ButtonSlot = buttonSlot })
end

return React.memo(SduiSubscriptionCell)
