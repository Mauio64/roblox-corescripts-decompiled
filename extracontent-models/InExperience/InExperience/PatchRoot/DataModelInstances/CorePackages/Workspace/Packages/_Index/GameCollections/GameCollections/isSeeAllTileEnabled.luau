local function isSeeAllTileEnabled(flag: boolean?, p: number?, p2: number, p3: number, callback): boolean
	if flag then
		return false
	end

	if callback then
		return p ~= nil and not (p <= p2 or p3 <= p2)
	end

	return false
end

return isSeeAllTileEnabled
