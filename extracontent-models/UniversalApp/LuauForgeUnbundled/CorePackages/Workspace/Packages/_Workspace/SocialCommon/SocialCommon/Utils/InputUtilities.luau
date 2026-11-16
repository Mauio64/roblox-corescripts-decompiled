return {
	isActivationInput = function(p2): boolean
		return p2.UserInputType == Enum.UserInputType.MouseButton1
			or p2.UserInputType == Enum.UserInputType.Touch
	end,
	isPointerInput = function(p2): boolean
		return p2.UserInputType == Enum.UserInputType.MouseMovement
			or p2.UserInputType == Enum.UserInputType.Touch
	end,
	isTouchInput = function(p2): boolean
		return p2.UserInputType == Enum.UserInputType.Touch
	end
}
