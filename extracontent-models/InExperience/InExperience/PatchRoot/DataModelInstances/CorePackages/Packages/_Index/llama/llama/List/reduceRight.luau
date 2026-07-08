local function reduceRight(p1, p2, p3) -- line: 2
	local v5 = type(p1)

	assert(v5 == "table", "expected a table for first argument, got " .. v5)

	local v6 = type(p2)

	assert(v6 == "function", "expected a function for second argument, got " .. v6)

	local v7 = #p1
	local v8 = p3

	if v8 == nil then
		v8 = p1[v7]
	end

	for i = p3 == nil and v7 - 1 or v7, 1, -1 do
		v8 = p2(v8, p1[i], i)
	end

	return v8
end

return reduceRight
