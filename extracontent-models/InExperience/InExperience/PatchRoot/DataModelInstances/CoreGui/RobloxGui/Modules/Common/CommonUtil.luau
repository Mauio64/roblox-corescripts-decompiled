return {
	TableConcat = function(p1, p2) -- line: 12
		for i = 1, #p2 do
			p1[#p1 + 1] = p2[i]
		end

		return p1
	end,
	SortByName = function(p3) -- line: 21
		local function compareInstanceNames(p4, p5) -- line: 22
			return p4.Name < p5.Name
		end

		table.sort(p3, compareInstanceNames)

		return p3
	end
}
