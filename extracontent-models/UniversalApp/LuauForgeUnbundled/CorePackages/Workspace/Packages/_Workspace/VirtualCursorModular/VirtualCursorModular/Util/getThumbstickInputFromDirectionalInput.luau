require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursorModular/VirtualCursorModular/Properties")

local function getThumbstickInputFromDirectionalInput(p2, p3)
	local v5 = Vector2.zero

	if p2 == Enum.KeyCode.ButtonUp then
		return (Vector2.new(0, p3))
	end

	if p2 == Enum.KeyCode.ButtonDown then
		return (Vector2.new(0, -p3))
	end

	if p2 == Enum.KeyCode.ButtonLeft then
		return (Vector2.new(-p3, 0))
	end

	if p2 == Enum.KeyCode.ButtonRight then
		v5 = Vector2.new(p3, 0)
	end

	return v5
end

return getThumbstickInputFromDirectionalInput
