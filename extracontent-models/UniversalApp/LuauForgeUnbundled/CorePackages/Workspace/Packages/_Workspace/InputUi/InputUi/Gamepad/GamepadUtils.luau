local defineFastFlag = game:DefineFastFlag("AXSetAngularVelocityIsOptional", false)

local v5 = {}

function v5.normalizeStickByDeadzone(p2, value)
	local magnitude = p2.Magnitude
	local v6 = value or 0.2

	if magnitude < v6 then
		return Vector2.new(0, 0)
	end

	return (magnitude - v6) / (1 - v6) * p2.Unit
end

function v5.rotateAndZoom(p2, p3, callback, callback2, callback3)
	local stickByDeadzone = v5.normalizeStickByDeadzone(Vector2.new(p2.Position.X, p2.Position.Y))

	if stickByDeadzone == Vector2.new(0, 0) then
		return
	end

	if defineFastFlag then
		if callback then
			callback(0)
		end
	else
		callback(0)
	end

	if callback2 and math.abs(stickByDeadzone.X) > 0.5 then
		callback2(p3 * stickByDeadzone.X * 2.0943951023931953)
	end

	if callback3 and math.abs(stickByDeadzone.Y) > 0.5 then
		callback3(p3 * -stickByDeadzone.Y * 10)
	end
end

function v5.mapPositionToDirection(p2)
	local stickByDeadzone = v5.normalizeStickByDeadzone(p2)
	local x = stickByDeadzone.X
	local y = stickByDeadzone.Y

	if not (x * x + y * y > 0.25) then
		return nil
	end

	local v6 = math.atan2(y, x)

	if v6 > -2.356194490192345 and v6 <= -0.7853981633974483 then
		return Enum.KeyCode.Down
	end

	if v6 > -0.7853981633974483 and v6 <= 0.7853981633974483 then
		return Enum.KeyCode.Right
	end

	if v6 > 0.7853981633974483 and v6 <= 2.356194490192345 then
		return Enum.KeyCode.Up
	end

	if v6 > 2.356194490192345 or v6 <= -2.356194490192345 then
		return Enum.KeyCode.Left
	end

	return nil
end

return v5
