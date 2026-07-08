local equalObjects = require(script.Parent.Parent.equalObjects)

local function equalsDeepOneWay(p1, p2) -- line: 4
	-- upvalues: equalsDeepOneWay (copy)
	if type(p1) == "table" and type(p2) == "table" then
		for i = 1, #p1 do
			if not equalsDeepOneWay(p1[i], p2[i]) then
				return false
			end
		end
	elseif p1 ~= p2 then
		return false
	end

	return true
end
local function equalsDeep(...) -- line: 20
	-- upvalues: equalObjects (copy), equalsDeepOneWay (copy)
	if equalObjects(...) then
		return true
	end

	local v7 = select("#", ...)

	for i = 1, v7 do
		local v9 = select(i, ...)

		for j = 1, v7 do
			if j == i then
				continue
			end

			local v11 = select(j, ...)

			if not equalsDeepOneWay(v9, v11) then
				return false
			end
		end
	end

	return true
end

return equalsDeep
