local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local React = require(parent.React)

local scrollFrameUtils = require(script.Parent.scrollFrameUtils)

local function useThumbstickScroll(p)
	React.useEffect(function()
		if not p.enabled then
			return
		end

		local v = nil

		local heartbeatConnection = RunService.Heartbeat:Connect(function(dt)
			if v == nil or v.KeyCode ~= Enum.KeyCode.Thumbstick2 then
				return
			end

			local current = p.containerRef.current

			if current == nil then
				return
			end

			local selectedCoreObject = GuiService.SelectedCoreObject
			local scrollTarget = scrollFrameUtils.resolveScrollTarget(selectedCoreObject, current)

			if scrollTarget == nil then
				return
			end

			scrollFrameUtils.scrollByAnalogInput(scrollTarget, v, dt)
		end)

		local inputChangedConnection = UserInputService.InputChanged:Connect(function(input, _)
			if input.KeyCode ~= Enum.KeyCode.Thumbstick2 then
				return
			end

			if input.UserInputState == Enum.UserInputState.Change then
				v = input
			elseif input.UserInputState == Enum.UserInputState.End then
				v = nil
			end
		end)

		return function()
			heartbeatConnection:Disconnect()
			inputChangedConnection:Disconnect()
		end
	end, { p.enabled, p.containerRef })
end

return useThumbstickScroll
