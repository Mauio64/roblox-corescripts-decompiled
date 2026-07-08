local insert = table.insert

local function reverse(t1: {[any]: any}) -- line: 9
	-- upvalues: insert (copy)
	local t2 = {}

	for i = #t1, 1, -1 do
		insert(t2, t1[i])
	end

	return t2
end

return reverse
