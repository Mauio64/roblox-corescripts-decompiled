local v1 = game:DefineFastFlag("AXSetAngularVelocityIsOptional", false)
local t1 = {
	normalizeStickByDeadzone = function(vector2: Vector2, n1: number?) -- line: 18
		local Magnitude = vector2.Magnitude
		local v6 = n1 or 0.2

		if Magnitude < v6 then
			return Vector2.new(0, 0)
		end

		return (Magnitude - v6) / (1 - v6) * vector2.Unit
	end
}

function t1.rotateAndZoom(p1, n2: number, p2: ((...any) -> ...any)?, p3: ((...any) -> ...any)?, p4: ((...any) -> ...any)?) -- line: 28
	-- upvalues: t1 (copy), v1 (copy)
	local v12 = t1.normalizeStickByDeadzone(Vector2.new(p1.Position.X, p1.Position.Y))

	if v12 == Vector2.new(0, 0) then
		return
	end

	if v1 then
		if p2 then
			p2(0)
		end
	else
		p2(0)
	end

	if p3 and math.abs(v12.X) > 0.5 then
		p3(n2 * v12.X * 2.0943951023931953)
	end

	if p4 and math.abs(v12.Y) > 0.5 then
		p4(n2 * -v12.Y * 10)
	end
end
function t1.mapPositionToDirection(vector2: Vector2) -- line: 56
	-- upvalues: t1 (copy)
	local v14 = t1.normalizeStickByDeadzone(vector2)
	local X = v14.X
	local Y = v14.Y

	if X * X + Y * Y > 0.25 then
		local v17 = math.atan2(Y, X)

		if v17 > -2.356194490192345 and v17 <= -0.7853981633974483 then
			return Enum.KeyCode.Down
		end

		if v17 > -0.7853981633974483 and v17 <= 0.7853981633974483 then
			return Enum.KeyCode.Right
		end

		if v17 > 0.7853981633974483 and v17 <= 2.356194490192345 then
			return Enum.KeyCode.Up
		end

		if v17 > 2.356194490192345 or v17 <= -2.356194490192345 then
			return Enum.KeyCode.Left
		end
	end

	return nil
end

return t1
