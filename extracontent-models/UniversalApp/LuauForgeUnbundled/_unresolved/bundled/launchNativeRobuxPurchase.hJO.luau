local module = require("@luauforge/bundled/hII")
local module2 = require("@luauforge/bundled/hHL")
local module3 = require("@luauforge/bundled/hHP")

local module4 = require("@luauforge/bundled/hJP")
local sduiErrorType = require("@luauforge/bundled/hId").SduiErrors.SduiErrorType

local module5 = require("@luauforge/bundled/hIJ")
local module6 = require("@luauforge/bundled/hJQ")
local module7 = require("@luauforge/bundled/hJS")

local function launchNativeRobuxPurchase(p2, p3, p4)
	local v5 = nil
	local flag = false
	local function onNativePurchaseLaunched()
		flag = true
	end

	if module2 then
		v5 = module5()

		if v5 == nil then
			return
		end
	end

	local launchRobuxPackagePurchase = module4.launchRobuxPackagePurchase

	if launchRobuxPackagePurchase == nil then
		p2.dependencies.logger.reportError(
			sduiErrorType.FailedToExecuteAction,
			{
				name = "BuyRobuxNativePurchase",
				message = "PurchasePrompt.launchRobuxPackagePurchase is unavailable"
			},
			p2.appPage
		)

		if module2 and v5 then
			v5()
		end
	else
		local function launch()
			if module then
				module3.trackCounter("MobilePurchaseRedirect")
			end

			launchRobuxPackagePurchase({
				mobileProductId = p4,
				productId = tonumber(p3),
				paymentSessionId = module7(),
				purchaseType = "buyRobuxPage",
				isInApp = true,
				onNativePurchaseLaunched = if module2 then onNativePurchaseLaunched else nil
			})
		end

		if module2 and v5 then
			local v6 = nil

			if not xpcall(launch, function(p5)
				v6 = p5
			end) then
				v5()
				error(v6, 0)
			end
		else
			launch()
		end

		if module2 and v5 then
			if flag then
				module6(function(p5)
					v5()
					module3.trackCounter("PurchaseSpinnerEnded", {
						kind = "package",
						reason = p5
					})
				end)
			else
				v5()
			end
		end
	end
end

return launchNativeRobuxPurchase
