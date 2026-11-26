require("@luauforge/bundled/dzm")

local function combineReducers(items)
	return function(p2, p3, p4)
		local v5 = p2 == nil and {} or p2

		local result = {}
		local flag = false

		for k, item in items do
			local v6 = v5[k]
			local v7 = item(v6, p3, p4)
			result[k] = v7

			if v7 ~= v6 then
				flag = true
			end
		end

		if flag then
			return result
		end

		return v5
	end
end

return combineReducers
