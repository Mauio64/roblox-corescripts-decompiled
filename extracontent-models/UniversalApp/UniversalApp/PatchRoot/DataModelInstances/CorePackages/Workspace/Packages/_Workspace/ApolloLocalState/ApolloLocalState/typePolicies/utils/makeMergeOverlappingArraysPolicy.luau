local function makeMergeOverlappingArraysPolicy(s1: string) -- line: 1
	local function mergeOverlappingArraysPolicy(_, p2, p3, p4) -- line: 2
		-- upvalues: s1 (copy)
		local v8 = p2 or {}
		local v9 = p3 or {}

		if #v9 == 0 then
			return v8
		end

		if #v8 == 0 then
			return v9
		end

		local t1 = {}
		local v11 = table.clone(v8)

		for v12, v13 in v11 do
			local v14 = p4:readField(s1, v13)

			if v14 then
				t1[v14] = v12
			end
		end

		for _, v16 in v9 do
			local v17 = p4:readField(s1, v16)

			if v17 and t1[v17] then
				local v18 = t1[v17]

				v11[v18] = p4:mergeObjects(v11[v18], v16)
			else
				table.insert(v11, v16)
			end
		end

		return v11
	end

	return mergeOverlappingArraysPolicy
end

return makeMergeOverlappingArraysPolicy
