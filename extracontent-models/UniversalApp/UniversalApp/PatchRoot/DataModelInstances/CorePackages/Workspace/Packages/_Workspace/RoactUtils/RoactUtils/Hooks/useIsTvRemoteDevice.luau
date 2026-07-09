local Parent = script:FindFirstAncestor("RoactUtils").Parent
local UserInputService = game:GetService("UserInputService")
local React = require(Parent.React)

local function useIsTvRemoteDevice() -- line: 20
	-- upvalues: React (copy), UserInputService (copy)
	local v5 = React.useCallback(function() -- line: 21
		-- upvalues: UserInputService (copy)
		if UserInputService.PreferredInput ~= Enum.PreferredInput.Gamepad then
			return false
		end

		for _, v in ipairs(UserInputService:GetConnectedGamepads()) do
			if UserInputService:GamepadSupports(v, Enum.KeyCode.Return) then
				return true
			end
		end

		return false
	end, {})
	local v6, v7 = React.useState(function() -- line: 35
		-- upvalues: v5 (copy)
		return v5()
	end)

	React.useEffect(function() -- line: 39
		-- upvalues: UserInputService (copy), v7 (copy), v5 (copy)
		local connection = UserInputService.GamepadConnected:Connect(function() -- line: 40
			-- upvalues: v7 (copy), v5 (copy)
			v7(v5())
		end)
		local connection2 = UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 44
			-- upvalues: v7 (copy), v5 (copy)
			v7(v5())
		end)

		v7(v5())

		return function() -- line: 50
			-- upvalues: connection (copy), connection2 (copy)
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, { v5 })

	return v6
end

return useIsTvRemoteDevice
