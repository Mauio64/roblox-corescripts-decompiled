return function(p, p2)
	return function(p3, p4)
		if p3 == nil then
			p3 = p
		end

		local v = p2[p4.type]

		if v then
			return v(p3, p4)
		end

		return p3
	end
end
