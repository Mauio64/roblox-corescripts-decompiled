return function(p1) -- line: 8
	return function(_, p3) -- line: 9
		-- upvalues: p1 (copy)
		return p3 or p1
	end
end
