local function v1() -- line: 3
	return true
end
local function count(t1: {[any]: any}, p1: ((...any) -> ...any)?) -- line: 39
	-- upvalues: v1 (copy)
	local n1 = 0
	local v6 = p1 or v1

	for v7, v8 in t1 do
		if v6(v8, v7) then
			n1 += 1
		end
	end

	return n1
end

return count
