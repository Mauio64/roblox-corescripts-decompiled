local function isSeeAllTileEnabled(b1: boolean?, n1: number?, n2: number, n3: number, p1: ((...any) -> ...any)?) -- line: 4
	if b1 then
		return false
	end

	if not p1 then
		return false
	end

	if n1 == nil or n1 <= n2 or n3 <= n2 then
		return false
	end

	return true
end

return isSeeAllTileEnabled
