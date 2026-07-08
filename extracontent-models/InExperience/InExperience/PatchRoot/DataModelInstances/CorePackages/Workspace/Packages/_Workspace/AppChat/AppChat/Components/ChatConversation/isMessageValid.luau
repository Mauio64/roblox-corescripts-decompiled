return function(p1, p2) -- line: 1
	if p2 < #p1 then
		return false
	end

	if p1:match("^%s*$") then
		return false
	end

	return true
end
