local equalObjects = require(script.Parent.Parent.equalObjects)

local function compare(p1, p2) -- line: 3
	if type(p1) ~= "table" or type(p2) ~= "table" then
		return p1 == p2
	end

	if #p1 ~= #p2 then
		return false
	end

	for i = 1, #p1 do
		if p1[i] ~= p2[i] then
			return false
		end
	end

	return true
end
local function equals(...) -- line: 21
	-- upvalues: equalObjects (copy), compare (copy)
	if equalObjects(...) then
		return true
	end

	local v7 = select("#", ...)
	local v8 = select(1, ...)

	for i = 2, v7 do
		local v10 = select(i, ...)

		if not compare(v8, v10) then
			return false
		end
	end

	return true
end

return equals
