local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent

local Http = require(parent.Http)
local Url = Http.Url
local GetRobloxSubscriptionProductsModel = require(RobloxSubscriptionPurchaseApp.Models.GetRobloxSubscriptionProductsModel)
local Constants = require(RobloxSubscriptionPurchaseApp.Constants)
local HttpRequest = require(script.Parent.HttpRequest)

local v = Url.APIS_URL .. "subscriptions/v2/products?"

return function(value: number?)
	local v2 = v .. Url:makeQueryString({
		productType = Constants.ROBLOX_SUBSCRIPTION_PRODUCT_TYPE,
		includePurchased = "false",
		referrerId = tostring(value or 0)
	})

	return HttpRequest.new():get(v2):andThen(function(options)
		return (GetRobloxSubscriptionProductsModel.formatFromRest(options or {}))
	end)
end
