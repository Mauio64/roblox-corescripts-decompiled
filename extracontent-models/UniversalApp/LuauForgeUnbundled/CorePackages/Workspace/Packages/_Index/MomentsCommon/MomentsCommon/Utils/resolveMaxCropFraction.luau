local function isLandscape(p2): boolean
	return p2.X > p2.Y
end

local function resolveMaxCropFraction(p2, p3, p4, p5)
	if p3 == nil or p2.X == 0 or p2.Y == 0 then
		return 0
	end

	local v5 = p3.X > p3.Y

	if v5 ~= (p2.X > p2.Y) or v5 and not p5 then
		return 0
	end

	return p4
end

return resolveMaxCropFraction
