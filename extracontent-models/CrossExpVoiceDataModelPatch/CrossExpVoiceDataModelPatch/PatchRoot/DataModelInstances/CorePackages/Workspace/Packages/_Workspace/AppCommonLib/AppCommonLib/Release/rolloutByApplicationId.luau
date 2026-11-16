local getNumericalApplicationId = require(script.Parent.getNumericalApplicationId)

local function getRolloutEnabledForUser(callback, p): boolean -- 1 equivalent call inferred from this helper
	local v = callback()
	local numericalApplicationId = getNumericalApplicationId(p)

	if numericalApplicationId == nil then
		return v >= 100
	end

	return numericalApplicationId % 100 + 1 <= v
end

return function(callback, p)
	local rolloutEnabledForUser = getRolloutEnabledForUser(callback, p) -- inferred equivalent call
	return function()
		return rolloutEnabledForUser
	end
end
