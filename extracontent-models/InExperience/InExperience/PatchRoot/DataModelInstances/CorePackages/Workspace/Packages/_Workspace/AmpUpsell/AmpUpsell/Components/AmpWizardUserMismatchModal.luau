local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local parent = AmpUpsell.Parent

local React = require(parent.React)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local Foundation = require(parent.Foundation)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant

local AuthAnalytics = require(parent.AuthAnalytics)
local authModalShown = AuthAnalytics.Events.authModalShown
local GetFFlagEnableAmpUserMismatchTelemetry = require(AmpUpsell.Flags.GetFFlagEnableAmpUserMismatchTelemetry)

local function AmpWizardUserMismatchModal(p)
	local navigation = p.navigation
	local entryPointEventCtx = p.entryPointEventCtx

	local v = useLocalization({
		title = "Amp.ErrorScreen.UserMismatchTitle",
		description = "Amp.ErrorScreen.UserMismatchBody",
		ok = "CommonUI.Controls.Action.OK"
	})

	React.useEffect(function()
		if GetFFlagEnableAmpUserMismatchTelemetry() then
			authModalShown(entryPointEventCtx or "", nil, "userMismatch")
		end
	end, { entryPointEventCtx })

	local onActivated = React.useCallback(function()
		navigation.goBack()
	end, { navigation })

	return React.createElement(Dialog.Root, { size = DialogSize.Medium }, {
		Title = React.createElement(Dialog.Title, { LayoutOrder = 1, text = v.title }),
		BodyText = React.createElement(Dialog.Text, { LayoutOrder = 2, Text = v.description }),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {
				{ text = v.ok, variant = ButtonVariant.Emphasis, onActivated = onActivated }
			}
		})
	})
end

return AmpWizardUserMismatchModal
