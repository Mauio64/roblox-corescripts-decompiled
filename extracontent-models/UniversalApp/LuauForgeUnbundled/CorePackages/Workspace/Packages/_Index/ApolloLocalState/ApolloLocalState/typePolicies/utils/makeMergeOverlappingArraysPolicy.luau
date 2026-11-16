local function makeMergeOverlappingArraysPolicy(p2)
	local function mergeOverlappingArraysPolicy(p3, options, options2, object)
		local v5 = options or {}
		local v6 = options2 or {}

		if #v6 == 0 then
			return v5
		end

		if #v5 == 0 then
			return v6
		end

		local clone = table.clone(v5)
		local v7 = {}

		for k, v8 in clone do
			local field = object:readField(p2, v8)

			if field then
				v7[field] = k
			end
		end

		for k, v8 in v6 do
			local field = object:readField(p2, v8)

			if field and v7[field] then
				local v9 = v7[field]
				clone[v9] = object:mergeObjects(clone[v9], v8)
			else
				table.insert(clone, v8)
			end
		end

		return clone
	end

	return mergeOverlappingArraysPolicy
end

return makeMergeOverlappingArraysPolicy
