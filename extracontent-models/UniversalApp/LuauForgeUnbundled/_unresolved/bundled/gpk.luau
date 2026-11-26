local module = require("@luauforge/bundled/gnx")

local useLocalization = require("@luauforge/bundled/goy").Hooks.useLocalization

local module2 = require("@luauforge/bundled/goz")
local buttonVariant = module2.Enums.ButtonVariant
local dialog = module2.Dialog
local dialogSize = module2.Enums.DialogSize

local module3 = require("@luauforge/bundled/gnU")
local module4 = require("@luauforge/bundled/gnX")
local module5 = require("@luauforge/bundled/gnY")
require("@luauforge/bundled/gnK")

local getFFlagEnable2SVRecovery = require("@luauforge/bundled/goV").GetFFlagEnable2SVRecovery

return function(props)
	local v5 = module.useContext(module3)

	local v6 = useLocalization({
		headingText = "Authentication.AccountRecovery.Heading.NoChangesMade",
		bodyText = "Authentication.AccountRecovery.Description.NoChangesMade",
		okButtonText = "Authentication.AccountRecovery.Action.Ok"
	})

	local function fn()
		if getFFlagEnable2SVRecovery() and props.shouldPromptPasskeyAddition then
			v5.dispatch({
				type = module4.SET_MODAL_STATE_AND_PROPS,
				data = {
					modalStateAndProps = {
						modalState = module5.ADD_NEW_PASSKEY,
						props = {
							onPasswordResetSuccess = props.onPasswordResetSuccess,
							shouldUpdateEmail = props.shouldUpdateEmail,
							email = props.email,
							userId = props.userId,
							username = props.username
						}
					}
				}
			})
		elseif getFFlagEnable2SVRecovery() and props.shouldPrompt2svRemoval then
			v5.dispatch({
				type = module4.SET_MODAL_STATE_AND_PROPS,
				data = {
					modalStateAndProps = {
						modalState = module5.SAVE_OR_DELETE_TWO_STEP_METHOD,
						props = {
							onPasswordResetSuccess = props.onPasswordResetSuccess,
							shouldUpdateEmail = props.shouldUpdateEmail,
							email = props.email
						}
					}
				}
			})
		elseif props.shouldUpdateEmail then
			v5.dispatch({
				type = module4.SET_MODAL_STATE_AND_PROPS,
				data = {
					modalStateAndProps = {
						modalState = module5.UPDATE_EMAIL,
						props = {
							email = props.email,
							onPasswordResetSuccess = props.onPasswordResetSuccess
						}
					}
				}
			})
		else
			props.onPasswordResetSuccess()
		end
	end

	return module.createElement(
		dialog.Root,
		{ size = dialogSize.Small, disablePortal = false, hasBackdrop = true },
		{
			DialogTitle = module.createElement(dialog.Title, {
				LayoutOrder = 1,
				text = v6.headingText
			}),
			DialogContent = module.createElement(dialog.Content, { LayoutOrder = 2 }, {
				UIListLayout = module.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical
				}),
				DialogText = module.createElement(dialog.Text, {
					LayoutOrder = 1,
					Text = v6.bodyText
				})
			}),
			DialogActions = module.createElement(dialog.Actions, {
				LayoutOrder = 3,
				actions = {
					{
						text = v6.okButtonText,
						variant = buttonVariant.Emphasis,
						onActivated = function()
							fn()
						end
					}
				}
			})
		}
	)
end
