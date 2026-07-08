local t1 = {}

local function kind_of(p1) -- line: 5
	if type(p1) ~= "table" then
		return (type(p1))
	end

	local n1 = 1

	for _ in pairs(p1) do
		if p1[n1] == nil then
			return "table"
		end

		n1 += 1
	end

	if n1 == 1 then
		return "table"
	end

	return "array"
end
local function escape_str(s1: string) -- line: 24
	for i, v in ipairs({
		"\\",
		"\"",
		"/",
		"\b",
		"\f",
		"\n",
		"\r",
		"\t"
	}) do
		s1 = s1:gsub(v, "\\" .. ({
			"\\",
			"\"",
			"/",
			"b",
			"f",
			"n",
			"r",
			"t"
		})[i])
	end

	return s1
end

function t1.stringify(p2, b1: boolean?) -- line: 33
	-- upvalues: kind_of (copy), t1 (copy), escape_str (copy)
	local t2 = {}
	local v13 = kind_of(p2)

	if v13 == "array" then
		if b1 then
			error("Can't encode array as key.")
		end

		t2[#t2 + 1] = "["

		for i, v in ipairs(p2) do
			if i > 1 then
				t2[#t2 + 1] = ", "
			end

			t2[#t2 + 1] = t1.stringify(v)
		end

		t2[#t2 + 1] = "]"
	elseif v13 == "table" then
		if b1 then
			error("Can't encode table as key.")
		end

		t2[#t2 + 1] = "{"

		for k, v in pairs(p2) do
			if #t2 > 1 then
				t2[#t2 + 1] = ", "
			end

			t2[#t2 + 1] = t1.stringify(k, true)
			t2[#t2 + 1] = ":"
			t2[#t2 + 1] = t1.stringify(v)
		end

		t2[#t2 + 1] = "}"
	else
		if v13 == "string" then
			return "\"" .. escape_str(p2) .. "\""
		end

		if v13 == "number" then
			if b1 then
				return "\"" .. tostring(p2) .. "\""
			end

			return (tostring(p2))
		end

		if v13 == "boolean" then
			return (tostring(p2))
		end

		if v13 == "nil" then
			return "null"
		end

		error("Unjsonifiable type: " .. v13 .. ".")
	end

	return table.concat(t2)
end

return t1
