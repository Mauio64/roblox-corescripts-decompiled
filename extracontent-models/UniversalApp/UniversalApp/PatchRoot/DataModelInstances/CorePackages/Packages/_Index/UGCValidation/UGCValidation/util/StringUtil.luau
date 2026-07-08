return {
	keysToString = function(t1: {[any]: any}, s1: string, b1: boolean?) -- line: 7
		local t2 = {}

		for v5 in t1 do
			table.insert(t2, (tostring(v5)))
		end

		if b1 then
			table.sort(t2)
		end

		return table.concat(t2, s1)
	end
}
