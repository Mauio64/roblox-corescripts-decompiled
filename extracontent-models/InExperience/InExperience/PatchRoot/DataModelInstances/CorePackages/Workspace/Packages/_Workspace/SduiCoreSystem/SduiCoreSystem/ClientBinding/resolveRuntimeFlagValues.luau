local defineFastString = game:DefineFastString("SduiRuntimeFlagNames", "")

local v = nil
local count = 0

local function getNames()
	if v ~= nil then
		return v, count
	end

	local set = {}
	local result = {}

	for _, v2 in string.split(defineFastString, ",") do
		local v3 = string.match(v2, "^%s*(.-)%s*$") or ""

		if v3 == "" or set[v3] then
			continue
		end

		if #result >= 16 or #v3 > 128 or string.match(v3, "^[A-Za-z0-9_]+$") == nil then
			count += 1
		else
			set[v3] = true
			table.insert(result, v3)
		end
	end

	table.sort(result)
	v = result
	return result, count
end

local function resolveRuntimeFlagValues(callback)
	local names, v2 = getNames()
	local count2 = 0
	local result = {}

	for _, name in names do
		local v3, v4 = callback(name)

		if v3 and type(v4) == "boolean" then
			result[name] = v4
		else
			count2 += 1
		end
	end

	return result, v2, count2
end

return resolveRuntimeFlagValues
