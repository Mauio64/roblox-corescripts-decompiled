local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/React")
local AppShortcutBar = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/AppShortcutBar")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/Foundation").Hooks.useTokens
local iconWithHoldAnimation = AppShortcutBar.IconWithHoldAnimation

return function(props)
	local v5 = useTokens()
	local iconSize = props.iconSize or v5.Size.Size_350

	return React.createElement("CanvasGroup", {
		Size = UDim2.fromOffset(iconSize, iconSize),
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		Visible = props.visible,
		GroupTransparency = props.iconTransparency
	}, {
		HoldIcon = React.createElement(iconWithHoldAnimation, {
			size = UDim2.fromScale(1, 1),
			icon = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonSelect),
			iconSize = iconSize,
			progress = props.progress
		})
	})
end
