return function(p1, p2, p3) -- line: 5
	if p1 and (p2 and p3 and p3 ~= "" and p1[p3] and p2[p3] and p1[p3] == p2[p3]) then
		return true
	end

	return false
end
