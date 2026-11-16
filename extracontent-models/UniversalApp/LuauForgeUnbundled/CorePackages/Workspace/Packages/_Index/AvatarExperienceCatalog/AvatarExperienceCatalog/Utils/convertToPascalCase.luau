local function toPascalCase(value)
	if type(value) == "string" then
		return value:gsub("^%l", string.upper)
	end

	return (tostring(value))
end

local function convertToPascalCase(item)
	local result = {}

	for k, item2 in item do
		if type(k) == "string" then
			local v5 = if type(k) == "string" then k:gsub("^%l", string.upper) else tostring(k)

			if type(item2) == "table" then
				result[v5] = convertToPascalCase(item2)
			else
				result[v5] = item2
			end
		else
			result[k] = item2
		end
	end

	return result
end

return convertToPascalCase
