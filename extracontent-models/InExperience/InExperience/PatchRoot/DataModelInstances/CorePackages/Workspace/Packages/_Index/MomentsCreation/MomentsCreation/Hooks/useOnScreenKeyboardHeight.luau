local Parent = script:FindFirstAncestor("MomentsCreation").Parent
local React = require(Parent.React)
local UserInputService = game:GetService("UserInputService")

local function useOnScreenKeyboardHeight() -- line: 15
	-- upvalues: React (copy), UserInputService (copy)
	local v5, v6 = React.useState(0)

	React.useEffect(function() -- line: 18
		-- upvalues: UserInputService (copy), v6 (copy)
		local connection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function() -- line: 19
			-- upvalues: v6 (copy), UserInputService (copy)
			v6(not UserInputService.OnScreenKeyboardVisible and 0 or UserInputService.OnScreenKeyboardSize.Y)
		end)

		return function() -- line: 25
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	return v5
end

return useOnScreenKeyboardHeight
