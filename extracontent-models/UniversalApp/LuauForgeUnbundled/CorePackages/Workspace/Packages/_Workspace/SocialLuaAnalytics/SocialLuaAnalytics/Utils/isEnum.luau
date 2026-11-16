return function(p2): boolean
	if type(p2) == "userdata" and p2.rawValue then
		return true
	end

	return false
end
