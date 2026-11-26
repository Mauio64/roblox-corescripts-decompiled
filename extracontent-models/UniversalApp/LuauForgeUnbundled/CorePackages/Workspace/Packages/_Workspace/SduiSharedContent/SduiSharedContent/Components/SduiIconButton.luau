local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")

local iconButton = Foundation.IconButton

local function fn() end

local function SduiIconButton(props)
	if props.icon and props.icon.name then
		return React.createElement(iconButton, {
			icon = props.icon,
			isCircular = props.isCircular,
			width = props.width,
			size = props.size,
			variant = props.variant,
			onActivated = props.onActivated or fn,
			LayoutOrder = props.layoutOrder,
			AnchorPoint = props.anchorPoint,
			Position = props.position,
			Visible = props.visible,
			ZIndex = props.zIndex,
			isDisabled = props.isDisabled,
			testId = props.testId
		})
	end

	return nil
end

return React.memo(SduiIconButton)
