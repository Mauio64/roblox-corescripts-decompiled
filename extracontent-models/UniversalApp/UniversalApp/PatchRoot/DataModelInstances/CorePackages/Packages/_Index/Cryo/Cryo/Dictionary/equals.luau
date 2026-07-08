local equalObjects = require(script.Parent.Parent.equalObjects)

local function compare(p1, p2) -- line: 3
	if type(p1) ~= "table" or type(p2) ~= "table" then
		return p1 == p2
	end

	for v6, v7 in p1 do
		if v7 ~= p2[v6] then
			return false
		end
	end

	for v8, v9 in p2 do
		if v9 ~= p1[v8] then
			return false
		end
	end

	return true
end
local function equals(...) -- line: 23
	-- upvalues: equalObjects (copy), compare (copy)
	if equalObjects(...) then
		return true
	end

	local v10 = select("#", ...)
	local v11 = select(1, ...)

	for i = 2, v10 do
		local v13 = select(i, ...)

		if not compare(v11, v13) then
			return false
		end
	end

	return true
end

return equals
