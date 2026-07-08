local equalObjects = require(script.Parent.Parent.equalObjects)

local function equalsDeepOneWay(p1, p2) -- line: 4
	-- upvalues: equalsDeepOneWay (copy)
	if type(p1) == "table" and type(p2) == "table" then
		for k, v in pairs(p1) do
			if not equalsDeepOneWay(v, p2[k]) then
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

	local v8 = select("#", ...)

	for i = 1, v8 do
		local v10 = select(i, ...)

		for j = 1, v8 do
			if j == i then
				continue
			end

			local v12 = select(j, ...)

			if not equalsDeepOneWay(v10, v12) then
				return false
			end
		end
	end

	return true
end

return equalsDeep
