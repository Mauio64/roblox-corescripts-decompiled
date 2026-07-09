local function toStringLimitedHelper(p1, s1: string?, n1: number?, p2: ((...any) -> ...any)?, n2: number) -- line: 4
	-- upvalues: toStringLimitedHelper (copy)
	local v7 = s1 or ""

	assert(v7, "")

	local v8 = n1 or 5

	assert(v8, "")

	local n3 = 20

	if type(p2) == "function" then
		local v10 = p2(n2)

		if type(v10) == "number" then
			n3 = v10
		end
	end

	if type(p1) == "table" then
		if v8 > 0 and v8 < n2 then
			return "*truncated"
		end

		local v11 = "" .. "{\n"
		local n4 = 0

		for k, v in pairs(p1) do
			n4 += 1

			if n3 > 0 and n3 < n4 then
				v11 ..= "  " .. v7 .. "*truncated" .. "\n"

				return v11 .. v7 .. "}"
			end

			if type(k) == "string" then
				v11 ..= "  " .. v7 .. k .. " = " .. toStringLimitedHelper(v, "  " .. v7, v8, p2, n2 + 1) .. ";\n"
			end

			if type(k) == "number" then
				v11 ..= "  " .. v7 .. toStringLimitedHelper(v, "  " .. v7, v8, p2, n2 + 1) .. ",\n"
			end
		end

		return v11 .. v7 .. "}"
	end

	if type(p1) == "string" then
		return "\"" .. p1 .. "\""
	end

	return (tostring(p1))
end

return function(p3, p4, p5, p6) -- line: 65
	-- upvalues: toStringLimitedHelper (copy)
	return (toStringLimitedHelper(p3, p4, p5, p6, 1))
end
