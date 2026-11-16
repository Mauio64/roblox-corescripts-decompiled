local UserInputService = game:GetService("UserInputService")

local React = require(script:FindFirstAncestor("BuildExperience").Parent.React)

local function useOnScreenKeyboardVisible()
	local state, setState = React.useState(UserInputService.OnScreenKeyboardVisible)

	React.useEffect(function()
		local onScreenKeyboardVisibleChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function()
			setState(UserInputService.OnScreenKeyboardVisible)
		end)

		return function()
			onScreenKeyboardVisibleChangedConnection:Disconnect()
		end
	end, {})

	return state
end

return useOnScreenKeyboardVisible
