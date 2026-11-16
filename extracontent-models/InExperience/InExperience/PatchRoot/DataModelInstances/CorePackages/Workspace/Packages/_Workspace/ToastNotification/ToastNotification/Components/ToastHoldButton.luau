local UserInputService = game:GetService("UserInputService")

local parent = script:FindFirstAncestor("ToastNotification").Parent

local React = require(parent.React)
local AppShortcutBar = require(parent.AppShortcutBar)
local Foundation = require(parent.Foundation)

local useTokens = Foundation.Hooks.useTokens
local IconWithHoldAnimation = AppShortcutBar.IconWithHoldAnimation

return function(props)
	local v = useTokens()
	local iconSize = props.iconSize or v.Size.Size_350

	return React.createElement("CanvasGroup", {
		Size = UDim2.fromOffset(iconSize, iconSize),
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
		Visible = props.visible,
		GroupTransparency = props.iconTransparency
	}, {
		HoldIcon = React.createElement(IconWithHoldAnimation, {
			size = UDim2.fromScale(1, 1),
			icon = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonSelect),
			iconSize = iconSize,
			progress = props.progress
		})
	})
end
