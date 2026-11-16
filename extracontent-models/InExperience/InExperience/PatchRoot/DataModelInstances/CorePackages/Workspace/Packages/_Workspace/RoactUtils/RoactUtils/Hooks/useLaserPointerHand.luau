local VRService = game:GetService("VRService")

local parent = script:FindFirstAncestor("RoactUtils").Parent

local React = require(parent.React)
local useExternalEvent = require(script.Parent.useExternalEvent)

local _ = { Right = "Right", Left = "Left" }

local function useLaserPointerHand()
	local state, setState = React.useState("Right")

	local v = React.useCallback(function(p)
		if
			(p.KeyCode == Enum.KeyCode.ButtonR1 or p.KeyCode == Enum.KeyCode.ButtonR2 or p.KeyCode == Enum.KeyCode.ButtonR3 or p.KeyCode == Enum.KeyCode.ButtonA or p.KeyCode == Enum.KeyCode.ButtonB)
			and state ~= "Right"
		then
			setState("Right")
		elseif
			(p.KeyCode == Enum.KeyCode.ButtonL1 or p.KeyCode == Enum.KeyCode.ButtonL2 or p.KeyCode == Enum.KeyCode.ButtonL3 or p.KeyCode == Enum.KeyCode.ButtonX or p.KeyCode == Enum.KeyCode.ButtonY)
			and state ~= "Left"
		then
			setState("Left")
		end
	end)

	useExternalEvent(VRService.LaserPointerTriggered, v)

	return state
end

return useLaserPointerHand
