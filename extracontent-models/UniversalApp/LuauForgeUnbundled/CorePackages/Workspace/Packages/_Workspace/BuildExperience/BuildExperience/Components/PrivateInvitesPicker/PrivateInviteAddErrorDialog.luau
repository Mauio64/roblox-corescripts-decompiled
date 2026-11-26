local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local dialog = Foundation.Dialog

local buttonVariant = Foundation.Enums.ButtonVariant
local dialogSize = Foundation.Enums.DialogSize

local function PrivateInviteAddErrorDialog(p2)
	local v5 = useLocalization({
		action = LocalizationStrings.PRIVATE_INVITES_ADD_ERROR_ACTION,
		body = LocalizationStrings.PRIVATE_INVITES_ADD_ERROR,
		title = LocalizationStrings.PRIVATE_INVITES_ADD_ERROR_TITLE
	})

	return React.createElement(
		dialog.Root,
		{
			onClose = p2.onDismiss,
			size = dialogSize.Small,
			testId = "build-private-invite-add-error-dialog"
		},
		{
			Title = React.createElement(dialog.Title, {
				LayoutOrder = 1,
				text = v5.title
			}),
			Content = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
				Body = React.createElement(dialog.Text, { Text = v5.body })
			}),
			Actions = React.createElement(dialog.Actions, {
				LayoutOrder = 3,
				actions = {
					{
						text = v5.action,
						variant = buttonVariant.Emphasis,
						onActivated = p2.onDismiss
					}
				}
			})
		}
	)
end

return PrivateInviteAddErrorDialog
