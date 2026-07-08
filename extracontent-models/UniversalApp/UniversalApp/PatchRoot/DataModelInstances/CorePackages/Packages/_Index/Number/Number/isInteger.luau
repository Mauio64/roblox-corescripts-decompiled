return function(p1) -- line: 17
	return type(p1) == "number" and (p1 ~= 1e999 and p1 == math.floor(p1))
end
