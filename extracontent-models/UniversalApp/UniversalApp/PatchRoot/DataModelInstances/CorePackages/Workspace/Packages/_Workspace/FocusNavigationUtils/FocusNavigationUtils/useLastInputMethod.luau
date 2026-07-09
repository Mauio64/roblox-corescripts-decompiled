local UserInputService = game:GetService("UserInputService")
local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local t1 = {
	[Enum.UserInputType.MouseButton1] = "Mouse",
	[Enum.UserInputType.MouseButton2] = "Mouse",
	[Enum.UserInputType.MouseButton3] = "Mouse",
	[Enum.UserInputType.MouseWheel] = "Mouse",
	[Enum.UserInputType.MouseMovement] = "Mouse",
	[Enum.UserInputType.Touch] = "Touch",
	[Enum.UserInputType.Keyboard] = "Keyboard",
	[Enum.UserInputType.Focus] = nil,
	[Enum.UserInputType.Accelerometer] = nil,
	[Enum.UserInputType.Gyro] = nil,
	[Enum.UserInputType.Gamepad1] = "Gamepad",
	[Enum.UserInputType.Gamepad2] = "Gamepad",
	[Enum.UserInputType.Gamepad3] = "Gamepad",
	[Enum.UserInputType.Gamepad4] = "Gamepad",
	[Enum.UserInputType.Gamepad5] = "Gamepad",
	[Enum.UserInputType.Gamepad6] = "Gamepad",
	[Enum.UserInputType.Gamepad7] = "Gamepad",
	[Enum.UserInputType.Gamepad8] = "Gamepad",
	[Enum.UserInputType.TextInput] = nil,
	[Enum.UserInputType.InputMethod] = nil,
	[Enum.UserInputType.None] = nil
}

local function useLastInputMethod() -- line: 43
	-- upvalues: t1 (copy), UserInputService (copy), React (copy)
	local v6 = t1[UserInputService:GetLastInputType()] or "None"
	local v7, v8 = React.useState(v6)

	React.useEffect(function() -- line: 46
		-- upvalues: UserInputService (copy), t1 (copy), v8 (copy)
		local connection = UserInputService.LastInputTypeChanged:Connect(function(p1) -- line: 47
			-- upvalues: t1 (copy), v8 (copy)
			local v11 = t1[p1]

			if v11 then
				v8(v11)
			end
		end)

		return function() -- line: 54
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	return v7
end

return useLastInputMethod
