local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local AmpUpsellParent = AmpUpsell.Parent
local React = require(AmpUpsellParent.React)
local useLocalization = require(AmpUpsellParent.Localization).Hooks.useLocalization
local Foundation = require(AmpUpsellParent.Foundation)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local authModalShown = require(AmpUpsellParent.AuthAnalytics).Events.authModalShown
local GetFFlagEnableAmpUserMismatchTelemetry = require(AmpUpsell.Flags.GetFFlagEnableAmpUserMismatchTelemetry)

local function AmpWizardUserMismatchModal(t1: {[any]: any}) -- line: 22
	-- upvalues: useLocalization (copy), React (copy), GetFFlagEnableAmpUserMismatchTelemetry (copy), authModalShown (copy), Dialog (copy), DialogSize (copy), ButtonVariant (copy)
	local navigation = t1.navigation
	local entryPointEventCtx = t1.entryPointEventCtx
	local v15 = useLocalization({
		title = "Amp.ErrorScreen.UserMismatchTitle",
		description = "Amp.ErrorScreen.UserMismatchBody",
		ok = "CommonUI.Controls.Action.OK"
	})

	React.useEffect(function() -- line: 32
		-- upvalues: GetFFlagEnableAmpUserMismatchTelemetry (copy), authModalShown (copy), entryPointEventCtx (copy)
		if GetFFlagEnableAmpUserMismatchTelemetry() then
			authModalShown(entryPointEventCtx or "", nil, "userMismatch")
		end
	end, { entryPointEventCtx })

	local v16 = React.useCallback(function() -- line: 38
		-- upvalues: navigation (copy)
		navigation.goBack()
	end, { navigation })

	return React.createElement(Dialog.Root, {
		size = DialogSize.Medium
	}, {
		Title = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = v15.title
		}),
		BodyText = React.createElement(Dialog.Text, {
			LayoutOrder = 2,
			Text = v15.description
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {{
				text = v15.ok,
				variant = ButtonVariant.Emphasis,
				onActivated = v16
			}}
		})
	})
end

return AmpWizardUserMismatchModal
