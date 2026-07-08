local function lerp(p1, p2, p3) -- line: 2
	return p1 * (1 - p3) + p2 * p3
end

return lerp
