local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local Foundation = require(MomentsCreationParent.Foundation)
local React = require(MomentsCreationParent.React)
local Dialog = Foundation.Dialog
local useCreationFlowStrings = require(MomentsCreation.Hooks.useCreationFlowStrings)

return function(t1: {[any]: any}) -- line: 18
	-- upvalues: useCreationFlowStrings (copy), React (copy), Dialog (copy), Foundation (copy)
	local v8 = useCreationFlowStrings()

	return React.createElement(Dialog.Root, {
		hasBackdrop = true,
		size = Foundation.Enums.DialogSize.Medium
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = v8.StayFriendlyModeration
		}),
		DialogContent = React.createElement(Dialog.Content, {
			LayoutOrder = 2
		}, {
			DialogText = React.createElement(Dialog.Text, {
				Text = v8.CommunityStandardsText
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {{
				text = v8.GeneralCtaOk,
				variant = Foundation.Enums.ButtonVariant.Emphasis,
				onActivated = t1.onConfirm
			}}
		})
	})
end
