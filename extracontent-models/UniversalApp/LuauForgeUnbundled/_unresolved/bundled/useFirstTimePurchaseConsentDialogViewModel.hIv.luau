local module = require("@luauforge/bundled/hHu")
local useLocalization = require("@luauforge/bundled/hHV").Hooks.useLocalization
local useOpenWebView = require("@luauforge/bundled/hIw").useOpenWebView

local module2 = require("@luauforge/bundled/hIx")
local module3 = require("@luauforge/bundled/hIy")

require("@luauforge/bundled/hIs")
local module4 = require("@luauforge/bundled/hIt")
local module5 = require("@luauforge/bundled/hIa")

local LINK_START = module4.LINK_START
local LINK_END = module4.LINK_END

local v5 = {
	title = "Feature.VerifiedParentalControls.Label.AskParentFirst",
	description = {
		"Feature.VerifiedParentalControls.Description.ParentalApprovalRequired",
		learnLinkStart = LINK_START,
		learnLinkEnd = LINK_END
	},
	confirmation = {
		"Feature.VerifiedParentalControls.Description.ParentalApprovalConfirmation",
		termsLinkStart = LINK_START,
		termsLinkEnd = LINK_END
	},
	continue = "CommonUI.Controls.Action.Continue",
	cancel = "CommonUI.Controls.Action.Cancel"
}

local function useFirstTimePurchaseConsentDialogViewModel(p2)
	local v6 = useLocalization(v5)
	local v7 = useOpenWebView()

	local state, setState = module.useState(false)
	local v8 = module5(p2.onCancel)

	local v9 = module.useCallback(function(p3)
		setState(p3 == true)
	end, {})

	local v10 = module.useCallback(function()
		v7(module2, "")
	end, { v7 })

	local v11 = module.useCallback(function()
		v7(module3, "")
	end, { v7 })

	return {
		title = v6.title,
		description = v6.description,
		confirmation = v6.confirmation,
		continueText = v6.continue,
		cancelText = v6.cancel,
		isConsentChecked = state,
		onCheckboxActivated = v9,
		onLearnMoreActivated = v10,
		onTermsOfUseActivated = v11,
		onConfirm = p2.onConfirm,
		onCancel = p2.onCancel,
		focusRef = v8
	}
end

return useFirstTimePurchaseConsentDialogViewModel
