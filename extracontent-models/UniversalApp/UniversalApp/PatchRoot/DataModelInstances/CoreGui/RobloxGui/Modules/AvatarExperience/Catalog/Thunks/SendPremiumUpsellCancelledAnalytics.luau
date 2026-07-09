return function(p1, p2, p3) -- line: 1
	return function(_) -- line: 2
		-- upvalues: p1 (copy), p2 (copy), p3 (copy)
		p1(p2, p3)
	end
end
