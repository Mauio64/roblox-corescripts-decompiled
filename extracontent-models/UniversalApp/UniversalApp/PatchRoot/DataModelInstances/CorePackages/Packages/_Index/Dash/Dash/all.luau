local function v1(p1) -- line: 3
	return p1
end
local function all(t1: {[any]: any}, p2: ((...any) -> ...any)?) -- line: 17
	-- upvalues: v1 (copy)
	local v6 = p2 or v1

	for v7, v8 in t1 do
		if not v6(v8, v7) then
			return false
		end
	end

	return true
end

return all
