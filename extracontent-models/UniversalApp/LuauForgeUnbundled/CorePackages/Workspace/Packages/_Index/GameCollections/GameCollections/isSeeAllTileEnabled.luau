local function isSeeAllTileEnabled(p2, p3, p4, p5, p6): boolean
	if p2 then
		return false
	end

	if p6 then
		return p3 ~= nil and not (p3 <= p4 or p5 <= p4)
	end

	return false
end

return isSeeAllTileEnabled
