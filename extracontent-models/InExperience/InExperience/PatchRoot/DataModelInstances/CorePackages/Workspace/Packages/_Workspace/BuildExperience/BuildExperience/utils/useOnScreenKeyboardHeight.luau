local UserInputService = game:GetService("UserInputService")

local React = require(script:FindFirstAncestor("BuildExperience").Parent.React)

local function useOnScreenKeyboardHeight()
	local function read() -- 1 equivalent call inferred from this helper
		if UserInputService.OnScreenKeyboardVisible then
			return UserInputService.OnScreenKeyboardSize.Y
		end

		return 0
	end

	local state, setState = React.useState(read)

	React.useEffect(function()
		local function update() -- 1 equivalent call inferred from this helper
			setState(read()) -- inferred equivalent call
		end

		local onScreenKeyboardVisibleChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(update)
		local onScreenKeyboardSizeChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardSize"):Connect(update)
		update() -- inferred equivalent call
		return function()
			onScreenKeyboardVisibleChangedConnection:Disconnect()
			onScreenKeyboardSizeChangedConnection:Disconnect()
		end
	end, {})

	return state
end

return useOnScreenKeyboardHeight
