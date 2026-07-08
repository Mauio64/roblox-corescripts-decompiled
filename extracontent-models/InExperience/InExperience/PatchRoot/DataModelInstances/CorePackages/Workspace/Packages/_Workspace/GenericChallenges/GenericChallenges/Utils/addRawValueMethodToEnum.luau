return function(p1, p2) -- line: 9
	local t1 = {}

	for k, v in pairs(p2) do
		t1[p1[k]] = v
	end

	local mt = getmetatable(p1)
	local __index = mt.__index

	function mt.__index(_, p4) -- line: 17
		-- upvalues: t1 (copy), __index (copy)
		if p4 == "toRawValue" then
			return function(p5) -- line: 19
				-- upvalues: t1 (copy)
				return t1[p5]
			end
		end

		return __index[p4]
	end
end
