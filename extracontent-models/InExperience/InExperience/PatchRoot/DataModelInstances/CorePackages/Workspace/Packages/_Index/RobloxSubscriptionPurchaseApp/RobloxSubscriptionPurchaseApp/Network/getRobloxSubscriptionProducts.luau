local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionPurchaseAppParent = RobloxSubscriptionPurchaseApp.Parent
local Promise = require(RobloxSubscriptionPurchaseAppParent.Promise)
local GetRobloxSubscriptionProductsModel = require(RobloxSubscriptionPurchaseApp.Models.GetRobloxSubscriptionProductsModel)

require(RobloxSubscriptionPurchaseAppParent.LuauPolyfill)

local Constants = require(RobloxSubscriptionPurchaseApp.Constants)
local MarketplaceService = game:GetService("MarketplaceService")

return function() -- line: 15
	-- upvalues: Promise (copy), MarketplaceService (copy), Constants (copy), GetRobloxSubscriptionProductsModel (copy)
	return Promise.new(function(resolve, reject) -- line: 16
		-- upvalues: MarketplaceService (copy), Constants (copy), GetRobloxSubscriptionProductsModel (copy)
		local ok, result = pcall(function() -- line: 17
			-- upvalues: MarketplaceService (copy), Constants (copy)
			return MarketplaceService:GetAvailableSubscriptionProductsAsync(Constants.ROBLOX_SUBSCRIPTION_PRODUCT_TYPE)
		end)

		if ok then
			resolve((GetRobloxSubscriptionProductsModel.format(result or {})))

			return
		end

		reject((tostring(result)))
	end)
end
