local function deepcopy(p1) -- line: 1
	-- upvalues: deepcopy (copy)
	if type(p1) == "table" then
		local t1 = {}

		for k, v in next, p1 do
			t1[deepcopy(k)] = deepcopy(v)
		end

		setmetatable(t1, deepcopy((getmetatable(p1))))

		return t1
	end

	return p1
end

return deepcopy
