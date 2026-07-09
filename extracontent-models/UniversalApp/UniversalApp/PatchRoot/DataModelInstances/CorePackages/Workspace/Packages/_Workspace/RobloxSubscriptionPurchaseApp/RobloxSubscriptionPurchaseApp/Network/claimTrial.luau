local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionPurchaseAppParent = RobloxSubscriptionPurchaseApp.Parent
local Promise = require(RobloxSubscriptionPurchaseAppParent.Promise)
local UrlBuilder = require(RobloxSubscriptionPurchaseAppParent.UrlBuilder).UrlBuilder
local UrlBase = require(RobloxSubscriptionPurchaseAppParent.UrlBuilder).UrlBase
local Constants = require(RobloxSubscriptionPurchaseApp.Constants)
local HttpRequest = require(script.Parent.HttpRequest)

require(RobloxSubscriptionPurchaseApp.Enums.SubscriptionGrantType)

local ROBLOX_SUBSCRIPTION_PRODUCT_TYPE = Constants.ROBLOX_SUBSCRIPTION_PRODUCT_TYPE
local v9 = UrlBuilder.new({
	path = "subscriptions/v2/products",
	base = UrlBase.APIS,
	query = {
		{
			name = "productType",
			optional = false,
			value = ROBLOX_SUBSCRIPTION_PRODUCT_TYPE
		},
		{
			name = "includePurchased",
			value = "false",
			optional = false
		},
		{
			name = "grantType",
			value = "{grantType}",
			optional = false
		}
	}
})
local v10 = UrlBuilder.new({
	base = UrlBase.APIS,
	path = "subscriptions/v2/products/" .. ROBLOX_SUBSCRIPTION_PRODUCT_TYPE .. "/{productId}/claim",
	query = {{
		name = "grantType",
		value = "{grantType}",
		optional = false
	}}
})

return function(p1) -- line: 40
	-- upvalues: HttpRequest (copy), v9 (copy), Promise (copy), v10 (copy)
	local v12 = HttpRequest.new()

	return v12:get((v9({
		grantType = p1
	}))):andThen(function(p2) -- line: 45
		-- upvalues: Promise (copy), v10 (copy), p1 (copy), v12 (copy)
		local v14 = p2 and (p2.products and p2.products[1])
		local v15 = v14 and (v14.productKey and v14.productKey.id)

		if not v15 or v15 == "" then
			return Promise.reject("No eligible trial product found")
		end

		local v16 = v10({
			productId = v15,
			grantType = p1
		})

		return v12:post(v16, {})
	end)
end
