local objectIs = require(script.Parent.objectIs)

local function shallowEqual(p1, p2) -- line: 18
	-- upvalues: objectIs (copy)
	if objectIs(p1, p2) then
		return true
	end

	if typeof(p1) ~= "table" or p1 == nil or typeof(p2) ~= "table" or p2 == nil then
		return false
	end

	for v5, v6 in p1 do
		if not objectIs(p2[v5], v6) then
			return false
		end
	end

	for v7, v8 in p2 do
		if not objectIs(p1[v7], v8) then
			return false
		end
	end

	return true
end

return shallowEqual
