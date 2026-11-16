return function(p, items)
	local v = {}

	for k, item in pairs(items) do
		v[p[k]] = item
	end

	local metatable = getmetatable(p)
	local __index = metatable.__index
	function metatable.__index(_, p2)
		if p2 == "toRawValue" then
			return function(p3)
				return v[p3]
			end
		end

		return __index[p2]
	end
end
