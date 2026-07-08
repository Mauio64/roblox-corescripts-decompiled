return {
	combineReactTags = function(...) -- line: 15
		local v1 = table.pack(...)
		local t1 = {}

		for i = 1, v1.n do
			local v4 = v1[i]

			if v4 and v4 ~= "" then
				table.insert(t1, v4)
			end
		end

		if #t1 > 0 then
			return (table.concat(t1, " "))
		end

		return nil
	end
}
