require("@luauforge/bundled/hwQ")
local module = require("@luauforge/bundled/hws")
local sduiErrorType = require("@luauforge/bundled/hwV").SduiErrors.SduiErrorType

local module2 = require("@luauforge/bundled/hxw")
local module3 = require("@luauforge/bundled/hxx")
local module4 = require("@luauforge/bundled/hyD")
local module5 = require("@luauforge/bundled/hyL")

local function noop() end

local function createEntryContext()
	return {
		context = module.SurfaceContext.InApp,
		surfaceName = module.SurfaceName.BuyRobuxPage,
		metadata = {}
	}
end

local function launchNativeRobloxPlusPurchase(p2, p3, p4)
	if module5 then
		module.startRobloxSubscriptionPurchaseFromUpsell({
			subscriptionProductId = p3,
			displayPrice = p4.displayPrice,
			isFreeTrial = p4.isFreeTrial,
			paymentSessionId = module4(),
			entryContext = {
				context = module.SurfaceContext.InApp,
				surfaceName = module.SurfaceName.BuyRobuxPage,
				metadata = {}
			},
			onFlowComplete = noop
		})

		return
	end

	local function fail(p5)
		p2.dependencies.logger.reportError(
			sduiErrorType.FailedToExecuteAction,
			{ name = "BuyRobuxNativePlusPurchase", message = p5 },
			p2.appPage
		)
	end

	local v5 = module2()

	if v5 == nil then
		return
	end

	local v6 = module3()
	module.Network.getRobloxSubscriptionProducts():andThen(function(items)
		v5()

		if not v6() then
			return
		end

		for k, item in items do
			if item.ProductKey.Id == p3 then
				module.startRobloxSubscriptionPurchaseFromUpsell({
					subscriptionProductId = p3,
					productDetails = item,
					paymentSessionId = module4(),
					entryContext = {
						context = module.SurfaceContext.InApp,
						surfaceName = module.SurfaceName.BuyRobuxPage,
						metadata = {}
					},
					onFlowComplete = noop
				})

				return
			end
		end

		local formatted = `Roblox Plus product isn't available to purchase: {p3}`
		p2.dependencies.logger.reportError(
			sduiErrorType.FailedToExecuteAction,
			{ name = "BuyRobuxNativePlusPurchase", message = formatted },
			p2.appPage
		)
	end, function(p5)
		v5()
		local formatted = `Couldn't load Roblox Plus products: {tostring(p5)}`
		p2.dependencies.logger.reportError(
			sduiErrorType.FailedToExecuteAction,
			{ name = "BuyRobuxNativePlusPurchase", message = formatted },
			p2.appPage
		)
	end)
end

return launchNativeRobloxPlusPurchase
