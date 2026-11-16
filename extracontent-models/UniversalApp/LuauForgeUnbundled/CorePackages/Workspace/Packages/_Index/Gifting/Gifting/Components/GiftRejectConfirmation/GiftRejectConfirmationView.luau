local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/Foundation")

local dialog = Foundation.Dialog
local buttonVariant = Foundation.Enums.ButtonVariant
local dialogSize = Foundation.Enums.DialogSize
local orientation = Foundation.Enums.Orientation

local function GiftRejectConfirmationView(props)
	if not props.isOpen then
		return nil
	end

	local v5 = {
		{
			text = props.rejectLabel,
			variant = buttonVariant.Alert,
			isLoading = props.isRejectLoading,
			onActivated = props.onReject
		},
		{
			text = props.cancelLabel,
			variant = buttonVariant.Standard,
			onActivated = props.onCancel
		}
	}

	return React.createElement(
		dialog.Root,
		{
			size = dialogSize.Small,
			hasBackdrop = true,
			disablePortal = false,
			testId = "GiftRejectConfirmationView"
		},
		{
			Title = React.createElement(dialog.Title, { text = props.titleText }),
			Content = React.createElement(dialog.Content, { LayoutOrder = 1 }, {
				Body = React.createElement(dialog.Text, { Text = props.bodyText })
			}),
			Actions = React.createElement(dialog.Actions, {
				LayoutOrder = 2,
				orientation = orientation.Horizontal,
				actions = v5
			})
		}
	)
end

return React.memo(GiftRejectConfirmationView)
