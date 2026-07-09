return function(p1) -- line: 1
	if not p1 then
		return false
	end

	return p1.getScreenProps("isVisible", false) or not p1.getScreenProps("wideMode", false)
end
