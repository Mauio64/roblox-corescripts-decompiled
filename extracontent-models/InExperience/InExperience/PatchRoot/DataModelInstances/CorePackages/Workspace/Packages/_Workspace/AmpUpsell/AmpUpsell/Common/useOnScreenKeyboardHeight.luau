local Parent = script:FindFirstAncestor("AmpUpsell").Parent
local React = require(Parent.React)
local UserInputService = game:GetService("UserInputService")
local useEffect = React.useEffect
local useState = React.useState

return function() -- line: 9
	-- upvalues: useState (copy), useEffect (copy), UserInputService (copy)
	local v6, v7 = useState(0)

	useEffect(function() -- line: 12
		-- upvalues: UserInputService (copy), v7 (copy)
		local connection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function() -- line: 14
			-- upvalues: v7 (copy), UserInputService (copy)
			v7(UserInputService.OnScreenKeyboardVisible and UserInputService.OnScreenKeyboardSize.Y or 0)
		end)

		return function() -- line: 19
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	return v6
end
