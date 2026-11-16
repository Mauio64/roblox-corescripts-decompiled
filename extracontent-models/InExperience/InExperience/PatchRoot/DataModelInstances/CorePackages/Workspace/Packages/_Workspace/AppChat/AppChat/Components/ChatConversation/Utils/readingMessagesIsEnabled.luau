return function(p)
	if p then
		return p.getScreenProps("isVisible", false) or not p.getScreenProps("wideMode", false)
	end

	return false
end
