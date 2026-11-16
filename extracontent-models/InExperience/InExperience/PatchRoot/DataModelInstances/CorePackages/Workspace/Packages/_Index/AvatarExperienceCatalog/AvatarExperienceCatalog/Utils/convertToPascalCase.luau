local function toPascalCase(value) -- 1 equivalent call inferred from this helper
	if type(value) == "string" then
		return value:gsub("^%l", string.upper)
	end

	return (tostring(value))
end

local function convertToPascalCase(item)
	local result = {}

	for k, item2 in item do
		if type(k) == "string" then
			local pascalCase = toPascalCase(k) -- inferred equivalent call

			if type(item2) == "table" then
				result[pascalCase] = convertToPascalCase(item2)
			else
				result[pascalCase] = item2
			end
		else
			result[k] = item2
		end
	end

	return result
end

return convertToPascalCase
