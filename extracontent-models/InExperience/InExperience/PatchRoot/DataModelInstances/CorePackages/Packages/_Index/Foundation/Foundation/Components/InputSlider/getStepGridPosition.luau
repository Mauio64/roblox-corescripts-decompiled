local function getStepGridPosition(p: number, p2: number, range: NumberRange)
	local v = (p - range.Min) / p2
	local v2 = math.round(v)
	return if math.abs(v - v2) < 1e-9 then v2 else v
end

return getStepGridPosition
