local getNumericalApplicationId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/Release/getNumericalApplicationId")

local function getRolloutEnabledForUser(callback, p2): boolean
	local v5 = callback()
	local v6 = getNumericalApplicationId(p2)

	if v6 == nil then
		return v5 >= 100
	end

	return v6 % 100 + 1 <= v5
end

return function(callback, p2)
	local v5 = callback()
	local v6 = getNumericalApplicationId(p2)

	local v7 = if v6 == nil then v5 >= 100 else v6 % 100 + 1 <= v5

	return function()
		return v7
	end
end
