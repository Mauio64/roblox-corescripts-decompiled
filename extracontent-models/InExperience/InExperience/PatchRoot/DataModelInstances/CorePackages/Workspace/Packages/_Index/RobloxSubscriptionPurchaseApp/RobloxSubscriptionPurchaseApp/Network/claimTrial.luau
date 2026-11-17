local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent

local Promise = require(parent.Promise)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBuilder2 = require(parent.UrlBuilder)
local UrlBase = UrlBuilder2.UrlBase

local Constants = require(RobloxSubscriptionPurchaseApp.Constants)
local HttpRequest = require(script.Parent.HttpRequest)
require(RobloxSubscriptionPurchaseApp.Enums.SubscriptionGrantType)

local ROBLOX_SUBSCRIPTION_PRODUCT_TYPE = Constants.ROBLOX_SUBSCRIPTION_PRODUCT_TYPE

local v = urlBuilder.new({
	base = UrlBase.APIS,
	path = "subscriptions/v2/products",
	query = {
		{ name = "productType", value = ROBLOX_SUBSCRIPTION_PRODUCT_TYPE, optional = false },
		{ name = "includePurchased", value = "false", optional = false },
		{ name = "grantType", value = "{grantType}", optional = false }
	}
})

local v2 = urlBuilder.new({
	base = UrlBase.APIS,
	path = "subscriptions/v2/products/" .. ROBLOX_SUBSCRIPTION_PRODUCT_TYPE .. "/{productId}/claim",
	query = {
		{ name = "grantType", value = "{grantType}", optional = false }
	}
})

return function(grantType)
	local v3 = HttpRequest.new()

	return v3:get((v({ grantType = grantType }))):andThen(function(p)
		local v4 = p and p.products and p.products[1]
		local id = v4 and v4.productKey and v4.productKey.id

		if not id or id == "" then
			return Promise.reject("No eligible trial product found")
		end

		return v3:post(v2({ productId = id, grantType = grantType }), {})
	end)
end
