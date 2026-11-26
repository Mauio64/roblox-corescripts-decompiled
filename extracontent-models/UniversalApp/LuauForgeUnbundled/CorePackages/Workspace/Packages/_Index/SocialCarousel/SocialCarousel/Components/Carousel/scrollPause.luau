return {
	SETTLE_SECONDS = 0.15,
	initialState = function()
		return { canvasX = nil, canvasY = nil, idleSeconds = 0, interacting = false }
	end,
	advance = function(data, p2, p3, p4, p5)
		local v5 = if p5 == nil then data.canvasY else p5

		if data.canvasX == nil then
			return {
				canvasX = p2,
				canvasY = v5,
				idleSeconds = 0.15,
				interacting = false
			}
		end

		local v6 = not (p5 == nil) and p5 ~= data.canvasY

		if p2 ~= data.canvasX or v6 then
			return { canvasX = p2, canvasY = v5, idleSeconds = 0, interacting = true }
		end

		if p4 == true then
			return {
				canvasX = p2,
				canvasY = v5,
				idleSeconds = data.idleSeconds + math.max(p3, 0),
				interacting = true
			}
		end

		if not data.interacting then
			return data
		end

		local v7 = data.idleSeconds + math.max(p3, 0)
		return {
			canvasX = p2,
			canvasY = v5,
			idleSeconds = v7,
			interacting = v7 < 0.15
		}
	end,
	isPointerHold = function(p2): boolean
		return p2 == Enum.UserInputType.MouseButton1 or p2 == Enum.UserInputType.Touch
	end,
	pointerIsInside = function(p2, p3, p4): boolean
		if p3.X <= 0 or p3.Y <= 0 then
			return false
		end

		return p4.X >= p2.X and p4.Y >= p2.Y and p4.X <= p2.X + p3.X and p4.Y <= p2.Y + p3.Y
	end
}
