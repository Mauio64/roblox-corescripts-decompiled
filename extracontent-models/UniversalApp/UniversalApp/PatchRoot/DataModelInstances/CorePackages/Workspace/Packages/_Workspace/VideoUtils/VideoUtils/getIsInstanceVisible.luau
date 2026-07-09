local function getIsInstanceVisible(p1, p2, n1: number) -- line: 1
	if not p1 then
		return false
	end

	local AbsoluteSize = p1.AbsoluteSize

	if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
		return false
	end

	local AbsolutePosition = p1.AbsolutePosition
	local v7 = AbsolutePosition + AbsoluteSize
	local v8 = math.max(AbsolutePosition.X, p2.min.X)
	local v9 = math.min(v7.X, p2.max.X) - v8

	if v9 <= 0 then
		return false
	end

	local v10 = math.max(AbsolutePosition.Y, p2.min.Y)
	local v11 = math.min(v7.Y, p2.max.Y) - v10

	if v11 <= 0 then
		return false
	end

	local v12 = v9 * v11
	local v13 = AbsoluteSize.X * AbsoluteSize.Y

	return n1 <= v12 * 100 / v13
end

return getIsInstanceVisible
