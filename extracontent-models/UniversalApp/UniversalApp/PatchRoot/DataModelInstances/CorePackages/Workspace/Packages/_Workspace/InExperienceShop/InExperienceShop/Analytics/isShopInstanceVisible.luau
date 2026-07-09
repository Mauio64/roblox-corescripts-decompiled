local function isShopInstanceVisible(p1, t1: {[any]: any}) -- line: 6
	local v4 = t1.max - t1.min

	if v4.X <= 0 or v4.Y <= 0 then
		return false
	end

	local v5 = p1.AbsolutePosition + p1.AbsoluteSize / 2
	local v6 = v5.X > t1.min.X and v5.X < t1.max.X
	local v7 = v5.Y > t1.min.Y and v5.Y < t1.max.Y

	return v6 and v7
end

return isShopInstanceVisible
