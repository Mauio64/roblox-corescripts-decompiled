local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local dialog = Foundation.Dialog
local useLocalization = Localization.Hooks.useLocalization

local v5 = {
	title = "Feature.Moments.Label.DeleteMomentTitle",
	body = "Feature.Moments.Label.DeleteMomentBody",
	delete = "Feature.Moments.Action.Delete",
	cancel = "Feature.Moments.Action.Cancel"
}

local function DeletionConfirmationDialog(p2)
	local v6 = useLocalization(v5)

	return React.createElement(
		dialog.Root,
		{
			disablePortal = false,
			size = Foundation.Enums.DialogSize.Medium,
			hasBackdrop = true
		},
		{
			DialogTitle = React.createElement(dialog.Title, {
				text = v6.title,
				LayoutOrder = 1
			}),
			DialogContent = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
				DialogText = React.createElement(dialog.Text, { Text = v6.body })
			}),
			DialogActions = React.createElement(dialog.Actions, {
				LayoutOrder = 3,
				actions = {
					{
						text = v6.delete,
						variant = Foundation.Enums.ButtonVariant.Emphasis,
						onActivated = p2.onConfirm
					},
					{
						text = v6.cancel,
						variant = Foundation.Enums.ButtonVariant.Standard,
						onActivated = p2.onCancel
					}
				}
			})
		}
	)
end

return DeletionConfirmationDialog
