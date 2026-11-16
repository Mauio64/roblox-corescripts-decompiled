local Properties = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursorModular/VirtualCursorModular/Properties")

local function processThumbstickInput(data)
	local v5, v6

	if data.Magnitude >= Properties.ThumbstickDeadzone then
		local v7 = math.atan2(data.Y, data.X)
		local v8 = math.abs(math.cos(v7) * Properties.ThumbstickDeadzone)
		local v9 = math.abs(math.sin(v7) * Properties.ThumbstickDeadzone)

		v5 = math.max(math.abs(data.X) - v8, 0) / (1 - v8) * math.sign(data.X)
		v6 = math.max(math.abs(data.Y) - v9, 0) / (1 - v9) * math.sign(data.Y)
	else
		v5 = 0
		v6 = 0
	end

	return Vector2.new(v5, -v6)
end

return processThumbstickInput
