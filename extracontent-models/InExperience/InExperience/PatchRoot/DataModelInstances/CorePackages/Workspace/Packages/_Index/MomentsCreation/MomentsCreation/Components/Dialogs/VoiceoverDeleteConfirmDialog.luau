local parent = script:FindFirstAncestor("MomentsCreation").Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)

local Dialog = Foundation.Dialog
local useLocalization = Localization.Hooks.useLocalization

local function VoiceoverDeleteConfirmDialog(p)
	local v = useLocalization({
		title = "Feature.Moments.Label.DeleteVoiceoverTitle",
		body = "Feature.Moments.Label.DeleteVoiceoverBody",
		delete = "Feature.Moments.Action.Delete",
		cancel = "Feature.Moments.Action.Cancel"
	})

	return React.createElement(Dialog.Root, {
		size = Foundation.Enums.DialogSize.Small,
		hasBackdrop = true
	}, {
		DialogTitle = React.createElement(Dialog.Title, { text = v.title, LayoutOrder = 1 }),
		DialogContent = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
			DialogText = React.createElement(Dialog.Text, { Text = v.body })
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			orientation = Foundation.Enums.Orientation.Vertical,
			actions = {
				{
					text = v.delete,
					variant = Foundation.Enums.ButtonVariant.Alert,
					onActivated = p.onConfirm
				},
				{
					text = v.cancel,
					variant = Foundation.Enums.ButtonVariant.Standard,
					onActivated = p.onCancel
				}
			}
		})
	})
end

return VoiceoverDeleteConfirmDialog
