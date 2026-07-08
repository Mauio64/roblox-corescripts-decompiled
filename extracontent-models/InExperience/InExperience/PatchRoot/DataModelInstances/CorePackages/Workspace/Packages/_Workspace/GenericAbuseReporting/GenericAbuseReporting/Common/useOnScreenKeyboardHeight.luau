local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local React = require(Parent.React)
local UserInputService = game:GetService("UserInputService")

return function() -- line: 14
	-- upvalues: React (copy), UserInputService (copy)
	local v4, v5 = React.useState(false)
	local v6, v7 = React.useState(0)
	local v8, v9 = React.useState(0)

	React.useEffect(function() -- line: 19
		-- upvalues: UserInputService (copy), v5 (copy), v7 (copy), v9 (copy)
		local function updateKeyboardState() -- line: 20
			-- upvalues: UserInputService (copy), v5 (copy), v7 (copy), v9 (copy)
			local OnScreenKeyboardVisible = UserInputService.OnScreenKeyboardVisible
			local OnScreenKeyboardSizeY = UserInputService.OnScreenKeyboardSize.Y
			local OnScreenKeyboardPositionY = UserInputService.OnScreenKeyboardPosition.Y

			v5(OnScreenKeyboardVisible)
			v7(not OnScreenKeyboardVisible and 0 or OnScreenKeyboardSizeY)
			v9(not OnScreenKeyboardVisible and 0 or OnScreenKeyboardPositionY)
		end

		local OnScreenKeyboardVisible = UserInputService.OnScreenKeyboardVisible
		local OnScreenKeyboardSizeY = UserInputService.OnScreenKeyboardSize.Y
		local OnScreenKeyboardPositionY = UserInputService.OnScreenKeyboardPosition.Y

		v5(OnScreenKeyboardVisible)
		v7(not OnScreenKeyboardVisible and 0 or OnScreenKeyboardSizeY)
		v9(not OnScreenKeyboardVisible and 0 or OnScreenKeyboardPositionY)

		local connection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(updateKeyboardState)
		local connection2 = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardSize"):Connect(updateKeyboardState)
		local connection3 = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardPosition"):Connect(updateKeyboardState)

		return function() -- line: 38
			-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
			if connection then
				connection:Disconnect()
			end

			if connection2 then
				connection2:Disconnect()
			end

			if connection3 then
				connection3:Disconnect()
			end
		end
	end, {})

	return {
		isKeyboardShowing = v4,
		onScreenKeyboardHeight = v6,
		keyboardPositionY = v8
	}
end
