local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent

local Http = require(parent.Http)
local Url = Http.Url
local GetRobloxSubscriptionProductsModel = require(RobloxSubscriptionPurchaseApp.Models.GetRobloxSubscriptionProductsModel)
local Constants = require(RobloxSubscriptionPurchaseApp.Constants)
local HttpRequest = require(script.Parent.HttpRequest)

local v = Url.APIS_URL .. "subscriptions/v2/products?"

return function(value: number?, flag: boolean?)
	local v2 = {
		productType = Constants.ROBLOX_SUBSCRIPTION_PRODUCT_TYPE,
		includePurchased = "false",
		referrerId = tostring(value or 0),
		includeUpgrades = 0
	}
	local includeUpgrades

	if flag ~= nil then
		includeUpgrades = tostring(flag)
	end

	v2.includeUpgrades = includeUpgrades
	local v3 = v .. Url:makeQueryString(v2)

	return HttpRequest.new():get(v3):andThen(function(options)
		return (GetRobloxSubscriptionProductsModel.formatFromRest(options or {}))
	end)
end
