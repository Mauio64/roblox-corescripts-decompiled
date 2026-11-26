local module = require("@luauforge/bundled/gnx")

local useLocalization = require("@luauforge/bundled/goy").Hooks.useLocalization
local useDispatch = require("@luauforge/bundled/gnC").Hooks.RoactRodux.useDispatch
local useRoactService = require("@luauforge/bundled/gnP").useRoactService

local roactNetworking = require("@luauforge/bundled/gnQ").RoactNetworking

local module2 = require("@luauforge/bundled/gnU")
local module3 = require("@luauforge/bundled/goz")
local buttonVariant = module3.Enums.ButtonVariant
local dialog = module3.Dialog
local dialogSize = module3.Enums.DialogSize

local module4 = require("@luauforge/bundled/goS")
require("@luauforge/bundled/gnE")

return function(p2)
	local v5 = module.useContext(module2)

	local v6 = useDispatch()
	local v7 = useRoactService(roactNetworking)

	local state, setState = module.useState(false)

	local v8 = useLocalization({
		updateEmailHeadingText = "Authentication.AccountRecovery.Heading.UpdateEmail",
		updateEmailBodyText = {
			"Authentication.AccountRecovery.Description.UpdateEmailConfirmation",
			email = `{p2.email}`
		},
		okButtonText = "Authentication.AccountRecovery.Action.Ok"
	})

	return module.createElement(
		dialog.Root,
		{ size = dialogSize.Small, disablePortal = false, hasBackdrop = true },
		{
			DialogTitle = module.createElement(dialog.Title, {
				LayoutOrder = 1,
				text = v8.updateEmailHeadingText
			}),
			DialogContent = module.createElement(dialog.Content, { LayoutOrder = 2 }, {
				UIListLayout = module.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical
				}),
				DialogText = module.createElement(dialog.Text, {
					LayoutOrder = 1,
					Text = v8.updateEmailBodyText
				})
			}),
			DialogActions = module.createElement(dialog.Actions, {
				LayoutOrder = 3,
				actions = {
					{
						text = v8.okButtonText,
						variant = buttonVariant.Emphasis,
						onActivated = function()
							if state then
								return
							end

							setState(true)
							v6(module4(v7, {
								recoverySessionId = v5.state.recoverySessionId
							})):andThen(function(p3)
								p2.onPasswordResetSuccess()
							end)
						end
					}
				}
			})
		}
	)
end
