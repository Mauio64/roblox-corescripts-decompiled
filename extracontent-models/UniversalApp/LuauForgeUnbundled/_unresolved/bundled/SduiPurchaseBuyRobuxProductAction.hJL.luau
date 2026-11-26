local Players = game:GetService("Players")

local module = require("@luauforge/bundled/hId")
local sduiActionType = module.SduiActionType
local getActionTelemetryFieldValue = module.getActionTelemetryFieldValue

local module2 = require("@luauforge/bundled/hJM")
local module3 = require("@luauforge/bundled/hHX")
local module4 = require("@luauforge/bundled/hHI")
local module5 = require("@luauforge/bundled/hJN")
local module6 = require("@luauforge/bundled/hJO")
local module7 = require("@luauforge/bundled/hJT")
local module8 = require("@luauforge/bundled/hIG")
local module9 = require("@luauforge/bundled/hJX")

local function SduiPurchaseBuyRobuxProductAction(p2, p3, p4)
	local purchaseBuyRobuxProduct = sduiActionType.PurchaseBuyRobuxProduct
	local params = module2.getParams(purchaseBuyRobuxProduct, p2, p4)

	if params == nil then
		return
	end

	local requiredString = module2.getRequiredString(purchaseBuyRobuxProduct, params, "productId", p4)

	if requiredString == nil then
		return
	end

	local oneTimeProduct = module3.getOneTimeProduct(requiredString)

	if oneTimeProduct == nil then
		module2.reportInvalid(
			purchaseBuyRobuxProduct,
			p4,
			`productId is not in page data: {requiredString}`,
			"productId"
		)
		return
	end

	if params.isRedirect == true then
		module7(p2, p3, p4, { kind = "package", productId = requiredString })
		return
	end

	local requiredString2 = module2.getRequiredString(
		purchaseBuyRobuxProduct,
		params,
		"providerProductId",
		p4
	)

	if requiredString2 == nil then
		return
	end

	if requiredString2 ~= oneTimeProduct.providerProductId then
		module2.reportInvalid(
			purchaseBuyRobuxProduct,
			p4,
			`providerProductId does not match page data for {requiredString}: {requiredString2}`,
			"providerProductId"
		)

		return
	end

	local purchaseWarningsTracking = module9.createPurchaseWarningsTracking(p4, {
		purchaseFlowUuid = getActionTelemetryFieldValue(p2, p3, module4.PurchaseFlowUuidField),
		productId = requiredString,
		displayName = oneTimeProduct.displayName,
		sectionType = getActionTelemetryFieldValue(p2, p3, "sectionType")
	})

	module8(
		p4,
		{
			productNamespace = "RobuxPackage",
			productId = requiredString,
			isSubscriber = module5(Players.LocalPlayer)
		},
		function()
			module6(p4, requiredString, requiredString2)
		end,
		purchaseWarningsTracking
	)
end

return SduiPurchaseBuyRobuxProductAction
