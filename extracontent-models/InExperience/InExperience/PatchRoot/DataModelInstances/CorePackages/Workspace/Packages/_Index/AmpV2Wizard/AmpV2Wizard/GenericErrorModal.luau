local parent = script:FindFirstAncestor("AmpV2Wizard").Parent

local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local Foundation = require(parent.Foundation)
local Dialog = Foundation.Dialog
local ButtonVariant = Foundation.Enums.ButtonVariant
local DialogSize = Foundation.Enums.DialogSize
local Orientation = Foundation.Enums.Orientation

local function GenericErrorModal(p)
	local v = useLocalization({
		title = "Feature.Parents.Title.SomethingWentWrong",
		close = "Common.VerifiedParentalConsent.Action.Close"
	})

	return React.createElement(Dialog.Root, { size = DialogSize.Small, onClose = p.onClose }, {
		Title = React.createElement(Dialog.Title, { LayoutOrder = 1, text = v.title }),
		Actions = React.createElement(Dialog.Actions, {
			LayoutOrder = 2,
			orientation = Orientation.Vertical,
			actions = {
				{ text = v.close, variant = ButtonVariant.Emphasis, onActivated = p.onClose }
			}
		})
	})
end

return GenericErrorModal
