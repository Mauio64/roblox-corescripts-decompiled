local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Promise")
local GetRobloxSubscriptionProductsModel = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Models/GetRobloxSubscriptionProductsModel")
require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/LuauPolyfill")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Constants")

local MarketplaceService = game:GetService("MarketplaceService")

return function()
	return Promise.new(function(callback, callback2)
		local success, result = pcall(function()
			return MarketplaceService:GetAvailableSubscriptionProductsAsync(Constants.ROBLOX_SUBSCRIPTION_PRODUCT_TYPE)
		end)

		if success then
			callback(GetRobloxSubscriptionProductsModel.format(result or {}))
		else
			callback2((tostring(result)))
		end
	end)
end
