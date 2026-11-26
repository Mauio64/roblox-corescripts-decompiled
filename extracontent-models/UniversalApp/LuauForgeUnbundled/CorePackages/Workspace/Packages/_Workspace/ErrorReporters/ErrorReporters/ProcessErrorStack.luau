local function splitStringWithMarks(value, list)
	if type(value) ~= "string" or type(list) ~= "table" then
		return value, ""
	end

	for i, item in ipairs(list) do
		local v5, v6 = value.find(value, item, nil, true)

		if v5 ~= nil then
			return value.sub(value, 1, v5 - 1), (value.sub(value, v6 + 1))
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
	local v5 = value2 or 0

	if type(value) ~= "string" then
		return result, result2
	end

	for k in value:gmatch("[^\r\n]+") do
		local v6, v7 = splitStringWithMarks(k, { ", line ", ", Line ", ":" })
		local v8, v9 = splitStringWithMarks(v7, { " - " })
		local v10, v11

		if v9 == "" and v8 ~= "" then
			v10, v11 = string.match(v8, "^(%d+)%s*(.*)")

			if v10 then
				if v11 == "" then
					v11 = ""
				end
			else
				v11 = ""
				v10 = v8
			end
		else
			v11 = v9
			v10 = v8
		end

		if not (v10 ~= "" and v6 ~= "") then
			continue
		end

		local v12, v13, v14 = string.find(v6, "Script '(.*)'")

		if v14 == nil then
			v14 = v6
		end

		local v15 = result2[v14]

		if v15 == nil then
			v5 += 1

			result2[v14] = v5
			v15 = v5
		end

		if v11 == "" then
			v11 = type(v14) ~= "string" and "" or string.match(v14, "([^.]*)$")
		end

		table.insert(result, { line = v10, funcName = v11, sourceCode = tostring(v15) })
	end

	local result3 = {}

	for k, v6 in pairs(result2) do
		result3[tostring(v6)] = { path = k }
	end

	return result, result3, v5
end

return ProcessErrorStack
