return function(p1) -- line: 3
	if type(p1) == "userdata" and p1.rawValue then
		return true
	end

	return false
end
