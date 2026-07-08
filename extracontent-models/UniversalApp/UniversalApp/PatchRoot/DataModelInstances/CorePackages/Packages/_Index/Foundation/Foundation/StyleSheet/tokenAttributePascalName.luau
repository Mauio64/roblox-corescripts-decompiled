local colorScopeKeepPrefix = require(script.Parent.colorScopeKeepPrefix)

local function kebabToPascal(s1: string) -- line: 3
	return (s1:gsub("^%-?(.)", function(p1) -- line: 4
		return p1:upper()
	end):gsub("%-(.)", function(p2) -- line: 7
		return p2:upper()
	end))
end
local function tokenAttributePascalName(s2: string, s3: string) -- line: 15
	-- upvalues: kebabToPascal (copy), colorScopeKeepPrefix (copy)
	local v7 = kebabToPascal(s3)

	if colorScopeKeepPrefix[s2] and s2 == string.sub(v7, 1, #s2) then
		return (string.sub(v7, #s2 + 1))
	end

	return v7
end

return tokenAttributePascalName
