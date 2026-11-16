local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local dialog = Foundation.Dialog

local buttonVariant = Foundation.Enums.ButtonVariant
local dialogSize = Foundation.Enums.DialogSize

local function FriendsOnlyShareDialog(props)
	local v5 = useLocalization({
		cancel = LocalizationStrings.SHARE_AUDIENCE_CANCEL,
		description = LocalizationStrings.SHARE_AUDIENCE_FRIENDS_ONLY_DESCRIPTION,
		share = LocalizationStrings.SHARE_AUDIENCE_SHARE,
		title = LocalizationStrings.SHARE_AUDIENCE_FRIENDS_ONLY_TITLE
	})

	local cancel = v5.cancel
	local description = v5.description
	local share = v5.share
	local title = v5.title
	local v6 = {
		LayoutOrder = 3,
		actions = {
			{
				text = share,
				variant = buttonVariant.Emphasis,
				onActivated = props.onShare
			},
			{
				text = cancel,
				variant = buttonVariant.Standard,
				onActivated = props.onCancel
			}
		}
	}

	return React.createElement(dialog.Root, {
		disablePortal = props.disablePortal == true,
		hasBackdrop = props.hasBackdrop == nil or props.hasBackdrop,
		onClose = props.onCancel,
		size = dialogSize.Small,
		testId = "build-friends-only-share-dialog"
	}, {
		Title = React.createElement(dialog.Title, { LayoutOrder = 1, text = title }),
		Content = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
			Description = React.createElement(dialog.Text, { Text = description })
		}),
		Actions = React.createElement(dialog.Actions, v6)
	})
end

return FriendsOnlyShareDialog
