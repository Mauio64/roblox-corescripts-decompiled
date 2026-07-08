local VRService = game:GetService("VRService")
local Parent = script:FindFirstAncestor("RoactUtils").Parent
local React = require(Parent.React)
local useExternalEvent = require(script.Parent.useExternalEvent)
local _ = {
	Right = "Right",
	Left = "Left"
}

local function useLaserPointerHand() -- line: 19
	-- upvalues: React (copy), useExternalEvent (copy), VRService (copy)
	local v7, v8 = React.useState("Right")
	local v9 = React.useCallback(function(p1) -- line: 22
		-- upvalues: v7 (copy), v8 (copy)
		if (p1.KeyCode == Enum.KeyCode.ButtonR1 or (p1.KeyCode == Enum.KeyCode.ButtonR2 or p1.KeyCode == Enum.KeyCode.ButtonR3 or p1.KeyCode == Enum.KeyCode.ButtonA or p1.KeyCode == Enum.KeyCode.ButtonB)) and v7 ~= "Right" then
			v8("Right")

			return
		end

		if (p1.KeyCode == Enum.KeyCode.ButtonL1 or p1.KeyCode == Enum.KeyCode.ButtonL2 or p1.KeyCode == Enum.KeyCode.ButtonL3 or p1.KeyCode == Enum.KeyCode.ButtonX or p1.KeyCode == Enum.KeyCode.ButtonY) and v7 ~= "Left" then
			v8("Left")
		end
	end)

	useExternalEvent(VRService.LaserPointerTriggered, v9)

	return v7
end

return useLaserPointerHand
