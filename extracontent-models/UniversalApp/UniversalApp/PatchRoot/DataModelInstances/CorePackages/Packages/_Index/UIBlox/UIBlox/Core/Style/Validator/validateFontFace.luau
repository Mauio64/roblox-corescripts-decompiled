return function(p)
	if typeof(p) == "Font" then
		return true
	end

	return false, `expected Font, got {p}`
end
