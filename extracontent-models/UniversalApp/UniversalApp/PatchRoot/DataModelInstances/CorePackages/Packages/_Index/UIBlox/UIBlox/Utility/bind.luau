return function(p1, p2) -- line: 7
	return function(p3, ...) -- line: 8
		-- upvalues: p2 (copy), p1 (copy)
		if p3 == p2 then
			return p1(p2, ...)
		end

		return p1(p2, p3, ...)
	end
end
