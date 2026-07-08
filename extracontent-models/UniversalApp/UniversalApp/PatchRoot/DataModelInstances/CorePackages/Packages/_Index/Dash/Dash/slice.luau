local insert = table.insert

local function slice(t1: {[any]: any}, n1: number?, n2: number?) -- line: 19
	-- upvalues: insert (copy)
	local t2 = {}
	local v7 = n1 or 1
	local v8 = n2 or #t1

	if v7 < 0 then
		v7 = #t1 + v7
	end

	if v8 and v8 < 0 then
		v8 = #t1 + v8
	end

	for i = v7, v8 do
		insert(t2, t1[i])
	end

	return t2
end

return slice
