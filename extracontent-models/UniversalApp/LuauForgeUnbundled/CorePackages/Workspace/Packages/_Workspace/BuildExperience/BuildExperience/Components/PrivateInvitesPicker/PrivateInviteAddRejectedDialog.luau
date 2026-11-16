local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local PrivateInviteUserRow = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PrivateInvitesPicker/PrivateInviteUserRow")

local dialog = Foundation.Dialog
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local dialogSize = Foundation.Enums.DialogSize

local function PrivateInviteAddRejectedDialog(p2)
	local v5 = useLocalization({
		action = LocalizationStrings.PRIVATE_INVITES_ADD_ERROR_ACTION,
		title = LocalizationStrings.PRIVATE_INVITES_ADD_REJECTED_TITLE,
		unknownUser = LocalizationStrings.PRIVATE_INVITES_UNKNOWN_USER
	})

	local children = {}

	for k, rejectedUserId in p2.rejectedUserIds do
		children[`user-{rejectedUserId}`] = React.createElement(PrivateInviteUserRow, {
			userId = rejectedUserId,
			layoutOrder = k,
			unknownText = v5.unknownUser
		})
	end

	return React.createElement(
		dialog.Root,
		{
			onClose = p2.onDismiss,
			size = dialogSize.Small,
			testId = "build-private-invite-add-rejected-dialog"
		},
		{
			Title = React.createElement(dialog.Title, {
				LayoutOrder = 1,
				text = v5.title
			}),
			Content = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
				Users = React.createElement(view, {
					tag = "col gap-xsmall size-full-0 auto-y"
				}, children)
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

return PrivateInviteAddRejectedDialog
