local parent = script.Parent.Parent.Parent

local UserInputService = game:GetService("UserInputService")

local React = require(parent.React)

local useEffect = React.useEffect
local useState = React.useState

return function()
	local state, setState = useState(UserInputService.KeyboardEnabled)

	useEffect(function()
		local keyboardEnabledChangedConnection = UserInputService:GetPropertyChangedSignal("KeyboardEnabled"):Connect(function()
			setState(UserInputService.KeyboardEnabled)
		end)

		return function()
			keyboardEnabledChangedConnection:Disconnect()
		end
	end, {})

	return state
end
