local function getIsInstanceVisible(p2, p3, p4): boolean
	if not p2 then
		return false
	end

	local absoluteSize = p2.AbsoluteSize

	if absoluteSize.X <= 0 or absoluteSize.Y <= 0 then
		return false
	end

	local absolutePosition = p2.AbsolutePosition
	local v5 = absolutePosition + absoluteSize

	local v6 = math.max(absolutePosition.X, p3.min.X)
	local v7 = math.min(v5.X, p3.max.X) - v6

	if v7 <= 0 then
		return false
	end

	local v8 = math.max(absolutePosition.Y, p3.min.Y)
	local v9 = math.min(v5.Y, p3.max.Y) - v8

	if v9 <= 0 then
		return false
	end

	local v10 = v7 * v9
	local v11 = absoluteSize.X * absoluteSize.Y

	return p4 <= v10 * 100 / v11
end

return getIsInstanceVisible
