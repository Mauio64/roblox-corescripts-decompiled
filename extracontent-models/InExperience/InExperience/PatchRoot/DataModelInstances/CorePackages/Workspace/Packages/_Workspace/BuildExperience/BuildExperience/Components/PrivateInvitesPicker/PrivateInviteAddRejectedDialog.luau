local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local PrivateInviteUserRow = require(script.Parent.PrivateInviteUserRow)

local Dialog = Foundation.Dialog
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local DialogSize = Foundation.Enums.DialogSize

local function PrivateInviteAddRejectedDialog(p)
	local v = useLocalization({
		action = LocalizationStrings.PRIVATE_INVITES_ADD_ERROR_ACTION,
		title = LocalizationStrings.PRIVATE_INVITES_ADD_REJECTED_TITLE,
		unknownUser = LocalizationStrings.PRIVATE_INVITES_UNKNOWN_USER
	})

	local children = {}

	for k, rejectedUserId in p.rejectedUserIds do
		children[`user-{rejectedUserId}`] = React.createElement(PrivateInviteUserRow, {
			userId = rejectedUserId,
			layoutOrder = k,
			unknownText = v.unknownUser
		})
	end

	return React.createElement(
		Dialog.Root,
		{
			onClose = p.onDismiss,
			size = DialogSize.Small,
			testId = "build-private-invite-add-rejected-dialog"
		},
		{
			Title = React.createElement(Dialog.Title, { LayoutOrder = 1, text = v.title }),
			Content = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
				Users = React.createElement(View, { tag = "col gap-xsmall size-full-0 auto-y" }, children)
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

return PrivateInviteAddRejectedDialog
