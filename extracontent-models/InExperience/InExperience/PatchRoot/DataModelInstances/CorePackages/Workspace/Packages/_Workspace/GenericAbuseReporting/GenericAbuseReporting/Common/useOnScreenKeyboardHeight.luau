local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local React = require(parent.React)

local UserInputService = game:GetService("UserInputService")

return function()
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(0)
	local state3, setState3 = React.useState(0)

	React.useEffect(function()
		local function updateKeyboardState() -- 1 equivalent call inferred from this helper
			local onScreenKeyboardVisible = UserInputService.OnScreenKeyboardVisible
			local y = UserInputService.OnScreenKeyboardSize.Y
			local y2 = UserInputService.OnScreenKeyboardPosition.Y

			setState(onScreenKeyboardVisible)
			setState2(not onScreenKeyboardVisible and 0 or y)
			setState3(not onScreenKeyboardVisible and 0 or y2)
		end

		updateKeyboardState() -- inferred equivalent call
		local onScreenKeyboardVisibleChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(updateKeyboardState)
		local onScreenKeyboardSizeChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardSize"):Connect(updateKeyboardState)
		local onScreenKeyboardPositionChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardPosition"):Connect(updateKeyboardState)

		return function()
			if onScreenKeyboardVisibleChangedConnection then
				onScreenKeyboardVisibleChangedConnection:Disconnect()
			end

			if onScreenKeyboardSizeChangedConnection then
				onScreenKeyboardSizeChangedConnection:Disconnect()
			end

			if onScreenKeyboardPositionChangedConnection then
				onScreenKeyboardPositionChangedConnection:Disconnect()
			end
		end
	end, {})

	return {
		isKeyboardShowing = state,
		onScreenKeyboardHeight = state2,
		keyboardPositionY = state3
	}
end
