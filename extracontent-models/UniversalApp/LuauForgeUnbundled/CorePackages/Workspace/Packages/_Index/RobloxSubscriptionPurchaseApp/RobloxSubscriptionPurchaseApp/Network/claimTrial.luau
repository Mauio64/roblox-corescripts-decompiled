local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Promise")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/UrlBuilder").UrlBuilder
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/UrlBuilder").UrlBase

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Constants")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Network/HttpRequest")
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/SubscriptionGrantType")

local ROBLOX_SUBSCRIPTION_PRODUCT_TYPE = Constants.ROBLOX_SUBSCRIPTION_PRODUCT_TYPE

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "subscriptions/v2/products",
	query = {
		{
			name = "productType",
			value = ROBLOX_SUBSCRIPTION_PRODUCT_TYPE,
			optional = false
		},
		{ name = "includePurchased", value = "false", optional = false },
		{ name = "grantType", value = "{grantType}", optional = false }
	}
})

local v6 = urlBuilder.new({
	base = urlBase.APIS,
	path = "subscriptions/v2/products/" .. ROBLOX_SUBSCRIPTION_PRODUCT_TYPE .. "/{productId}/claim",
	query = {
		{ name = "grantType", value = "{grantType}", optional = false }
	}
})

return function(p2)
	local v7 = HttpRequest.new()

	return v7:get((v5({ grantType = p2 }))):andThen(function(p3)
		local v8 = p3 and p3.products and p3.products[1]
		local id = v8 and v8.productKey and v8.productKey.id

		if not id or id == "" then
			return Promise.reject("No eligible trial product found")
		end

		return v7:post(v6({ productId = id, grantType = p2 }), {})
	end)
end
