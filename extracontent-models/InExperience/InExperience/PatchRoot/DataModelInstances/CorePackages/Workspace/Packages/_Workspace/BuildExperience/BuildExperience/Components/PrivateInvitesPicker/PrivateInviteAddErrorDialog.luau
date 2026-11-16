local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local Dialog = Foundation.Dialog

local ButtonVariant = Foundation.Enums.ButtonVariant
local DialogSize = Foundation.Enums.DialogSize

local function PrivateInviteAddErrorDialog(p)
	local v = useLocalization({
		action = LocalizationStrings.PRIVATE_INVITES_ADD_ERROR_ACTION,
		body = LocalizationStrings.PRIVATE_INVITES_ADD_ERROR,
		title = LocalizationStrings.PRIVATE_INVITES_ADD_ERROR_TITLE
	})

	return React.createElement(
		Dialog.Root,
		{
			onClose = p.onDismiss,
			size = DialogSize.Small,
			testId = "build-private-invite-add-error-dialog"
		},
		{
			Title = React.createElement(Dialog.Title, { LayoutOrder = 1, text = v.title }),
			Content = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
				Body = React.createElement(Dialog.Text, { Text = v.body })
			}),
			Actions = React.createElement(Dialog.Actions, {
				LayoutOrder = 3,
				actions = {
					{ text = v.action, variant = ButtonVariant.Emphasis, onActivated = p.onDismiss }
				}
			})
		}
	)
end

return PrivateInviteAddErrorDialog
