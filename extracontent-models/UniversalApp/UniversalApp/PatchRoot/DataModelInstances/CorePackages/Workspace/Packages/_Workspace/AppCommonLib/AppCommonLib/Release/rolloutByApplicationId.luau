local getNumericalApplicationId = require(script.Parent.getNumericalApplicationId)

local function getRolloutEnabledForUser(p1: ((...any) -> ...any), p2) -- line: 9
	-- upvalues: getNumericalApplicationId (copy)
	local v5 = p1()
	local v6 = getNumericalApplicationId(p2)

	if v6 == nil then
		return v5 >= 100
	end

	return v5 >= v6 % 100 + 1
end

return function(p3: ((...any) -> ...any), p4) -- line: 28
	-- upvalues: getNumericalApplicationId (copy)
	local v9 = p3()
	local v10 = getNumericalApplicationId(p4)
	local v11 = if v10 ~= nil then v9 >= v10 % 100 + 1 else v9 >= 100

	return function() -- line: 34
		-- upvalues: v11 (copy)
		return v11
	end
end
