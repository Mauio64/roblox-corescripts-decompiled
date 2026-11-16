local ScrollPause = {}
ScrollPause.SETTLE_SECONDS = 0.15

function ScrollPause.initialState()
	return { canvasX = nil, canvasY = nil, idleSeconds = 0, interacting = false }
end

function ScrollPause.advance(data, canvasX: number, p: number, flag: boolean?, p2: number?)
	local canvasY = if p2 == nil then data.canvasY else p2

	if data.canvasX == nil then
		return { canvasX = canvasX, canvasY = canvasY, idleSeconds = 0.15, interacting = false }
	end

	local v

	if p2 == nil then
		v = false
	else
		v = p2 ~= data.canvasY
	end

	if canvasX ~= data.canvasX or v then
		return { canvasX = canvasX, canvasY = canvasY, idleSeconds = 0, interacting = true }
	end

	if flag == true then
		return {
			canvasX = canvasX,
			canvasY = canvasY,
			idleSeconds = data.idleSeconds + math.max(p, 0),
			interacting = true
		}
	end

	if not data.interacting then
		return data
	end

	local idleSeconds = data.idleSeconds + math.max(p, 0)
	return {
		canvasX = canvasX,
		canvasY = canvasY,
		idleSeconds = idleSeconds,
		interacting = idleSeconds < 0.15
	}
end

function ScrollPause.isPointerHold(p): boolean
	return p == Enum.UserInputType.MouseButton1 or p == Enum.UserInputType.Touch
end

function ScrollPause.pointerIsInside(vector2: Vector2, vector2_2: Vector2, vector2_3: Vector2): boolean
	if vector2_2.X <= 0 or vector2_2.Y <= 0 then
		return false
	end

	return vector2_3.X >= vector2.X
		and vector2_3.Y >= vector2.Y
		and vector2_3.X <= vector2.X + vector2_2.X
		and vector2_3.Y <= vector2.Y + vector2_2.Y
end

return ScrollPause
