return function(p1, p2) -- line: 3
	if p1 == p2 then
		return p1 ~= 0 or 1 / p1 == 1 / p2
	end

	return p1 ~= p1 and p2 ~= p2
end
