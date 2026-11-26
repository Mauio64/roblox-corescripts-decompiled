return function(p2)
	if p2 then
		return p2.getScreenProps("isVisible", false) or not p2.getScreenProps("wideMode", false)
	end

	return false
end
