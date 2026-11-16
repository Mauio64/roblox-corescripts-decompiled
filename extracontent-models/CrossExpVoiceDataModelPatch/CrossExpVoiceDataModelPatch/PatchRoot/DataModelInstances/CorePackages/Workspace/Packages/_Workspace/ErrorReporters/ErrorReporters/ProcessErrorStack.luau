local function splitStringWithMarks(value, list)
	if type(value) ~= "string" or type(list) ~= "table" then
		return value, ""
	end

	for _, item in ipairs(list) do
		local v, v2 = value.find(value, item, nil, true)

		if v ~= nil then
			return value.sub(value, 1, v - 1), (value.sub(value, v2 + 1))
		end
	end

	return value, ""
end

local function findFileNameFromPath(value)
	if type(value) == "string" then
		return string.match(value, "([^.]*)$")
	end

	return ""
end

local function ProcessErrorStack(value, value2)
	local result = {}
	local result2 = {}
	local v = value2 or 0

	if type(value) ~= "string" then
		return result, result2
	end

	for k in value:gmatch("[^\r\n]+") do
		local v2, v3 = splitStringWithMarks(k, { ", line ", ", Line ", ":" })
		local v4, v5 = splitStringWithMarks(v3, { " - " })
		local line, funcName

		if v5 == "" and v4 ~= "" then
			line, funcName = string.match(v4, "^(%d+)%s*(.*)")

			if line then
				if funcName == "" then
					funcName = ""
				end
			else
				funcName = ""
				line = v4
			end
		else
			funcName = v5
			line = v4
		end

		if not (line ~= "" and v2 ~= "") then
			continue
		end

		local _, _, v6 = string.find(v2, "Script '(.*)'")

		if v6 == nil then
			v6 = v2
		end

		local v7 = result2[v6]

		if v7 == nil then
			v += 1

			result2[v6] = v
			v7 = v
		end

		if funcName == "" then
			funcName = type(v6) ~= "string" and "" or string.match(v6, "([^.]*)$")
		end

		table.insert(result, { line = line, funcName = funcName, sourceCode = tostring(v7) })
	end

	local result3 = {}

	for k, v2 in pairs(result2) do
		result3[tostring(v2)] = { path = k }
	end

	return result, result3, v
end

return ProcessErrorStack
