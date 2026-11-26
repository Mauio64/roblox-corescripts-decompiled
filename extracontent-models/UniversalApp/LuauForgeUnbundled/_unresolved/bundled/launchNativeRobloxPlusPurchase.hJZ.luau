require("@luauforge/bundled/hHY")
local module = require("@luauforge/bundled/hHy")
local sduiErrorType = require("@luauforge/bundled/hId").SduiErrors.SduiErrorType

local module2 = require("@luauforge/bundled/hHP")
local module3 = require("@luauforge/bundled/hIJ")
local module4 = require("@luauforge/bundled/hIK")
local module5 = require("@luauforge/bundled/hKa")
local module6 = require("@luauforge/bundled/hJS")
local module7 = require("@luauforge/bundled/hKb")
local module8 = require("@luauforge/bundled/hHL")
local module9 = require("@luauforge/bundled/hJR")

local function noop() end

local function holdPlusPurchase(callback, callback2)
	local thread = nil
	local v5 = nil
	local flag = false
	local flag2 = false
	local function finish(p2)
		if flag then
			return
		end

		flag = true

		if thread ~= nil then
			task.cancel(thread)
			thread = nil
		end

		if v5 ~= nil then
			v5()
			v5 = nil
		end

		callback()

		if p2 ~= nil then
			pcall(module2.trackCounter, "PurchaseSpinnerEnded", {
				kind = "plus",
				reason = p2
			})
		end
	end
	thread = task.delay(module9 / 1000, function()
		thread = nil

		if flag2 then
			finish("timeout")
			return
		end

		if callback2 == nil or callback2() then
			finish("productsTimedOut")
			return
		end

		if flag then
			return
		end

		flag = true

		if thread ~= nil then
			task.cancel(thread)
			thread = nil
		end

		if v5 ~= nil then
			v5()
			v5 = nil
		end

		callback()
	end)
	return {
		onFlowComplete = function()
			finish("flowComplete")
		end,
		release = function()
			if flag then
				return
			end

			flag = true

			if thread ~= nil then
				task.cancel(thread)
				thread = nil
			end

			if v5 ~= nil then
				v5()
				v5 = nil
			end

			callback()
		end,
		isEnded = function()
			return flag
		end,
		watchStoreCancel = function()
			if not flag then
				flag2 = true
				v5 = module5(function()
					finish("storeCancelled")
				end)
			end
		end
	}
end

local function createEntryContext()
	return {
		context = module.SurfaceContext.InApp,
		surfaceName = module.SurfaceName.BuyRobuxPage,
		metadata = {}
	}
end

local function launchNativeRobloxPlusPurchase(p2, p3, p4)
	if module7 then
		local v5 = noop

		if module8 then
			local v6 = module3()

			if v6 == nil then
				return
			end

			local v7 = holdPlusPurchase(v6)
			v7.watchStoreCancel()
			v5 = v7.onFlowComplete
		end

		module.startRobloxSubscriptionPurchaseFromUpsell({
			subscriptionProductId = p3,
			displayPrice = p4.displayPrice,
			isFreeTrial = p4.isFreeTrial,
			paymentSessionId = module6(),
			entryContext = {
				context = module.SurfaceContext.InApp,
				surfaceName = module.SurfaceName.BuyRobuxPage,
				metadata = {}
			},
			onFlowComplete = v5
		})
	else
		local function fail(p5)
			p2.dependencies.logger.reportError(
				sduiErrorType.FailedToExecuteAction,
				{ name = "BuyRobuxNativePlusPurchase", message = p5 },
				p2.appPage
			)
		end

		local v5 = module3()

		if v5 == nil then
			return
		end

		local v6 = module4()

		local v7 = if module8 then holdPlusPurchase(v5, v6) else nil

		module.Network.getRobloxSubscriptionProducts():andThen(function(items)
			if v7 == nil then
				v5()
			elseif v7.isEnded() then
				return
			end

			if v6() then
				for k, item in items do
					if item.ProductKey.Id == p3 then
						if v7 then
							v7.watchStoreCancel()
						end

						local startRobloxSubscriptionPurchaseFromUpsell = module.startRobloxSubscriptionPurchaseFromUpsell
						local v8 = {
							subscriptionProductId = p3,
							productDetails = item,
							paymentSessionId = module6(),
							entryContext = {
								context = module.SurfaceContext.InApp,
								surfaceName = module.SurfaceName.BuyRobuxPage,
								metadata = {}
							},
							onFlowComplete = 0
						}

						local v9 = if v7 then v7.onFlowComplete else noop
						v8.onFlowComplete = v9
						startRobloxSubscriptionPurchaseFromUpsell(v8)

						return
					end
				end

				if v7 then
					v7.release()
				end

				local formatted = `Roblox Plus product isn't available to purchase: {p3}`
				p2.dependencies.logger.reportError(
					sduiErrorType.FailedToExecuteAction,
					{ name = "BuyRobuxNativePlusPurchase", message = formatted },
					p2.appPage
				)
			elseif v7 then
				v7.release()
			end
		end, function(p5)
			if v7 then
				v7.release()
			else
				v5()
			end

			local formatted = `Couldn't load Roblox Plus products: {tostring(p5)}`
			p2.dependencies.logger.reportError(
				sduiErrorType.FailedToExecuteAction,
				{ name = "BuyRobuxNativePlusPurchase", message = formatted },
				p2.appPage
			)
		end)
	end
end

return launchNativeRobloxPlusPurchase
