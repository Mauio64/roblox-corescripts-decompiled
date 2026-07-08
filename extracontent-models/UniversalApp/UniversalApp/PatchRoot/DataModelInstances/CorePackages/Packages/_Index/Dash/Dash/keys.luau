local insert = table.insert

local function keys(t1: {[any]: any}) -- line: 12
	-- upvalues: insert (copy)
	local t2 = {}

	for v5, _ in t1 do
		insert(t2, v5)
	end

	return t2
end

return keys
