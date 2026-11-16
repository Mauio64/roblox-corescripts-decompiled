local function reduceRight(list, callback, p)
	local typeName = type(list)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)

	local typeName2 = type(callback)
	assert(typeName2 == "function", "expected a function for second argument, got " .. typeName2)

	local v = #list
	local v2

	if p == nil then
		v2 = list[v]
	else
		v2 = p
	end

	v = p == nil and v - 1 or v

	for i = v, 1, -1 do
		v2 = callback(v2, list[i], i)
	end

	return v2
end

return reduceRight
