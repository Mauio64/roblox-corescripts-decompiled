local parent = script:FindFirstAncestor("Gifting").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Dialog = Foundation.Dialog
local ButtonVariant = Foundation.Enums.ButtonVariant
local DialogSize = Foundation.Enums.DialogSize
local Orientation = Foundation.Enums.Orientation

local function GiftRejectConfirmationView(props)
	if not props.isOpen then
		return nil
	end

	local actions = {
		{
			text = props.rejectLabel,
			variant = ButtonVariant.Alert,
			isLoading = props.isRejectLoading,
			onActivated = props.onReject
		},
		{ text = props.cancelLabel, variant = ButtonVariant.Standard, onActivated = props.onCancel }
	}

	return React.createElement(
		Dialog.Root,
		{
			size = DialogSize.Small,
			hasBackdrop = true,
			disablePortal = false,
			testId = "GiftRejectConfirmationView"
		},
		{
			Title = React.createElement(Dialog.Title, { text = props.titleText }),
			Content = React.createElement(Dialog.Content, { LayoutOrder = 1 }, {
				Body = React.createElement(Dialog.Text, { Text = props.bodyText })
			}),
			Actions = React.createElement(Dialog.Actions, {
				LayoutOrder = 2,
				orientation = Orientation.Horizontal,
				actions = actions
			})
		}
	)
end

return React.memo(GiftRejectConfirmationView)
