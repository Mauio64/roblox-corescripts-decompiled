local function defaultCompareFn(p2, p3): boolean
	return p2.value < p3.value
end

local function sortTableByValue(items, p2)
	local result = {}

	for k, item in items do
		table.insert(result, { key = k, value = item })
	end

	table.sort(result, p2 or defaultCompareFn)

	return result
end

return sortTableByValue
