local function toPascalCase(p1) -- line: 1
	if type(p1) ~= "string" then
		return (tostring(p1))
	end

	return p1:gsub("^%l", string.upper)
end
local function convertToPascalCase(t1: {[any]: any}) -- line: 10
	-- upvalues: convertToPascalCase (copy)
	local t2 = {}

	for v6, v7 in t1 do
		if type(v6) ~= "string" then
			t2[v6] = v7
		else
			local v8 = if type(v6) == "string" then v6:gsub("^%l", string.upper) else tostring(v6)

			if type(v7) == "table" then
				t2[v8] = convertToPascalCase(v7)
			else
				t2[v8] = v7
			end
		end
	end

	return t2
end

return convertToPascalCase
