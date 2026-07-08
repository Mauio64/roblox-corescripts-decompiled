local function defaultCompareFn(p1, p2) -- line: 1
	return p1.value < p2.value
end
local function sortTableByValue(t1: {[any]: any}, p3: ((...any) -> ...any)?) -- line: 5
	-- upvalues: defaultCompareFn (copy)
	local t2 = {}
	local v8 = p3 or defaultCompareFn

	for v9, v10 in t1 do
		table.insert(t2, {
			key = v9,
			value = v10
		})
	end

	table.sort(t2, v8)

	return t2
end

return sortTableByValue
