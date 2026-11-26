require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/types")
local function deepEqual(items, items2): boolean
	if type(items) ~= "table" or type(items2) ~= "table" then
		return items == items2
	end

	for k, item in items do
		if not deepEqual(item, items2[k]) then
			return false
		end
	end

	for k in items2 do
		if items[k] == nil then
			return false
		end
	end

	return true
end

return {
	isChanged = function(p2, p3): boolean
		return not deepEqual(p2, p3)
	end
}
