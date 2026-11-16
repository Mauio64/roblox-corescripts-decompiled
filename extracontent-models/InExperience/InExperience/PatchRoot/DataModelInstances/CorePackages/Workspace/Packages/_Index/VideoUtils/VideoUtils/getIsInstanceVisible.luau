local function getIsInstanceVisible(p, p2, p3: number): boolean
	if not p then
		return false
	end

	local absoluteSize = p.AbsoluteSize

	if absoluteSize.X <= 0 or absoluteSize.Y <= 0 then
		return false
	end

	local absolutePosition = p.AbsolutePosition
	local v = absolutePosition + absoluteSize

	local v2 = math.max(absolutePosition.X, p2.min.X)
	local v3 = math.min(v.X, p2.max.X) - v2

	if v3 <= 0 then
		return false
	end

	local v4 = math.max(absolutePosition.Y, p2.min.Y)
	local v5 = math.min(v.Y, p2.max.Y) - v4

	if v5 <= 0 then
		return false
	end

	local v6 = v3 * v5
	local v7 = absoluteSize.X * absoluteSize.Y

	return p3 <= v6 * 100 / v7
end

return getIsInstanceVisible
