local module = require("@luauforge/bundled/hxv")
local module2 = require("@luauforge/bundled/hwH")

local module3 = require("@luauforge/bundled/hyC")
local sduiErrorType = require("@luauforge/bundled/hwV").SduiErrors.SduiErrorType

local module4 = require("@luauforge/bundled/hyD")

local function launchNativeRobuxPurchase(p2, p3, p4)
	local launchRobuxPackagePurchase = module3.launchRobuxPackagePurchase

	if launchRobuxPackagePurchase == nil then
		p2.dependencies.logger.reportError(
			sduiErrorType.FailedToExecuteAction,
			{
				name = "BuyRobuxNativePurchase",
				message = "PurchasePrompt.launchRobuxPackagePurchase is unavailable"
			},
			p2.appPage
		)
		return
	end

	if module then
		module2.trackCounter("MobilePurchaseRedirect")
	end

	launchRobuxPackagePurchase({
		mobileProductId = p4,
		productId = tonumber(p3),
		paymentSessionId = module4(),
		purchaseType = "buyRobuxPage",
		isInApp = true
	})
end

return launchNativeRobuxPurchase
