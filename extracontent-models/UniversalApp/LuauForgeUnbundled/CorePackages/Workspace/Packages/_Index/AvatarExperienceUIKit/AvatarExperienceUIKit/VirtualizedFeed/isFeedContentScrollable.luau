local function isFeedContentScrollable(p2, p3, p4): boolean
	local v5 = p3 - p4 * 2
	return p2 > 0 and v5 > 0 and v5 < p2
end

return isFeedContentScrollable
