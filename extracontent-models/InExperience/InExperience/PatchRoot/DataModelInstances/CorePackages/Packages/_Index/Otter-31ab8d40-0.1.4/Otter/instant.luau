local function step(p1, _, _) -- line: 1
	return {
		complete = true,
		value = p1.__targetValue
	}
end
local function instant(p4) -- line: 8
	-- upvalues: step (copy)
	return {
		__targetValue = p4,
		step = step
	}
end

return instant
