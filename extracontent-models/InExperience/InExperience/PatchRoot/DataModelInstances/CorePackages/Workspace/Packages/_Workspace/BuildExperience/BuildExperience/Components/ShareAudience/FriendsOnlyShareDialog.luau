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

local function FriendsOnlyShareDialog(props)
	local v = useLocalization({
		cancel = LocalizationStrings.SHARE_AUDIENCE_CANCEL,
		description = LocalizationStrings.SHARE_AUDIENCE_FRIENDS_ONLY_DESCRIPTION,
		share = LocalizationStrings.SHARE_AUDIENCE_SHARE,
		title = LocalizationStrings.SHARE_AUDIENCE_FRIENDS_ONLY_TITLE
	})

	local cancel = v.cancel
	local description = v.description
	local share = v.share
	local title = v.title
	local v2 = {
		LayoutOrder = 3,
		actions = {
			{ text = share, variant = ButtonVariant.Emphasis, onActivated = props.onShare },
			{ text = cancel, variant = ButtonVariant.Standard, onActivated = props.onCancel }
		}
	}

	return React.createElement(Dialog.Root, {
		disablePortal = props.disablePortal == true,
		hasBackdrop = props.hasBackdrop == nil or props.hasBackdrop,
		onClose = props.onCancel,
		size = DialogSize.Small,
		testId = "build-friends-only-share-dialog"
	}, {
		Title = React.createElement(Dialog.Title, { LayoutOrder = 1, text = title }),
		Content = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
			Description = React.createElement(Dialog.Text, { Text = description })
		}),
		Actions = React.createElement(Dialog.Actions, v2)
	})
end

return FriendsOnlyShareDialog
