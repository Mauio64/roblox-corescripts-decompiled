local module = require("@luauforge/bundled/hIH")
local accessResponseEnum = module.AmpEnums.AccessResponseEnum
local module2 = require("@luauforge/bundled/hHr")
require("@luauforge/bundled/hId")
local getSduiPageEntrySnackbarStore = require("@luauforge/bundled/hHx").getSduiPageEntrySnackbarStore

local module3 = require("@luauforge/bundled/hHI")
local module4 = require("@luauforge/bundled/hHP")

local module5 = require("@luauforge/bundled/hII")
local module6 = require("@luauforge/bundled/hIC")
local module7 = require("@luauforge/bundled/hIJ")
local module8 = require("@luauforge/bundled/hIK")
require("@luauforge/bundled/hIL")
local module9 = require("@luauforge/bundled/hIM")
local module10 = require("@luauforge/bundled/hJb")
local module11 = require("@luauforge/bundled/hJc")
local module12 = require("@luauforge/bundled/hIc")

local set = {
	[module6.U13PaymentModal] = true,
	[module6.U13MonthlyThreshold1Modal] = true,
	[module6.U13MonthlyThreshold2Modal] = true,
	[module6.ParentalConsentWarningPaymentModal13To17] = true
}

local v5 = {
	[module6.PurchaseDisabledRequestPendingModal] = "PurchaseDisabledModalShownParentalConsent",
	[module6.PurchaseDisabledUpdateSettingsModal] = "PurchaseDisabledModalShownDisabledBySelf",
	[module6.PurchaseDisabledAskParentModal] = "PurchaseDisabledModalShownParentalConsent"
}

local function noop() end

local function showWarningSnackbar(p2, p3)
	getSduiPageEntrySnackbarStore().show(p2, {
		title = p3,
		icon = module2.Enums.IconName.TriangleExclamation
	})
end

local function showDialog(p2, p3)
	module12().set(module3.PageScopeFieldPurchaseDialog, p3)
end

local function runSteps(data, configKey, p2, p3, callback, callback2, p4)
	if not callback2() then
		return
	end

	local v6 = p2[p3]

	if v6 == nil then
		p4.markPurchaseStarted()
		callback()
	else
		local function runNextStep()
			runSteps(data, configKey, p2, p3 + 1, callback, callback2, p4)
		end

		local action = v6.action
		local localization = data.dependencies.localization
		local tracking = p4.tracking

		if action ~= module6.NoAction and action ~= module6.FirstTimePurchaseConsent then
			p4.markPurchaseStarted()
		end

		if action == module6.NoAction then
			runSteps(data, configKey, p2, p3 + 1, callback, callback2, p4)
		elseif action == module6.FirstTimePurchaseConsent then
			module4.trackCounter("FirstTimePurchaseConsentShown")
			module12().set(module3.PageScopeFieldPurchaseDialog, {
				kind = "consent",
				action = action,
				continuePurchase = runNextStep
			})
		elseif set[action] then
			module4.trackCounter("PurchaseWarningModalShown", { action = action })

			if tracking then
				tracking.onPurchaseWarningShown(action)
			end

			module12().set(module3.PageScopeFieldPurchaseDialog, {
				kind = "warning",
				action = action,
				continuePurchase = runNextStep
			})
			module4.trackCounter("StoppedPurchaseWarning", { action = "PurchaseFlow" })
		elseif v5[action] then
			module4.trackCounter(v6.purchaseDisabledCounterName or v5[action])

			if tracking then
				tracking.onPurchaseDisabledShown(action)
			end

			module12().set(module3.PageScopeFieldPurchaseDialog, {
				kind = "disabled",
				action = action,
				tracking = tracking
			})
			module4.trackCounter("IneligiblePurchase")
		elseif action == module6.RequireEmailVerification then
			if tracking then
				tracking.onPurchaseWarningShown(action)
			end

			module11(data.dependencies.dispatch)
			module4.trackCounter("StoppedPurchaseWarning", { action = action })
			module4.trackCounter("StoppedPurchaseWarning", { action = "PurchaseFlow" })
		elseif action == module6.EconomicRestriction and v6.economicRestrictionDetails then
			local economicRestrictionDetails = v6.economicRestrictionDetails

			if tracking then
				tracking.onEconomicRestrictionShown()
			end

			local v7 = module10(
				localization,
				economicRestrictionDetails.expirationTimeInMinutes,
				economicRestrictionDetails.failureReason
			)
			getSduiPageEntrySnackbarStore().show(configKey, {
				title = v7,
				icon = module2.Enums.IconName.TriangleExclamation
			})

			module4.trackCounter("EconomicRestrictionModalShown")
			module4.trackCounter("IneligiblePurchase")
		elseif action == module6.AccessManagementUpsell and v6.accessManagementUpsellDetails then
			local accessManagementUpsellDetails = v6.accessManagementUpsellDetails
			module4.trackCounter("AccessManagementUpsellModalShown")

			local fn = module5 and function(p5, p6)
				module4.trackCounter("AccessManagementUpsellResult", {
					result = tostring(p5 == accessResponseEnum.Granted)
				})
			end or noop

			data.dependencies.dispatch(module.OpenAmpWizardContainer(
				accessManagementUpsellDetails.ampFeatureName,
				fn,
				accessManagementUpsellDetails.ampRecourseData,
				module3.AmpEntryPointEventCtx,
				nil,
				accessManagementUpsellDetails.ampNamespace,
				nil,
				nil,
				nil,
				true
			))

			module4.trackCounter("IneligiblePurchase")
		else
			local v7 = action == module6.GeneralError

			if v7 then
				local generalErrorDetails = v6.generalErrorDetails

				if generalErrorDetails then
					module4.trackCounter("PurchaseEligibility", {
						failureReason = generalErrorDetails.failureReason
					})
				else
					module4.trackCounter("PurchaseEligibilityFailedToFetch")
				end
			end

			local formatted = localization:Format("Feature.Premium.Heading.GeneralError")
			getSduiPageEntrySnackbarStore().show(configKey, {
				title = formatted,
				icon = module2.Enums.IconName.TriangleExclamation
			})

			if v7 then
				module4.trackCounter("IneligiblePurchase")
			end
		end
	end
end

local function requestPurchaseWarnings(data, p2, p3, p4)
	local configKey = data.configKey or data.appPage
	local v6 = module7()

	if v6 == nil then
		return
	end

	local flag = false
	local v7 = {
		markPurchaseStarted = function()
			if flag then
				return
			end

			flag = true
			module4.trackCounter("StartPurchase", { isQuickPay = "false" })

			if p4 then
				p4.onPurchaseStarted()
			end
		end,
		tracking = p4
	}

	local v8 = module8()

	module9(p2):andThen(function(p5)
		v6()
		runSteps(data, configKey, p5, 1, p3, v8, v7)
	end, function()
		v6()

		if v8() then
			v7.markPurchaseStarted()
			module4.trackCounter("PurchaseEligibilityFailedToFetch")
			local formatted = data.dependencies.localization:Format("Feature.Premium.Heading.GeneralError")
			getSduiPageEntrySnackbarStore().show(configKey, {
				title = formatted,
				icon = module2.Enums.IconName.TriangleExclamation
			})

			module4.trackCounter("IneligiblePurchase")
		end
	end)
end

return requestPurchaseWarnings
