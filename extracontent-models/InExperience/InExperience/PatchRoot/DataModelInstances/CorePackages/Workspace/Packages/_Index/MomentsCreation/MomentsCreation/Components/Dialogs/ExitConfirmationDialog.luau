local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Dialog = Foundation.Dialog

local useCreationFlowStrings = require(MomentsCreation.Hooks.useCreationFlowStrings)

return function(p)
	local v = useCreationFlowStrings()

	return React.createElement(
		Dialog.Root,
		{ disablePortal = false, size = Foundation.Enums.DialogSize.Medium, hasBackdrop = true },
		{
			DialogTitle = React.createElement(Dialog.Title, {
				text = v.LeaveMomentCreationTitle,
				LayoutOrder = 1
			}),
			DialogContent = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
				DialogText = React.createElement(Dialog.Text, { Text = v.LeaveMomentCreationBody })
			}),
			DialogActions = React.createElement(Dialog.Actions, {
				LayoutOrder = 3,
				actions = {
					{
						text = v.GeneralCtaLeave,
						variant = Foundation.Enums.ButtonVariant.Emphasis,
						onActivated = p.onConfirm
					},
					{
						text = v.GeneralCtaCancel,
						variant = Foundation.Enums.ButtonVariant.Standard,
						onActivated = p.onCancel
					}
				}
			})
		}
	)
end
