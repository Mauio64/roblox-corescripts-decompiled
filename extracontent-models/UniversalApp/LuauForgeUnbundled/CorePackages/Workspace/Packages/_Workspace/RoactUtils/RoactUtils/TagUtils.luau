return {
	combineReactTags = function(...)
		local v5 = table.pack(...)

		local v6 = {}

		for i = 1, v5.n do
			local v7 = v5[i]

			if v7 and v7 ~= "" then
				table.insert(v6, v7)
			end
		end

		if #v6 > 0 then
			return (table.concat(v6, " "))
		end

		return nil
	end
}
