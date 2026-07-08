return function(p1, p2) -- line: 1
	if not p1 or p1 == "" then
		return true
	end

	return string.find(string.lower(p2), string.lower(p1), 1, true) ~= nil
end
