local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local dialog = Foundation.Dialog
local useLocalization = Localization.Hooks.useLocalization

local function VoiceoverDeleteConfirmDialog(p2)
	local v5 = useLocalization({
		title = "Feature.Moments.Label.DeleteVoiceoverTitle",
		body = "Feature.Moments.Label.DeleteVoiceoverBody",
		delete = "Feature.Moments.Action.Delete",
		cancel = "Feature.Moments.Action.Cancel"
	})

	return React.createElement(
		dialog.Root,
		{ size = Foundation.Enums.DialogSize.Small, hasBackdrop = true },
		{
			DialogTitle = React.createElement(dialog.Title, {
				text = v5.title,
				LayoutOrder = 1
			}),
			DialogContent = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
				DialogText = React.createElement(dialog.Text, { Text = v5.body })
			}),
			DialogActions = React.createElement(dialog.Actions, {
				LayoutOrder = 3,
				orientation = Foundation.Enums.Orientation.Vertical,
				actions = {
					{
						text = v5.delete,
						variant = Foundation.Enums.ButtonVariant.Alert,
						onActivated = p2.onConfirm
					},
					{
						text = v5.cancel,
						variant = Foundation.Enums.ButtonVariant.Standard,
						onActivated = p2.onCancel
					}
				}
			})
		}
	)
end

return VoiceoverDeleteConfirmDialog
