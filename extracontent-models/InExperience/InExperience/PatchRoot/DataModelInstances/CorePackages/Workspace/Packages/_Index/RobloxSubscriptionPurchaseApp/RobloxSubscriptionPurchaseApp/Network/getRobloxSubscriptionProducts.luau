local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent

local Promise = require(parent.Promise)
local GetRobloxSubscriptionProductsModel = require(RobloxSubscriptionPurchaseApp.Models.GetRobloxSubscriptionProductsModel)
require(parent.LuauPolyfill)
local Constants = require(RobloxSubscriptionPurchaseApp.Constants)

local MarketplaceService = game:GetService("MarketplaceService")

return function()
	return Promise.new(function(callback, callback2)
		local success, result = pcall(function()
			return MarketplaceService:GetAvailableSubscriptionProductsAsync(Constants.ROBLOX_SUBSCRIPTION_PRODUCT_TYPE)
		end)

		if success then
			callback((GetRobloxSubscriptionProductsModel.format(result or {})))
		else
			callback2((tostring(result)))
		end
	end)
end
