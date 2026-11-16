local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")

local view = Foundation.View

local function SduiSubscriptionCell(props)
	local createElement = React.createElement
	local v6 = {
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

	local v8 = if props.contentRowComponent then React.createElement(view, {
		LayoutOrder = 1,
		tag = not props.contentRowSlotTag and "size-full-0 auto-y" or props.contentRowSlotTag
	}, props.contentRowComponent) else nil

	local v9 = if props.buttonComponent then React.createElement(view, {
		LayoutOrder = 2,
		tag = not props.buttonSlotTag and "size-full-0 auto-y" or props.buttonSlotTag
	}, props.buttonComponent) else nil
	return createElement(view, v6, { ContentRowSlot = v8, ButtonSlot = v9 })
end

return React.memo(SduiSubscriptionCell)
