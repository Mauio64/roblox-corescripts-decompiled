local function describeProblematicProperties(items, p)
	local v = {}

	for _, item in items do
		local v2

		if p then
			v2 = p[item]
		end

		if v2 == 0 then
			table.insert(v, `{item} (must be empty)`)
		elseif v2 == nil then
			table.insert(v, item)
		else
			table.insert(v, `{item} (limit {v2} bytes)`)
		end
	end

	return table.concat(v, ", ")
end

return describeProblematicProperties
