local VRService = game:GetService("VRService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/React")
local useExternalEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactUtils/Hooks/useExternalEvent")

local v5 = { Right = "Right", Left = "Left" }

local function useLaserPointerHand()
	local state, setState = React.useState("Right")

	local v6 = React.useCallback(function(p2)
		if
			(p2.KeyCode == Enum.KeyCode.ButtonR1 or p2.KeyCode == Enum.KeyCode.ButtonR2 or p2.KeyCode == Enum.KeyCode.ButtonR3 or p2.KeyCode == Enum.KeyCode.ButtonA or p2.KeyCode == Enum.KeyCode.ButtonB)
			and state ~= "Right"
		then
			setState("Right")
		elseif
			(p2.KeyCode == Enum.KeyCode.ButtonL1 or p2.KeyCode == Enum.KeyCode.ButtonL2 or p2.KeyCode == Enum.KeyCode.ButtonL3 or p2.KeyCode == Enum.KeyCode.ButtonX or p2.KeyCode == Enum.KeyCode.ButtonY)
			and state ~= "Left"
		then
			setState("Left")
		end
	end)

	useExternalEvent(VRService.LaserPointerTriggered, v6)

	return state
end

return useLaserPointerHand
