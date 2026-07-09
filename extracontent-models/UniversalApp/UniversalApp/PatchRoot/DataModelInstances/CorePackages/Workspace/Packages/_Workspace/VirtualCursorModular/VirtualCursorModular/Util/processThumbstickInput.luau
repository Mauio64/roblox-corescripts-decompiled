local ParentParent = script.Parent.Parent
local Properties = require(ParentParent.Properties)

local function processThumbstickInput(vector2: Vector2) -- line: 7
	-- upvalues: Properties (copy)
	local n1 = 0
	local n2 = 0

	if vector2.Magnitude >= Properties.ThumbstickDeadzone then
		local v7 = math.atan2(vector2.Y, vector2.X)
		local v8 = math.abs(math.cos(v7) * Properties.ThumbstickDeadzone)
		local v9 = math.abs(math.sin(v7) * Properties.ThumbstickDeadzone)

		n1 = math.max(math.abs(vector2.X) - v8, 0) / (1 - v8) * math.sign(vector2.X)
		n2 = math.max(math.abs(vector2.Y) - v9, 0) / (1 - v9) * math.sign(vector2.Y)
	end

	return Vector2.new(n1, -n2)
end

return processThumbstickInput
