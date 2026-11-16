local Json = {}

local function kind_of(list)
	if type(list) ~= "table" then
		return (type(list))
	end

	local v = 1

	for _ in pairs(list) do
		if list[v] == nil then
			return "table"
		end

		v += 1
	end

	return if v == 1 then "table" else "array"
end

local function escape_str(list: string)
	local v = { "\\", "\"", "/", "b", "f", "n", "r", "t" }

	for i, v2 in ipairs({ "\\", "\"", "/", "\8", "\f", "\n", "\r", "\t" }) do
		list = list:gsub(v2, "\\" .. v[i])
	end

	return list
end

function Json.stringify(list, flag: boolean?)
	local v = {}
	local v2 = kind_of(list)

	if v2 == "array" then
		if flag then
			error("Can't encode array as key.")
		end

		v[#v + 1] = "["

		for i, item in ipairs(list) do
			if i > 1 then
				v[#v + 1] = ", "
			end

			v[#v + 1] = Json.stringify(item)
		end

		v[#v + 1] = "]"
	elseif v2 == "table" then
		if flag then
			error("Can't encode table as key.")
		end

		v[#v + 1] = "{"

		for k, item in pairs(list) do
			if #v > 1 then
				v[#v + 1] = ", "
			end

			v[#v + 1] = Json.stringify(k, true)
			v[#v + 1] = ":"
			v[#v + 1] = Json.stringify(item)
		end

		v[#v + 1] = "}"
	else
		if v2 == "string" then
			return "\"" .. escape_str(list) .. "\""
		end

		if v2 == "number" then
			if flag then
				return "\"" .. tostring(list) .. "\""
			end

			return (tostring(list))
		end

		if v2 == "boolean" then
			return (tostring(list))
		end

		if v2 == "nil" then
			return "null"
		end

		error("Unjsonifiable type: " .. v2 .. ".")
	end

	return table.concat(v)
end

return Json
