local UserInputService = game:GetService("UserInputService")
local ViewportInputTypes = {}

function ViewportInputTypes.isMouseWheel(p): boolean
	return p.UserInputType == Enum.UserInputType.MouseWheel
end

function ViewportInputTypes.isPrimaryPointerBegan(p): boolean
	return p.UserInputType == Enum.UserInputType.MouseButton1
end

function ViewportInputTypes.isPrimaryPointerEnded(p): boolean
	return p.UserInputType == Enum.UserInputType.MouseButton1
end

function ViewportInputTypes.isMouseMovement(p): boolean
	return p.UserInputType == Enum.UserInputType.MouseMovement
end

function ViewportInputTypes.isTouch(p): boolean
	return p.UserInputType == Enum.UserInputType.Touch
end

function ViewportInputTypes.isTouchEnabled()
	return UserInputService.TouchEnabled
end

return ViewportInputTypes
