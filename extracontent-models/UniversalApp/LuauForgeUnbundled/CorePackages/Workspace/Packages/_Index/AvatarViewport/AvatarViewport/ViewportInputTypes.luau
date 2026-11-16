local UserInputService = game:GetService("UserInputService")

return {
	isMouseWheel = function(p2): boolean
		return p2.UserInputType == Enum.UserInputType.MouseWheel
	end,
	isPrimaryPointerBegan = function(p2): boolean
		return p2.UserInputType == Enum.UserInputType.MouseButton1
	end,
	isPrimaryPointerEnded = function(p2): boolean
		return p2.UserInputType == Enum.UserInputType.MouseButton1
	end,
	isMouseMovement = function(p2): boolean
		return p2.UserInputType == Enum.UserInputType.MouseMovement
	end,
	isTouch = function(p2): boolean
		return p2.UserInputType == Enum.UserInputType.Touch
	end,
	isTouchEnabled = function()
		return UserInputService.TouchEnabled
	end
}
