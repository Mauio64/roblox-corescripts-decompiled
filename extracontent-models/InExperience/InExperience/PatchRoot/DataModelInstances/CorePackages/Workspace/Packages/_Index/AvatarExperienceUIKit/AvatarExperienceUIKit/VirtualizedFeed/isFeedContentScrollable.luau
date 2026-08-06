local function isFeedContentScrollable(n1: number, n2: number, n3: number) -- line: 13
	local v5 = n2 - n3 * 2

	return n1 > 0 and (v5 > 0 and v5 < n1)
end

return isFeedContentScrollable
