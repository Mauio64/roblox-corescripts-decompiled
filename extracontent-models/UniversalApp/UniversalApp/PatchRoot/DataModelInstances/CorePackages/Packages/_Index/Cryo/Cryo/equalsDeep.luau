local equalObjects = require(script.Parent.equalObjects)

local function compareDeep(p1, p2) -- line: 4
	-- upvalues: compareDeep (copy)
	if type(p1) ~= "table" or type(p2) ~= "table" then
		return p1 == p2
	end

	for v6, v7 in p1 do
		if not compareDeep(p2[v6], v7) then
			return false
		end
	end

	for v8, v9 in p2 do
		if not compareDeep(p1[v8], v9) then
			return false
		end
	end

	return true
end
local function equalsDeep(...) -- line: 24
	-- upvalues: equalObjects (copy), compareDeep (copy)
	if equalObjects(...) then
		return true
	end

	local v10 = select("#", ...)
	local v11 = select(1, ...)

	for i = 2, v10 do
		local v13 = select(i, ...)

		if not compareDeep(v11, v13) then
			return false
		end
	end

	return true
end

return equalsDeep
