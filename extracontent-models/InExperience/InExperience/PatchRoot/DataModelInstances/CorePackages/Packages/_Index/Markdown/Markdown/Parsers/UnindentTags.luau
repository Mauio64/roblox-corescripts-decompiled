local function unindentTags(s1: string, n1: number?) -- line: 49
	local v4 = n1 or 2

	if not string.find(s1, "<.->") then
		return s1
	end

	local v5 = string.gsub(s1, "\r\n", "\n")
	local parts = string.split(v5, "\n")
	local t1 = table.create(#parts)
	local t2 = {}

	for _, v10 in parts do
		local _, stop = string.find(v10, "^[ \t]*")
		local v13 = stop or 0
		local v14 = string.sub(v10, v13 + 1)

		if string.find(v14, "^<") then
			if string.find(v14, "^</") then
				table.remove(t2)
				table.insert(t1, v14)
			elseif string.find(v14, "/>$") then
				table.insert(t1, v14)
			else
				table.insert(t2, v13)
				table.insert(t1, v14)
			end
		else
			local n2 = 0

			if #t2 > 0 then
				n2 = t2[#t2] + v4
			end

			local v16 = math.max(0, v13 - n2)

			table.insert(t1, string.rep(" ", v16) .. v14)
		end
	end

	return table.concat(t1, "\n")
end

return unindentTags
