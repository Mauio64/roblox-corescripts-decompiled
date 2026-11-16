local function step(p, _, _)
	return { value = p.__targetValue, complete = true }
end

local function instant(targetValue)
	return { __targetValue = targetValue, step = step }
end

return instant
