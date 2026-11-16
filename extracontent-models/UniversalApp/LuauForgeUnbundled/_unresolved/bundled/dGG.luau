return function(p2, items)
	local v5 = {}

	for k, item in pairs(items) do
		v5[p2[k]] = item
	end

	local metatable = getmetatable(p2)
	local __index = metatable.__index
	function metatable.__index(p3, p4)
		if p4 == "toRawValue" then
			return function(p5)
				return v5[p5]
			end
		end

		return __index[p4]
	end
end
