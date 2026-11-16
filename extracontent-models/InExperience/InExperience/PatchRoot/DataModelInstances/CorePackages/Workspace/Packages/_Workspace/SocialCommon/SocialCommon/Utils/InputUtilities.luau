local InputUtilities = {}

function InputUtilities.isActivationInput(p): boolean
	return p.UserInputType == Enum.UserInputType.MouseButton1 or p.UserInputType == Enum.UserInputType.Touch
end

function InputUtilities.isPointerInput(p): boolean
	return p.UserInputType == Enum.UserInputType.MouseMovement or p.UserInputType == Enum.UserInputType.Touch
end

function InputUtilities.isTouchInput(p): boolean
	return p.UserInputType == Enum.UserInputType.Touch
end

return InputUtilities
