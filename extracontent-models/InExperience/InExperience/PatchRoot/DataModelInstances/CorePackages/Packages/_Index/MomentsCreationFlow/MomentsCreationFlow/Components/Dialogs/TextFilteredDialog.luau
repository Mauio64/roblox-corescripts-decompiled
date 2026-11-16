local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local parent = MomentsCreationFlow.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local Dialog = Foundation.Dialog

local CreationFlowContext = require(MomentsCreationFlow.Context.CreationFlowContext)
local CreationFlowLocalization = require(MomentsCreationFlow.Enums.CreationFlowLocalization)

return function(p)
	local v = React.useContext(CreationFlowContext)

	return React.createElement(Dialog.Root, {
		size = Foundation.Enums.DialogSize.Medium,
		hasBackdrop = true
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			text = v.getLocalization(CreationFlowLocalization.StayFriendlyModeration),
			LayoutOrder = 1
		}),
		DialogContent = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
			DialogText = React.createElement(Dialog.Text, {
				Text = v.getLocalization(CreationFlowLocalization.CommunityStandardsText)
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {
				{
					text = v.getLocalization(CreationFlowLocalization.GeneralCtaOk),
					variant = Foundation.Enums.ButtonVariant.Emphasis,
					onActivated = p.onConfirm
				}
			}
		})
	})
end
