local function defaultCompareFn(p, p2): boolean
	return p.value < p2.value
end

local function sortTableByValue(items, callback)
	local result = {}

	for k, item in items do
		table.insert(result, { key = k, value = item })
	end

	table.sort(result, callback or defaultCompareFn)

	return result
end

return sortTableByValue
