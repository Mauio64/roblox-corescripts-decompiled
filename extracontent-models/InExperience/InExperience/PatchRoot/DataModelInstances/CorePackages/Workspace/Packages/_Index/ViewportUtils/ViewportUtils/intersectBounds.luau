local v1 = table.freeze({
	min = Vector2.zero,
	max = Vector2.zero
})

local function intersectBounds(t1: {[any]: any}, t2: {[any]: any}) -- line: 8
	-- upvalues: v1 (copy)
	local t3 = {
		min = Vector2.new(math.max(t1.min.X, t2.min.X), (math.max(t1.min.Y, t2.min.Y))),
		max = Vector2.new(math.min(t1.max.X, t2.max.X), (math.min(t1.max.Y, t2.max.Y)))
	}

	if t3.min.X >= t3.max.X then
		return v1
	end

	if t3.min.Y >= t3.max.Y then
		return v1
	end

	return t3
end

return intersectBounds
