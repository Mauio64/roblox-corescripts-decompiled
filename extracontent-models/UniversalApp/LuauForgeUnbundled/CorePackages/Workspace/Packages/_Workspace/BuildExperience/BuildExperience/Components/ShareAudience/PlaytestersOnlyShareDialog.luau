local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local dialog = Foundation.Dialog

local buttonVariant = Foundation.Enums.ButtonVariant
local dialogSize = Foundation.Enums.DialogSize

local function PlaytestersOnlyShareDialog(props)
	local v5 = useLocalization({
		cancel = LocalizationStrings.SHARE_AUDIENCE_CANCEL,
		description = LocalizationStrings.SHARE_AUDIENCE_PLAYTESTERS_ONLY_DESCRIPTION,
		share = LocalizationStrings.SHARE_AUDIENCE_SHARE,
		title = LocalizationStrings.SHARE_AUDIENCE_PLAYTESTERS_ONLY_TITLE
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

	local createElement = React.createElement
	local root = dialog.Root
	local v7 = {
		disablePortal = props.disablePortal == true,
		hasBackdrop = props.hasBackdrop == nil or props.hasBackdrop,
		onClose = props.onCancel,
		size = dialogSize.Small,
		testId = "build-playtesters-only-share-dialog"
	}

	local children = {
		Title = React.createElement(dialog.Title, { LayoutOrder = 1, text = title }),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = dialog.Content

	local v9 = {
		Description = React.createElement(dialog.Text, { Text = description }),
		Error = 0
	}

	local v10 = if props.errorText ~= nil then React.createElement(dialog.Text, {
		Text = props.errorText
	}) else nil
	v9.Error = v10
	children.Content = createElement2(content, { LayoutOrder = 2 }, v9)

	children.Actions = React.createElement(dialog.Actions, v6)
	return createElement(root, v7, children)
end

return PlaytestersOnlyShareDialog
