local function lerp(p, p2, p3)
	return p * (1 - p3) + p2 * p3
end

return lerp
