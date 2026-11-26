local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/React")

local function usePeekViewFocusNavigationBindings(callback)
	React.useEffect(function()
		local v5 = nil
		local heartbeatConnection = RunService.Heartbeat:Connect(function(dt)
			if v5 and v5.KeyCode == Enum.KeyCode.Thumbstick2 then
				callback(v5, dt)
			end
		end)
		local inputChangedConnection = UserInputService.InputChanged:Connect(function(input, gameProcessed)
			if input.KeyCode == Enum.KeyCode.Thumbstick2 then
				if input.UserInputState == Enum.UserInputState.Change then
					v5 = input
				elseif input.UserInputState == Enum.UserInputState.End then
					v5 = nil
				end
			end
		end)

		return function()
			heartbeatConnection:Disconnect()
			inputChangedConnection:Disconnect()
		end
	end, { callback })
end

return usePeekViewFocusNavigationBindings
