local ParentParent = script.Parent.Parent.Parent
local UserInputService = game:GetService("UserInputService")
local React = require(ParentParent.React)
local useEffect = React.useEffect
local useState = React.useState

return function() -- line: 11
	-- upvalues: useState (copy), useEffect (copy), UserInputService (copy)
	local v6, v7 = useState(false)

	useEffect(function() -- line: 14
		-- upvalues: UserInputService (copy), v7 (copy)
		local connection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function() -- line: 16
			-- upvalues: v7 (copy), UserInputService (copy)
			v7(UserInputService.OnScreenKeyboardVisible)
		end)

		return function() -- line: 19
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	return v6
end
