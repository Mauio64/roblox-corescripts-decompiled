local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local MomentsCreationFlowParent = MomentsCreationFlow.Parent
local React = require(MomentsCreationFlowParent.React)
local Foundation = require(MomentsCreationFlowParent.Foundation)
local Dialog = Foundation.Dialog
local CreationFlowContext = require(MomentsCreationFlow.Context.CreationFlowContext)
local CreationFlowLocalization = require(MomentsCreationFlow.Enums.CreationFlowLocalization)

return function(t1: {[any]: any}) -- line: 16
	-- upvalues: React (copy), CreationFlowContext (copy), Dialog (copy), Foundation (copy), CreationFlowLocalization (copy)
	local v9 = React.useContext(CreationFlowContext)

	return React.createElement(Dialog.Root, {
		hasBackdrop = true,
		size = Foundation.Enums.DialogSize.Medium
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = v9.getLocalization(CreationFlowLocalization.StayFriendlyModeration)
		}),
		DialogContent = React.createElement(Dialog.Content, {
			LayoutOrder = 2
		}, {
			DialogText = React.createElement(Dialog.Text, {
				Text = v9.getLocalization(CreationFlowLocalization.CommunityStandardsText)
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {{
				text = v9.getLocalization(CreationFlowLocalization.GeneralCtaOk),
				variant = Foundation.Enums.ButtonVariant.Emphasis,
				onActivated = t1.onConfirm
			}}
		})
	})
end
