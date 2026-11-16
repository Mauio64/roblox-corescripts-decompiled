local function getPageSideMargin(p2): number
	if p2 > 600 then
		return 48
	end

	if p2 > 320 then
		return 24
	end

	return 12
end

return getPageSideMargin
