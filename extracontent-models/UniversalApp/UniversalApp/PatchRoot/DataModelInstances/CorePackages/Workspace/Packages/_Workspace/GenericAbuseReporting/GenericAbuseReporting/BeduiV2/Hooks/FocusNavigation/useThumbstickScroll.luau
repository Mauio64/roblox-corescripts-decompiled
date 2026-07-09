local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local React = require(Parent.React)
local scrollFrameUtils = require(script.Parent.scrollFrameUtils)

local function useThumbstickScroll(t1: {[any]: any}) -- line: 22
	-- upvalues: React (copy), RunService (copy), GuiService (copy), scrollFrameUtils (copy), UserInputService (copy)
	React.useEffect(function() -- line: 23
		-- upvalues: t1 (copy), RunService (copy), GuiService (copy), scrollFrameUtils (copy), UserInputService (copy)
		if not t1.enabled then
			return
		end

		local u9 = nil
		local connection = RunService.Heartbeat:Connect(function(dt) -- line: 30
			-- upvalues: u9 (ref), t1 (copy), GuiService (copy), scrollFrameUtils (copy)
			if u9 == nil or u9.KeyCode ~= Enum.KeyCode.Thumbstick2 then
				return
			end

			local current = t1.containerRef.current

			if current == nil then
				return
			end

			local SelectedCoreObject = GuiService.SelectedCoreObject
			local v15 = scrollFrameUtils.resolveScrollTarget(SelectedCoreObject, current)

			if v15 == nil then
				return
			end

			scrollFrameUtils.scrollByAnalogInput(v15, u9, dt)
		end)
		local connection2 = UserInputService.InputChanged:Connect(function(input, _) -- line: 50
			-- upvalues: u9 (ref)
			if input.KeyCode ~= Enum.KeyCode.Thumbstick2 then
				return
			end

			if input.UserInputState == Enum.UserInputState.Change then
				u9 = input

				return
			end

			if input.UserInputState == Enum.UserInputState.End then
				u9 = nil
			end
		end)

		return function() -- line: 62
			-- upvalues: connection (copy), connection2 (copy)
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, {
		t1.enabled,
		t1.containerRef
	})
end

return useThumbstickScroll
