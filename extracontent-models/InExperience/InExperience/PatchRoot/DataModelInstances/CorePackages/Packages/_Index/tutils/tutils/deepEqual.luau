local function deepEqual(p1, p2, p3) -- line: 7
	-- upvalues: deepEqual (copy)
	if p1 == p2 then
		return true
	end

	local v5 = type(p1)

	if v5 ~= type(p2) then
		return false
	end

	if v5 ~= "table" then
		return false
	end

	if not p3 then
		local mt = getmetatable(p1)

		if mt and mt.__eq then
			return p1 == p2
		end
	end

	local t1 = {}

	for k, v in pairs(p1) do
		local v10 = p2[k]

		if v10 == nil or not deepEqual(v, v10, p3) then
			return false
		end

		t1[k] = true
	end

	for k, _ in pairs(p2) do
		if not t1[k] then
			return false
		end
	end

	return true
end

return deepEqual
