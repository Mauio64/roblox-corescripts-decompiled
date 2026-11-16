local parent = script:FindFirstAncestor("Moments").Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)

local Dialog = Foundation.Dialog
local useLocalization = Localization.Hooks.useLocalization

local v = {
	title = "Feature.Moments.Label.DeleteMomentTitle",
	body = "Feature.Moments.Label.DeleteMomentBody",
	delete = "Feature.Moments.Action.Delete",
	cancel = "Feature.Moments.Action.Cancel"
}

local function DeletionConfirmationDialog(p)
	local v2 = useLocalization(v)

	return React.createElement(
		Dialog.Root,
		{ disablePortal = false, size = Foundation.Enums.DialogSize.Medium, hasBackdrop = true },
		{
			DialogTitle = React.createElement(Dialog.Title, { text = v2.title, LayoutOrder = 1 }),
			DialogContent = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
				DialogText = React.createElement(Dialog.Text, { Text = v2.body })
			}),
			DialogActions = React.createElement(Dialog.Actions, {
				LayoutOrder = 3,
				actions = {
					{
						text = v2.delete,
						variant = Foundation.Enums.ButtonVariant.Emphasis,
						onActivated = p.onConfirm
					},
					{
						text = v2.cancel,
						variant = Foundation.Enums.ButtonVariant.Standard,
						onActivated = p.onCancel
					}
				}
			})
		}
	)
end

return DeletionConfirmationDialog
