local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("ToastNotification").Parent
local React = require(Parent.React)
local AppShortcutBar = require(Parent.AppShortcutBar)
local useTokens = require(Parent.Foundation).Hooks.useTokens
local IconWithHoldAnimation = AppShortcutBar.IconWithHoldAnimation

return function(t1: {[any]: any}) -- line: 21
	-- upvalues: useTokens (copy), React (copy), IconWithHoldAnimation (copy), UserInputService (copy)
	local v8 = useTokens()
	local v9 = t1.iconSize or v8.Size.Size_350

	return React.createElement("CanvasGroup", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(v9, v9),
		LayoutOrder = t1.layoutOrder,
		Visible = t1.visible,
		GroupTransparency = t1.iconTransparency
	}, {
		HoldIcon = React.createElement(IconWithHoldAnimation, {
			size = UDim2.fromScale(1, 1),
			icon = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonSelect),
			iconSize = v9,
			progress = t1.progress
		})
	})
end
