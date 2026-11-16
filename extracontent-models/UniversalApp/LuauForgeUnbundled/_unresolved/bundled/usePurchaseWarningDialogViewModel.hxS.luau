local useLocalization = require("@luauforge/bundled/hwN").Hooks.useLocalization

local module = require("@luauforge/bundled/hxp")

require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/InExperienceShop/Components/ShopErrorDialog")
local module2 = require("@luauforge/bundled/hwS")

local v5 = {
	[module.U13PaymentModal] = {
		"Feature.Premium.Description.ScaryModalBodyNew",
		lineBreak = "\n\n"
	},
	[module.U13MonthlyThreshold1Modal] = {
		"Feature.Premium.Description.ScaryModalThreshold1Body",
		linebreak = "\n\n"
	},
	[module.U13MonthlyThreshold2Modal] = {
		"Feature.Premium.Description.ScaryModalThreshold2Body",
		linebreak = "\n\n"
	},
	[module.ParentalConsentWarningPaymentModal13To17] = "Feature.Premium.Description.ScaryModalBody13To17"
}

local function usePurchaseWarningDialogViewModel(data)
	local v6 = useLocalization({
		title = "Feature.Premium.Heading.ScaryModalTitle",
		body = v5[data.action],
		ok = "CommonUI.Controls.Action.OK",
		cancel = "CommonUI.Controls.Action.Cancel"
	})

	local v7 = module2(data.onCancel)

	return {
		title = v6.title,
		body = v6.body,
		primaryText = v6.ok,
		onPrimaryActivated = data.onConfirm,
		secondaryText = v6.cancel,
		onSecondaryActivated = data.onCancel,
		onClose = data.onCancel,
		focusRef = v7,
		testId = "purchase-warning-dialog"
	}
end

return usePurchaseWarningDialogViewModel
