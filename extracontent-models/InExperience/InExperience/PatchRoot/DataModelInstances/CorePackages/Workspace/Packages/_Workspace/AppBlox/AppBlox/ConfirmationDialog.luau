local Parent = script:FindFirstAncestor("AppBlox").Parent
local React = require(Parent.React)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local Foundation = require(Parent.Foundation)
local Dialog = Foundation.Dialog
local ButtonVariant = Foundation.Enums.ButtonVariant

return function(t1: {[any]: any}) -- line: 34
	-- upvalues: useLocalization (copy), React (copy), Dialog (copy), ButtonVariant (copy)
	local v8 = useLocalization({
		confirmButtonText = "CommonUI.Controls.Action.Confirm",
		cancelButtonText = "CommonUI.Controls.Action.Cancel"
	})

	return React.createElement(Dialog.Root, {
		hasBackdrop = true,
		disablePortal = t1.disablePortal,
		onClose = if not t1.showCloseButton then nil else t1.onCancel
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			text = t1.title
		}),
		DialogContent = React.createElement(Dialog.Content, nil, {
			DialogText = React.createElement(Dialog.Text, {
				Text = t1.body
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			actions = {
				{
					variant = ButtonVariant.Emphasis,
					text = t1.confirmButtonText or v8.confirmButtonText,
					onActivated = t1.onConfirm
				},
				{
					variant = ButtonVariant.Standard,
					text = t1.cancelButtonText or v8.cancelButtonText,
					onActivated = t1.onCancel
				}
			}
		})
	})
end
