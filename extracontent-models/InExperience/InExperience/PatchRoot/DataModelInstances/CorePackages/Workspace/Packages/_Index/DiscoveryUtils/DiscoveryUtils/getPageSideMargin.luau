local function getPageSideMargin(p1) -- line: 1
	if p1 > 600 then
		return 48
	end

	if p1 > 320 then
		return 24
	end

	return 12
end

return getPageSideMargin
