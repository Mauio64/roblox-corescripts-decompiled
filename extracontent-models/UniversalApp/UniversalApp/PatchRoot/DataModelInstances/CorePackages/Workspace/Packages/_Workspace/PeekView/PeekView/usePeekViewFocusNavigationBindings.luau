local Parent = script:FindFirstAncestor("PeekView").Parent
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local React = require(Parent.React)

local function usePeekViewFocusNavigationBindings(p1) -- line: 7
	-- upvalues: React (copy), RunService (copy), UserInputService (copy)
	React.useEffect(function() -- line: 8
		-- upvalues: RunService (copy), p1 (copy), UserInputService (copy)
		local u7 = nil
		local connection = RunService.Heartbeat:Connect(function(dt) -- line: 10
			-- upvalues: u7 (ref), p1 (copy)
			if u7 and u7.KeyCode == Enum.KeyCode.Thumbstick2 then
				p1(u7, dt)
			end
		end)
		local connection2 = UserInputService.InputChanged:Connect(function(input, _) -- line: 15
			-- upvalues: u7 (ref)
			if input.KeyCode == Enum.KeyCode.Thumbstick2 then
				if input.UserInputState == Enum.UserInputState.Change then
					u7 = input

					return
				end

				if input.UserInputState == Enum.UserInputState.End then
					u7 = nil
				end
			end
		end)

		return function() -- line: 25
			-- upvalues: connection (copy), connection2 (copy)
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, { p1 })
end

return usePeekViewFocusNavigationBindings
