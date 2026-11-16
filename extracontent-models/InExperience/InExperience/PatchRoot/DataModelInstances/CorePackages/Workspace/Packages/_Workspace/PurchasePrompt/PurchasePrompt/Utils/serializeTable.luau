local function serializeTable(item, k, p, count)
	local v = p or false
	local v2 = count or 0

	local v3 = string.rep(" ", v2)

	if k then
		v3 ..= k .. " = "
	end

	if type(item) == "table" then
		local v4 = v3 .. "{" .. (v and "" or "\n")

		for k2, item2 in pairs(item) do
			v4 ..= serializeTable(item2, k2, v, v2 + 1) .. "," .. (v and "" or "\n")
		end

		return v4 .. string.rep(" ", v2) .. "}"
	end

	if type(item) == "number" then
		return v3 .. tostring(item)
	end

	if type(item) == "string" then
		return v3 .. string.format("%q", item)
	end

	if type(item) == "boolean" then
		return v3 .. (item and "true" or "false")
	end

	return v3 .. "\"[inserializeable datatype:" .. type(item) .. "]\""
end

return serializeTable
