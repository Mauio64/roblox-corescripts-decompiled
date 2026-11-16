local function makeMergeOverlappingArraysPolicy(p: string)
	local function mergeOverlappingArraysPolicy(_, options, options2, object)
		local v = options or {}
		options2 = options2 or {}

		if #options2 == 0 then
			return v
		end

		if #v == 0 then
			return options2
		end

		local clone = table.clone(v)
		local v2 = {}

		for k, v3 in clone do
			local field = object:readField(p, v3)

			if field then
				v2[field] = k
			end
		end

		for _, option in options2 do
			local field = object:readField(p, option)

			if field and v2[field] then
				local v3 = v2[field]
				clone[v3] = object:mergeObjects(clone[v3], option)
			else
				table.insert(clone, option)
			end
		end

		return clone
	end

	return mergeOverlappingArraysPolicy
end

return makeMergeOverlappingArraysPolicy
