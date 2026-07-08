return {
	isActivationInput = function(p1) -- line: 3
		return p1.UserInputType == Enum.UserInputType.MouseButton1 or p1.UserInputType == Enum.UserInputType.Touch
	end,
	isPointerInput = function(p2) -- line: 8
		return p2.UserInputType == Enum.UserInputType.MouseMovement or p2.UserInputType == Enum.UserInputType.Touch
	end,
	isTouchInput = function(p3) -- line: 13
		return p3.UserInputType == Enum.UserInputType.Touch
	end
}
