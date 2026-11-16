local parent = script.Parent.Parent

local Properties = require(parent.Properties)

local function processThumbstickInput(vector2: Vector2)
	local v, v2

	if vector2.Magnitude >= Properties.ThumbstickDeadzone then
		local v3 = math.atan2(vector2.Y, vector2.X)
		local v4 = math.abs(math.cos(v3) * Properties.ThumbstickDeadzone)
		local v5 = math.abs(math.sin(v3) * Properties.ThumbstickDeadzone)

		v = math.max(math.abs(vector2.X) - v4, 0) / (1 - v4) * math.sign(vector2.X)
		v2 = math.max(math.abs(vector2.Y) - v5, 0) / (1 - v5) * math.sign(vector2.Y)
	else
		v = 0
		v2 = 0
	end

	return Vector2.new(v, -v2)
end

return processThumbstickInput
