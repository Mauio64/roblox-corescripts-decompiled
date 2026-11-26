local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local scrollFrameUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/FocusNavigation/scrollFrameUtils")

local function useThumbstickScroll(p2)
	React.useEffect(function()
		if not p2.enabled then
			return
		end

		local v5 = nil

		local heartbeatConnection = RunService.Heartbeat:Connect(function(dt)
			if v5 == nil or v5.KeyCode ~= Enum.KeyCode.Thumbstick2 then
				return
			end

			local current = p2.containerRef.current

			if current == nil then
				return
			end

			local selectedCoreObject = GuiService.SelectedCoreObject
			local scrollTarget = scrollFrameUtils.resolveScrollTarget(selectedCoreObject, current)

			if scrollTarget == nil then
				return
			end

			scrollFrameUtils.scrollByAnalogInput(scrollTarget, v5, dt)
		end)

		local inputChangedConnection = UserInputService.InputChanged:Connect(function(input, gameProcessed)
			if input.KeyCode ~= Enum.KeyCode.Thumbstick2 then
				return
			end

			if input.UserInputState == Enum.UserInputState.Change then
				v5 = input
			elseif input.UserInputState == Enum.UserInputState.End then
				v5 = nil
			end
		end)

		return function()
			heartbeatConnection:Disconnect()
			inputChangedConnection:Disconnect()
		end
	end, { p2.enabled, p2.containerRef })
end

return useThumbstickScroll
