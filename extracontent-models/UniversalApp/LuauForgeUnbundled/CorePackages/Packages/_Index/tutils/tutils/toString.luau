local function toStringLimitedHelper(value, value2, value3, callback, p2)
	local v5 = value2 or ""
	assert(v5, "")
	local v6 = value3 or 5
	assert(v6, "")
	local v7 = 20

	if type(callback) == "function" then
		local v8 = callback(p2)

		if type(v8) == "number" then
			v7 = v8
		end
	end

	if type(value) == "table" then
		if v6 > 0 and v6 < p2 then
			return "*truncated"
		end

		local count = 0
		local v8 = "{\n"

		for k, item in pairs(value) do
			count += 1

			if v7 > 0 and v7 < count then
				v8 ..= "  " .. v5 .. "*truncated\n"
				break
			end

			if type(k) == "string" then
				v8 ..= "  " .. v5 .. k .. " = " .. toStringLimitedHelper(
					item,
					"  " .. v5,
					v6,
					callback,
					p2 + 1
				) .. ";\n"
			end

			if type(k) == "number" then
				v8 ..= "  " .. v5 .. toStringLimitedHelper(item, "  " .. v5, v6, callback, p2 + 1) .. ",\n"
			end
		end

		return v8 .. v5 .. "}"
	elseif type(value) == "string" then
		return "\"" .. value .. "\""
	else
		return (tostring(value))
	end
end

return function(p2, p3, p4, p5)
	return (toStringLimitedHelper(p2, p3, p4, p5, 1))
end
