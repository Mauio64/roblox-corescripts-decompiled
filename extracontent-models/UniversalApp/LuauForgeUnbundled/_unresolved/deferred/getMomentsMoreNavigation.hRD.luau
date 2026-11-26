local function getMomentsMoreNavigation(p2): nil | string
	if p2.isMomentsDestination or p2.isRmTile then
		return "tab"
	end

	return nil
end

return getMomentsMoreNavigation
