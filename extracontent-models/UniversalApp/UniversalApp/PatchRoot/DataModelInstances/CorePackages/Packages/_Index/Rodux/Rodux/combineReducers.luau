local function combineReducers(items)
	return function(p, p2)
		local v = p == nil and {} or p

		local result = {}

		for k, item in pairs(items) do
			result[k] = item(v[k], p2)
		end

		return result
	end
end

return combineReducers
