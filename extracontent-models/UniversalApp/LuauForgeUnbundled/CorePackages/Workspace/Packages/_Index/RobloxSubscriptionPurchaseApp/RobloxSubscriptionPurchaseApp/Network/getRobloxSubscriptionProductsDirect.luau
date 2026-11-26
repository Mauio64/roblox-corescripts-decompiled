local url = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Http").Url
local GetRobloxSubscriptionProductsModel = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Models/GetRobloxSubscriptionProductsModel")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Constants")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Network/HttpRequest")

local v5 = url.APIS_URL .. "subscriptions/v2/products?"

return function(value, p2)
	local v8 = {
		productType = Constants.ROBLOX_SUBSCRIPTION_PRODUCT_TYPE,
		includePurchased = "false",
		referrerId = tostring(value or 0),
		includeUpgrades = 0
	}
	local v9 = if p2 ~= nil then tostring(p2) else nil
	v8.includeUpgrades = v9
	local v10 = v5 .. url:makeQueryString(v8)

	return HttpRequest.new():get(v10):andThen(function(options)
		return GetRobloxSubscriptionProductsModel.formatFromRest(options or {})
	end)
end
