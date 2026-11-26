local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/React")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Localization").Hooks.useLocalization

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Foundation")
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local buttonVariant = Foundation.Enums.ButtonVariant

local authModalShown = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AuthAnalytics").Events.authModalShown
local GetFFlagEnableAmpUserMismatchTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableAmpUserMismatchTelemetry")

local function AmpWizardUserMismatchModal(p2)
	local navigation = p2.navigation
	local entryPointEventCtx = p2.entryPointEventCtx

	local v5 = useLocalization({
		title = "Amp.ErrorScreen.UserMismatchTitle",
		description = "Amp.ErrorScreen.UserMismatchBody",
		ok = "CommonUI.Controls.Action.OK"
	})

	React.useEffect(function()
		if GetFFlagEnableAmpUserMismatchTelemetry() then
			authModalShown(entryPointEventCtx or "", nil, "userMismatch")
		end
	end, { entryPointEventCtx })

	local v6 = React.useCallback(function()
		navigation.goBack()
	end, { navigation })

	return React.createElement(dialog.Root, { size = dialogSize.Medium }, {
		Title = React.createElement(dialog.Title, { LayoutOrder = 1, text = v5.title }),
		BodyText = React.createElement(dialog.Text, {
			LayoutOrder = 2,
			Text = v5.description
		}),
		DialogActions = React.createElement(dialog.Actions, {
			LayoutOrder = 3,
			actions = {
				{ text = v5.ok, variant = buttonVariant.Emphasis, onActivated = v6 }
			}
		})
	})
end

return AmpWizardUserMismatchModal
