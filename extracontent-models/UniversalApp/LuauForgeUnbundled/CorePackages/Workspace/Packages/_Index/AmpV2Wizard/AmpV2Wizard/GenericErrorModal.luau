local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/Localization").Hooks.useLocalization

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/Foundation")
local dialog = Foundation.Dialog
local buttonVariant = Foundation.Enums.ButtonVariant
local dialogSize = Foundation.Enums.DialogSize
local orientation = Foundation.Enums.Orientation

local function GenericErrorModal(p2)
	local v5 = useLocalization({
		title = "Feature.Parents.Title.SomethingWentWrong",
		close = "Common.VerifiedParentalConsent.Action.Close"
	})

	return React.createElement(dialog.Root, {
		size = dialogSize.Small,
		onClose = p2.onClose
	}, {
		Title = React.createElement(dialog.Title, { LayoutOrder = 1, text = v5.title }),
		Actions = React.createElement(dialog.Actions, {
			LayoutOrder = 2,
			orientation = orientation.Vertical,
			actions = {
				{
					text = v5.close,
					variant = buttonVariant.Emphasis,
					onActivated = p2.onClose
				}
			}
		})
	})
end

return GenericErrorModal
