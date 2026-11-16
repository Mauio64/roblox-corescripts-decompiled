local parent = script:FindFirstAncestor("AmpUpsell").Parent
local React = require(parent.React)
local UserInputService = game:GetService("UserInputService")

local useEffect = React.useEffect
local useState = React.useState

return function()
	local state, setState = useState(0)

	useEffect(function()
		local onScreenKeyboardVisibleChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function()
			setState(UserInputService.OnScreenKeyboardVisible and UserInputService.OnScreenKeyboardSize.Y or 0)
		end)
		return function()
			onScreenKeyboardVisibleChangedConnection:Disconnect()
		end
	end, {})

	return state
end
