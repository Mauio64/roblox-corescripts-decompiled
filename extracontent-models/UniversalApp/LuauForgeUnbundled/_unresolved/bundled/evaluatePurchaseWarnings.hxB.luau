local module = require("@luauforge/bundled/hwQ")
require("@luauforge/bundled/hxA")
local module2 = require("@luauforge/bundled/hxC")

local module3 = require("@luauforge/bundled/hxp")
require("@luauforge/bundled/hxy")
local module4 = require("@luauforge/bundled/hxD")
local module5 = require("@luauforge/bundled/hxF")

local module6 = require("@luauforge/bundled/hxG")
local module7 = require("@luauforge/bundled/hxH")
local module8 = require("@luauforge/bundled/hxI")

local module9 = require("@luauforge/bundled/hxJ")

local set = {
	[module3.U13PaymentModal] = true,
	[module3.U13MonthlyThreshold1Modal] = true,
	[module3.U13MonthlyThreshold2Modal] = true,
	[module3.ParentalConsentWarningPaymentModal13To17] = true,
	[module3.RequireEmailVerification] = true
}

local function getPurchaseWarningAction(p2, p3)
	return module5(p2.productId, not p2.isSubscriber, p3)
end

local function getPurchaseDisabledAction(p2, p3)
	if not p2 then
		return module3.PurchaseDisabledAskParentModal
	end

	if p3 then
		return module3.PurchaseDisabledUpdateSettingsModal
	end

	return module3.PurchaseDisabledRequestPendingModal
end

local function getIneligibleStep(data, localPlayerUserId, p2)
	return module2.all({
		if localPlayerUserId then module6(localPlayerUserId, p2) else module2.resolve(false),
		module7(p2),
		module8(p2)
	}):andThen(function(list)
		local item = list[1]
		local item2 = list[2]
		local item3 = list[3]
		local v7 = data.failureReason == "PurchaseNotEnabled"

		if item3 and not item and not item2 and v7 then
			return {
				action = module3.AccessManagementUpsell,
				accessManagementUpsellDetails = {
					ampFeatureName = "CanChangeSetting",
					ampNamespace = "account_management/SettingsChange",
					ampRecourseData = { enablePurchases = "Enabled" }
				}
			}
		end

		if not (item or v7) then
			return {
				action = module3.GeneralError,
				generalErrorDetails = { failureReason = data.failureReason }
			}
		end

		local v9

		if item3 then
			if item2 then
				v9 = module3.PurchaseDisabledUpdateSettingsModal
			else
				v9 = module3.PurchaseDisabledRequestPendingModal
			end
		else
			v9 = module3.PurchaseDisabledAskParentModal
		end

		return {
			action = v9,
			purchaseDisabledCounterName = item3 and item2 and v7 and "PurchaseDisabledModalShownDisabledBySelf" or "PurchaseDisabledModalShownParentalConsent"
		}
	end)
end

local function evaluatePurchaseWarnings(p2, p3)
	local localPlayerUserId = module.DataHydrationUtils.getLocalPlayerUserId()

	local v5 = module9(localPlayerUserId, p3)
	local v6 = module5(p2.productId, not p2.isSubscriber, p3)

	local v7 = {
		v5,
		(module4(p3):andThen(function(data)
			if data.expirationTimeInMinutes ~= nil then
				return {
					action = module3.EconomicRestriction,
					economicRestrictionDetails = {
						expirationTimeInMinutes = data.expirationTimeInMinutes,
						failureReason = data.failureReason
					}
				}
			end

			if data.isEligible then
				return v6:andThen(function(p4)
					if set[p4] then
						return { action = p4 }
					end

					return nil
				end)
			end

			return getIneligibleStep(data, localPlayerUserId, p3)
		end, function()
			return { action = module3.GeneralError }
		end))
	}
	return module2.all(v7):andThen(function(list)
		local v8 = {}

		if list[1] then
			table.insert(v8, { action = module3.FirstTimePurchaseConsent })
		end

		if list[2] then
			table.insert(v8, list[2])
		end

		return v8
	end)
end

return evaluatePurchaseWarnings
