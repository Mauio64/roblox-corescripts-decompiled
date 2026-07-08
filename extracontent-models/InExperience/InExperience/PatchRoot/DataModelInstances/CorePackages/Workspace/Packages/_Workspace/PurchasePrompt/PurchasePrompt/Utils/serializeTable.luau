local function serializeTable(p1, p2, p3, p4) -- line: 3
	-- upvalues: serializeTable (copy)
	local v6 = p3 or false
	local v7 = p4 or 0
	local v8 = string.rep(" ", v7)

	if p2 then
		v8 ..= p2 .. " = "
	end

	if type(p1) == "table" then
		local v9 = v8 .. "{" .. (v6 and "" or "\n")

		for k, v in pairs(p1) do
			v9 ..= serializeTable(v, k, v6, v7 + 1) .. "," .. (v6 and "" or "\n")
		end

		return v9 .. string.rep(" ", v7) .. "}"
	end

	if type(p1) == "number" then
		return v8 .. tostring(p1)
	end

	if type(p1) == "string" then
		return v8 .. string.format("%q", p1)
	end

	if type(p1) == "boolean" then
		return v8 .. (not p1 and "false" or "true")
	end

	return v8 .. "\"[inserializeable datatype:" .. type(p1) .. "]\""
end

return serializeTable
