local function is(p1, p2) -- line: 16
	return p1 == p2 and (p1 ~= 0 or 1 / p1 == 1 / p2) or p1 ~= p1 and p2 ~= p2
end

return is
