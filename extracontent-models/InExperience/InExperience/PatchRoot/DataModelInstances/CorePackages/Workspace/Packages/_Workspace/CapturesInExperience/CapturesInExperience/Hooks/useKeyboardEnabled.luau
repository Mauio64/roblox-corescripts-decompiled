local ParentParent = script.Parent.Parent.Parent
local UserInputService = game:GetService("UserInputService")
local React = require(ParentParent.React)
local useEffect = React.useEffect
local useState = React.useState

return function() -- line: 11
	-- upvalues: useState (copy), UserInputService (copy), useEffect (copy)
	local v6, v7 = useState(UserInputService.KeyboardEnabled)

	useEffect(function() -- line: 14
		-- upvalues: UserInputService (copy), v7 (copy)
		local connection = UserInputService:GetPropertyChangedSignal("KeyboardEnabled"):Connect(function() -- line: 15
			-- upvalues: v7 (copy), UserInputService (copy)
			v7(UserInputService.KeyboardEnabled)
		end)

		return function() -- line: 19
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	return v6
end
