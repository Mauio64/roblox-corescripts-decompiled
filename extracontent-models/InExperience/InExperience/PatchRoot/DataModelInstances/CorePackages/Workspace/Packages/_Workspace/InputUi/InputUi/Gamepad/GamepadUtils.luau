local defineFastFlag = game:DefineFastFlag("AXSetAngularVelocityIsOptional", false)

local GamepadUtils = {}

function GamepadUtils.normalizeStickByDeadzone(vector2: Vector2, value: number?)
	local magnitude = vector2.Magnitude
	local v = value or 0.2

	if magnitude < v then
		return Vector2.new(0, 0)
	end

	return (magnitude - v) / (1 - v) * vector2.Unit
end

function GamepadUtils.rotateAndZoom(p, p2: number, callback, callback2, callback3)
	local stickByDeadzone = GamepadUtils.normalizeStickByDeadzone(Vector2.new(p.Position.X, p.Position.Y))

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
		callback2(p2 * stickByDeadzone.X * 2.0943951023931953)
	end

	if callback3 and math.abs(stickByDeadzone.Y) > 0.5 then
		callback3(p2 * -stickByDeadzone.Y * 10)
	end
end

function GamepadUtils.mapPositionToDirection(vector2: Vector2)
	local stickByDeadzone = GamepadUtils.normalizeStickByDeadzone(vector2)
	local x = stickByDeadzone.X
	local y = stickByDeadzone.Y

	if not (x * x + y * y > 0.25) then
		return nil
	end

	local v = math.atan2(y, x)

	if v > -2.356194490192345 and v <= -0.7853981633974483 then
		return Enum.KeyCode.Down
	end

	if v > -0.7853981633974483 and v <= 0.7853981633974483 then
		return Enum.KeyCode.Right
	end

	if v > 0.7853981633974483 and v <= 2.356194490192345 then
		return Enum.KeyCode.Up
	end

	if v > 2.356194490192345 or v <= -2.356194490192345 then
		return Enum.KeyCode.Left
	end

	return nil
end

return GamepadUtils
