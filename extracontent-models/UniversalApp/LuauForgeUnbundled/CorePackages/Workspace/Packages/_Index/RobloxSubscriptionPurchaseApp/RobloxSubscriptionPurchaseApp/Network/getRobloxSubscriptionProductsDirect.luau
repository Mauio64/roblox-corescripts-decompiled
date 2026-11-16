local url = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Http").Url
local GetRobloxSubscriptionProductsModel = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Models/GetRobloxSubscriptionProductsModel")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Constants")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Network/HttpRequest")

local v5 = url.APIS_URL .. "subscriptions/v2/products?"

return function(value)
	local v6 = v5 .. url:makeQueryString({
		productType = Constants.ROBLOX_SUBSCRIPTION_PRODUCT_TYPE,
		includePurchased = "false",
		referrerId = tostring(value or 0)
	})

	return HttpRequest.new():get(v6):andThen(function(options)
		return GetRobloxSubscriptionProductsModel.formatFromRest(options or {})
	end)
end
