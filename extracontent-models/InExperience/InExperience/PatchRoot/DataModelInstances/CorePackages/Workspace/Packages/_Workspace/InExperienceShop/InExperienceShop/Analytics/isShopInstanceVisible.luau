local function isShopInstanceVisible(p, p2)
	local v = p2.max - p2.min

	if v.X <= 0 or v.Y <= 0 then
		return false
	end

	local v2 = p.AbsolutePosition + p.AbsoluteSize / 2
	local v3

	if v2.X > p2.min.X then
		v3 = v2.X < p2.max.X
	else
		v3 = false
	end

	local v4 = v2.Y > p2.min.Y and v2.Y < p2.max.Y

	return v3 and v4
end

return isShopInstanceVisible
