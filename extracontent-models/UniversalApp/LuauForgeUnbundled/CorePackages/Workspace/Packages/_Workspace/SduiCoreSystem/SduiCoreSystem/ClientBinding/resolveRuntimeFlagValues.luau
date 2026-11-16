local defineFastString = game:DefineFastString("SduiRuntimeFlagNames", "")

local v5 = nil
local count = 0

local function getNames()
	if v5 ~= nil then
		return v5, count
	end

	local set = {}
	local result = {}

	for k, v6 in string.split(defineFastString, ",") do
		local v7 = string.match(v6, "^%s*(.-)%s*$") or ""

		if v7 == "" or set[v7] then
			continue
		end

		if #result >= 16 or #v7 > 128 or string.match(v7, "^[A-Za-z0-9_]+$") == nil then
			count += 1
		else
			set[v7] = true
			table.insert(result, v7)
		end
	end

	table.sort(result)
	v5 = result
	return result, count
end

local function resolveRuntimeFlagValues(callback)
	local names, v6 = getNames()
	local count2 = 0
	local result = {}

	for k, name in names do
		local v7, v8 = callback(name)

		if v7 and type(v8) == "boolean" then
			result[name] = v8
		else
			count2 += 1
		end
	end

	return result, v6, count2
end

return resolveRuntimeFlagValues
