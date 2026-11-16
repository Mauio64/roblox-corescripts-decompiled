local function clampAxis(value: number, min: number, max: number) -- 2 equivalent calls inferred from this helper
	if max <= min then
		return (min + max) / 2
	end

	return (math.clamp(value, min, max))
end

local Geometry = {}

function Geometry.hasPositiveSize(vector2: Vector2): boolean
	return vector2.X > 0 and vector2.Y > 0
end

function Geometry.resolveCenter(udim: UDim2, vector2: Vector2)
	return Vector2.new(udim.X.Scale * vector2.X + udim.X.Offset, udim.Y.Scale * vector2.Y + udim.Y.Offset)
end

function Geometry.clampCenter(vector2: Vector2, vector2_2: Vector2, vector2_3: Vector2)
	local halfVector2_3 = vector2_3 / 2
	return Vector2.new(
		clampAxis(vector2.X, halfVector2_3.X, vector2_2.X - halfVector2_3.X), -- inferred equivalent call
		clampAxis(vector2.Y, halfVector2_3.Y, vector2_2.Y - halfVector2_3.Y) -- inferred equivalent call
	)
end

return Geometry
