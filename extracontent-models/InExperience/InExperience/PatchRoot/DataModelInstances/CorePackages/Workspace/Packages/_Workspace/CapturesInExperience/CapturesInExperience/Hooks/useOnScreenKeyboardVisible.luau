local parent = script.Parent.Parent.Parent

local UserInputService = game:GetService("UserInputService")

local React = require(parent.React)

local useEffect = React.useEffect
local useState = React.useState

return function()
	local state, setState = useState(false)

	useEffect(function()
		local onScreenKeyboardVisibleChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function()
			setState(UserInputService.OnScreenKeyboardVisible)
		end)
		return function()
			onScreenKeyboardVisibleChangedConnection:Disconnect()
		end
	end, {})

	return state
end
