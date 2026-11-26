local function serializeTable(item, k, p2, count)
	local v5 = p2 or false
	local v6 = count or 0

	local v7 = string.rep(" ", v6)

	if k then
		v7 ..= k .. " = "
	end

	if type(item) == "table" then
		local v8 = v7 .. "{" .. (v5 and "" or "\n")

		for k2, item2 in pairs(item) do
			v8 ..= serializeTable(item2, k2, v5, v6 + 1) .. "," .. (v5 and "" or "\n")
		end

		return v8 .. string.rep(" ", v6) .. "}"
	end

	if type(item) == "number" then
		return v7 .. tostring(item)
	end

	if type(item) == "string" then
		return v7 .. string.format("%q", item)
	end

	if type(item) == "boolean" then
		return v7 .. (item and "true" or "false")
	end

	return v7 .. "\"[inserializeable datatype:" .. type(item) .. "]\""
end

return serializeTable
