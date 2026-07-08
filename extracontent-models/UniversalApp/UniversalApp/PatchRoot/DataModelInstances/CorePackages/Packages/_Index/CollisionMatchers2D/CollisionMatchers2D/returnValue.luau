return function(p1, p2, p3) -- line: 1
	return {
		pass = p1,
		message = p1 and p2 or (p3 or p2)
	}
end
