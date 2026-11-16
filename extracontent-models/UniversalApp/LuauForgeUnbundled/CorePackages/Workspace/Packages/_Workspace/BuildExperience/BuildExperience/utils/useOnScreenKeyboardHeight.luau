local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local function useOnScreenKeyboardHeight()
	local function read()
		if UserInputService.OnScreenKeyboardVisible then
			return UserInputService.OnScreenKeyboardSize.Y
		end

		return 0
	end

	local state, setState = React.useState(read)

	React.useEffect(function()
		local function update()
			setState(not UserInputService.OnScreenKeyboardVisible and 0 or UserInputService.OnScreenKeyboardSize.Y)
		end

		local onScreenKeyboardVisibleChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(update)
		local onScreenKeyboardSizeChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardSize"):Connect(update)
		setState(not UserInputService.OnScreenKeyboardVisible and 0 or UserInputService.OnScreenKeyboardSize.Y)

		return function()
			onScreenKeyboardVisibleChangedConnection:Disconnect()
			onScreenKeyboardSizeChangedConnection:Disconnect()
		end
	end, {})

	return state
end

return useOnScreenKeyboardHeight
