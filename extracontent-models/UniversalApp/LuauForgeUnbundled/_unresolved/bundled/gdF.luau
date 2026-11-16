local module = require("@luauforge/bundled/gdG")
local module2 = require("@luauforge/bundled/fts")

local module3 = require("@luauforge/bundled/gdH")

local v5 = {}

function v5.new()
	return {
		productId = 0,
		mobileProductId = "",
		robuxAmount = 0,
		requiresPremium = false,
		isSubscription = false,
		description = "",
		price = 0,
		currencySymbol = ""
	}
end

function v5.mock()
	return (v5.new())
end

function v5.fromJsonData(data, p2)
	local v6 = v5.new()

	if module() then
		v6.productId = data.productId
	end

	v6.mobileProductId = p2 == Enum.Platform.Android and string.lower(data.mobileProductId)
		or data.mobileProductId

	if module3() and module2() then
		v6.mobileProductId = data.mobileProductId
	end

	v6.robuxAmount = data.robuxAmount
	v6.requiresPremium = data.isSubscriptionOnly
	v6.isSubscription = data.premiumFeatureTypeName == "Subscription"
	v6.description = data.description
	v6.price = data.price.amount
	v6.currencySymbol = data.price.currency.currencySymbol
	return v6
end

return v5
