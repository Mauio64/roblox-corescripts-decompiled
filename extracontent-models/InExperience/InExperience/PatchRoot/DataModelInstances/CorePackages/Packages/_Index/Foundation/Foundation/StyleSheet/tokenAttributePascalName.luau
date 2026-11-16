local colorScopeKeepPrefix = require(script.Parent.colorScopeKeepPrefix)

local function kebabToPascal(value: string)
	return (value:gsub("^%-?(.)", function(value2)
		return value2:upper()
	end):gsub("%-(.)", function(value2)
		return value2:upper()
	end))
end

local function tokenAttributePascalName(list: string, p: string)
	local v = kebabToPascal(p)

	if colorScopeKeepPrefix[list] and string.sub(v, 1, #list) == list then
		return (string.sub(v, #list + 1))
	end

	return v
end

return tokenAttributePascalName
