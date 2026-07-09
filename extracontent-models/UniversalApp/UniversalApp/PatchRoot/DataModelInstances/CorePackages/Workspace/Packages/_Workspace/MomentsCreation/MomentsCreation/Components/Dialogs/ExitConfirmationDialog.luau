local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local Foundation = require(MomentsCreationParent.Foundation)
local React = require(MomentsCreationParent.React)
local Dialog = Foundation.Dialog
local useCreationFlowStrings = require(MomentsCreation.Hooks.useCreationFlowStrings)

return function(t1: {[any]: any}) -- line: 19
	-- upvalues: useCreationFlowStrings (copy), React (copy), Dialog (copy), Foundation (copy)
	local v8 = useCreationFlowStrings()

	return React.createElement(Dialog.Root, {
		disablePortal = false,
		hasBackdrop = true,
		size = Foundation.Enums.DialogSize.Medium
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = v8.LeaveMomentCreationTitle
		}),
		DialogContent = React.createElement(Dialog.Content, {
			LayoutOrder = 2
		}, {
			DialogText = React.createElement(Dialog.Text, {
				Text = v8.LeaveMomentCreationBody
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {
				{
					text = v8.GeneralCtaLeave,
					variant = Foundation.Enums.ButtonVariant.Emphasis,
					onActivated = t1.onConfirm
				},
				{
					text = v8.GeneralCtaCancel,
					variant = Foundation.Enums.ButtonVariant.Standard,
					onActivated = t1.onCancel
				}
			}
		})
	})
end
