local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local UserInputService = game:GetService("UserInputService")

local function useOnScreenKeyboardHeight()
	local state, setState = React.useState(0)

	React.useEffect(function()
		local onScreenKeyboardVisibleChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function()
			setState(not UserInputService.OnScreenKeyboardVisible and 0 or UserInputService.OnScreenKeyboardSize.Y)
		end)

		return function()
			onScreenKeyboardVisibleChangedConnection:Disconnect()
		end
	end, {})

	return state
end

return useOnScreenKeyboardHeight
