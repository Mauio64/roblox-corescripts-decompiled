local module = require("@luauforge/bundled/gnx")

local useLocalization = require("@luauforge/bundled/goy").Hooks.useLocalization

local module2 = require("@luauforge/bundled/goz")
local buttonVariant = module2.Enums.ButtonVariant
local dialog = module2.Dialog
local dialogSize = module2.Enums.DialogSize

require("@luauforge/bundled/gnK")

return function(p2)
	local v5 = useLocalization({
		headingText = "Authentication.AccountRecovery.Heading.AccountSecuredConfirmation",
		bodyText = "Authentication.AccountRecovery.Description.AccountSecuredConfirmation",
		okButtonText = "Authentication.AccountRecovery.Action.Ok"
	})

	return module.createElement(
		dialog.Root,
		{ size = dialogSize.Small, disablePortal = false, hasBackdrop = true },
		{
			DialogTitle = module.createElement(dialog.Title, {
				LayoutOrder = 1,
				text = v5.headingText
			}),
			DialogContent = module.createElement(dialog.Content, { LayoutOrder = 2 }, {
				UIListLayout = module.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical
				}),
				DialogText = module.createElement(dialog.Text, {
					LayoutOrder = 1,
					Text = v5.bodyText
				})
			}),
			DialogActions = module.createElement(dialog.Actions, {
				LayoutOrder = 3,
				actions = {
					{
						text = v5.okButtonText,
						variant = buttonVariant.Emphasis,
						onActivated = function()
							p2.onPasswordResetSuccess()
						end
					}
				}
			})
		}
	)
end
