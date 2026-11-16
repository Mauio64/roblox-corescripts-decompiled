local function mergeObservedNames(items, p, p2: string)
	local v = false

	for _, item in items do
		local v2 = item[p2]

		if not v2 or p[v2] then
			continue
		end

		p[v2] = true
		v = true
	end

	return v
end

return mergeObservedNames
