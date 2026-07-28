local UserInputService = game:GetService("UserInputService")
local React = require(script:FindFirstAncestor("BuildExperience").Parent.React)

local function useOnScreenKeyboardHeight() -- line: 8
	-- upvalues: UserInputService (copy), React (copy)
	local function read() -- line: 9
		-- upvalues: UserInputService (copy)
		if UserInputService.OnScreenKeyboardVisible then
			return UserInputService.OnScreenKeyboardSize.Y
		end

		return 0
	end

	local v5, v6 = React.useState(read)

	React.useEffect(function() -- line: 18
		-- upvalues: v6 (copy), UserInputService (copy)
		local function update() -- line: 19
			-- upvalues: v6 (copy), UserInputService (copy)
			v6(not UserInputService.OnScreenKeyboardVisible and 0 or UserInputService.OnScreenKeyboardSize.Y)
		end

		local connection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(update)
		local connection2 = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardSize"):Connect(update)

		v6(not UserInputService.OnScreenKeyboardVisible and 0 or UserInputService.OnScreenKeyboardSize.Y)

		return function() -- line: 27
			-- upvalues: connection (copy), connection2 (copy)
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, {})

	return v5
end

return useOnScreenKeyboardHeight
