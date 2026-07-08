return {
	create = function() -- line: 6
		return {}
	end,
	register = function(p1, s1: string, p2: ((...any) -> ...any)) -- line: 11
		if not p1[s1] then
			p1[s1] = {}
		end

		table.insert(p1[s1], p2)
	end
}
