return function(p1, p2) -- line: 1
	return function(p3, p4) -- line: 2
		-- upvalues: p1 (copy), p2 (copy)
		if p3 == nil then
			p3 = p1
		end

		local v5 = p2[p4.type]

		if v5 then
			return v5(p3, p4)
		end

		return p3
	end
end
