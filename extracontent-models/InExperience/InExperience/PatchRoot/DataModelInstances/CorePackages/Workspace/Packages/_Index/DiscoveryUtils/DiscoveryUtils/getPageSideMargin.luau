local function getPageSideMargin(p): number
	if p > 600 then
		return 48
	end

	return if p > 320 then 24 else 12
end

return getPageSideMargin
