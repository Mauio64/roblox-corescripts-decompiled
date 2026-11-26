local module = require("@luauforge/bundled/hHu")
local useDispatch = require("@luauforge/bundled/hHA").Hooks.RoactRodux.useDispatch
local useLocalization = require("@luauforge/bundled/hHV").Hooks.useLocalization

local module2 = require("@luauforge/bundled/hIC")

require("@luauforge/bundled/hIA")
local module3 = require("@luauforge/bundled/hID")
require("@luauforge/bundled/hIG")
local module4 = require("@luauforge/bundled/hIa")

local v5 = {
	[module2.PurchaseDisabledRequestPendingModal] = {
		title = "Common.VerifiedParentalConsent.Label.RequestPending",
		body = "Common.VerifiedParentalConsent.Description.ExistingPendingRequestRedirectToSettings"
	},
	[module2.PurchaseDisabledUpdateSettingsModal] = {
		title = "Common.VerifiedParentalConsent.Label.UpdateYourSettings",
		body = "Common.VerifiedParentalConsent.Description.EnablePurchasesInSettings"
	},
	[module2.PurchaseDisabledAskParentModal] = {
		title = "Common.VerifiedParentalConsent.Label.AskParent",
		body = "Common.VerifiedParentalConsent.Description.SpendingRestrictionWithSettings"
	}
}

local function usePurchaseDisabledDialogViewModel(data)
	local v6 = v5[data.action] or v5[module2.PurchaseDisabledAskParentModal]
	local v7 = useLocalization({
		title = v6.title,
		body = v6.body,
		goToSettings = "Common.VerifiedParentalConsent.Action.GoToSettings",
		close = "Common.VerifiedParentalConsent.Action.Close"
	})

	local v8 = useDispatch()
	local v9 = module.useCallback(function()
		local tracking = data.tracking

		if tracking then
			tracking.onPurchaseDisabledClosed(data.action)
		end

		data.onClose()
	end, { data.onClose, data.tracking, data.action })

	local v10 = module4(v9)

	local v11 = module.useCallback(function()
		local tracking = data.tracking

		if tracking then
			tracking.onPurchaseDisabledGoToSettings(data.action)
		end

		data.onClose()
		module3(v8)
	end, { data.onClose, data.tracking, data.action, v8 })

	return {
		title = v7.title,
		body = v7.body,
		primaryText = v7.goToSettings,
		onPrimaryActivated = v11,
		secondaryText = v7.close,
		onSecondaryActivated = v9,
		onClose = v9,
		focusRef = v10,
		testId = "purchase-disabled-dialog"
	}
end

return usePurchaseDisabledDialogViewModel
