return {
	combineReactTags = function(...)
		local v = table.pack(...)

		local v2 = {}

		for i = 1, v.n do
			local v3 = v[i]

			if v3 and v3 ~= "" then
				table.insert(v2, v3)
			end
		end

		if #v2 > 0 then
			return (table.concat(v2, " "))
		end

		return nil
	end
}
