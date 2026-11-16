local parent = script:FindFirstAncestor("PeekView").Parent
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local React = require(parent.React)

local function usePeekViewFocusNavigationBindings(callback)
	React.useEffect(function()
		local v = nil
		local heartbeatConnection = RunService.Heartbeat:Connect(function(dt)
			if v and v.KeyCode == Enum.KeyCode.Thumbstick2 then
				callback(v, dt)
			end
		end)
		local inputChangedConnection = UserInputService.InputChanged:Connect(function(input, _)
			if input.KeyCode == Enum.KeyCode.Thumbstick2 then
				if input.UserInputState == Enum.UserInputState.Change then
					v = input
				elseif input.UserInputState == Enum.UserInputState.End then
					v = nil
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
