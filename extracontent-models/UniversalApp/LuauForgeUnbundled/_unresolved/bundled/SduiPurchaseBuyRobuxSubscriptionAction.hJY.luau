local sduiActionType = require("@luauforge/bundled/hId").SduiActionType

local module = require("@luauforge/bundled/hJM")
local module2 = require("@luauforge/bundled/hHX")
local module3 = require("@luauforge/bundled/hJZ")
local module4 = require("@luauforge/bundled/hJT")

local function SduiPurchaseBuyRobuxSubscriptionAction(p2, p3, p4)
	local purchaseBuyRobuxSubscription = sduiActionType.PurchaseBuyRobuxSubscription
	local params = module.getParams(purchaseBuyRobuxSubscription, p2, p4)

	if params == nil then
		return
	end

	local requiredString = module.getRequiredString(purchaseBuyRobuxSubscription, params, "productId", p4)

	if requiredString == nil then
		return
	end

	local subscriptionProduct = module2.getSubscriptionProduct(requiredString)

	if subscriptionProduct == nil then
		module.reportInvalid(
			purchaseBuyRobuxSubscription,
			p4,
			`productId is not in page data: {requiredString}`,
			"productId"
		)
	elseif params.isRedirect == true then
		module4(p2, p3, p4, { kind = "subscription", productId = requiredString })
	else
		module3(p4, requiredString, subscriptionProduct)
	end
end

return SduiPurchaseBuyRobuxSubscriptionAction
