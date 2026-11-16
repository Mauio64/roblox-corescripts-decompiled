local function isFeedContentScrollable(p: number, p2: number, p3: number): boolean
	local v = p2 - p3 * 2
	return p > 0 and v > 0 and v < p
end

return isFeedContentScrollable
