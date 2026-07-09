local UserInputService = game:GetService("UserInputService")
local React = require(script:FindFirstAncestor("BuildExperience").Parent.React)

local function useOnScreenKeyboardVisible() -- line: 5
	-- upvalues: React (copy), UserInputService (copy)
	local v4, v5 = React.useState(UserInputService.OnScreenKeyboardVisible)

	React.useEffect(function() -- line: 8
		-- upvalues: UserInputService (copy), v5 (copy)
		local connection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function() -- line: 9
			-- upvalues: v5 (copy), UserInputService (copy)
			v5(UserInputService.OnScreenKeyboardVisible)
		end)

		return function() -- line: 13
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	return v4
end

return useOnScreenKeyboardVisible
