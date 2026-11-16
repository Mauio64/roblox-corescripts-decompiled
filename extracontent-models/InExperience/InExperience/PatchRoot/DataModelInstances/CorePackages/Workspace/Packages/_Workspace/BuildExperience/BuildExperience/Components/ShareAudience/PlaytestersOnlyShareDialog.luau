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

local function PlaytestersOnlyShareDialog(props)
	local v = useLocalization({
		cancel = LocalizationStrings.SHARE_AUDIENCE_CANCEL,
		description = LocalizationStrings.SHARE_AUDIENCE_PLAYTESTERS_ONLY_DESCRIPTION,
		share = LocalizationStrings.SHARE_AUDIENCE_SHARE,
		title = LocalizationStrings.SHARE_AUDIENCE_PLAYTESTERS_ONLY_TITLE
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

	local createElement = React.createElement
	local root = Dialog.Root
	local v3 = {
		disablePortal = props.disablePortal == true,
		hasBackdrop = props.hasBackdrop == nil or props.hasBackdrop,
		onClose = props.onCancel,
		size = DialogSize.Small,
		testId = "build-playtesters-only-share-dialog"
	}

	local children = {
		Title = React.createElement(Dialog.Title, { LayoutOrder = 1, text = title }),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = Dialog.Content

	local v4 = {
		Description = React.createElement(Dialog.Text, { Text = description }),
		Error = 0
	}
	local err

	if props.errorText ~= nil then
		err = React.createElement(Dialog.Text, { Text = props.errorText })
	end

	v4.Error = err
	children.Content = createElement2(content, { LayoutOrder = 2 }, v4)

	children.Actions = React.createElement(Dialog.Actions, v2)
	return createElement(root, v3, children)
end

return PlaytestersOnlyShareDialog
