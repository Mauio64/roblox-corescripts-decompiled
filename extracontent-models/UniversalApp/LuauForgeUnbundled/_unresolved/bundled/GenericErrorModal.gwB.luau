local module = require("@luauforge/bundled/gvb")
local useLocalization = require("@luauforge/bundled/gvJ").Hooks.useLocalization

local module2 = require("@luauforge/bundled/gvj")
local dialog = module2.Dialog
local buttonVariant = module2.Enums.ButtonVariant
local dialogSize = module2.Enums.DialogSize
local orientation = module2.Enums.Orientation

local function GenericErrorModal(p2)
	local v5 = useLocalization({
		title = "Feature.Parents.Title.SomethingWentWrong",
		close = "Common.VerifiedParentalConsent.Action.Close"
	})

	return module.createElement(dialog.Root, {
		size = dialogSize.Small,
		onClose = p2.onClose
	}, {
		Title = module.createElement(dialog.Title, { LayoutOrder = 1, text = v5.title }),
		Actions = module.createElement(dialog.Actions, {
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
