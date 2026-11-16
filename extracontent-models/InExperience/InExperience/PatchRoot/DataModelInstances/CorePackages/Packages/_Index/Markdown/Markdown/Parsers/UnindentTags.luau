local function unindentTags(value: string, value2: number?)
	local v = value2 or 2

	if not string.find(value, "<.->") then
		return value
	end

	local v2 = string.gsub(value, "\r\n", "\n")
	local v3 = string.split(v2, "\n")
	local v4 = table.create(#v3)
	local v5 = {}

	for _, v6 in v3 do
		local _, v7 = string.find(v6, "^[ \t]*")
		local v8 = v7 or 0
		local v9 = string.sub(v6, v8 + 1)

		if string.find(v9, "^<") then
			if string.find(v9, "^</") then
				table.remove(v5)
			elseif not string.find(v9, "/>$") then
				table.insert(v5, v8)
			end

			table.insert(v4, v9)
		else
			local v10 = math.max(0, v8 - (not (#v5 > 0) and 0 or v5[#v5] + v))
			table.insert(v4, string.rep(" ", v10) .. v9)
		end
	end

	return table.concat(v4, "\n")
end

return unindentTags
