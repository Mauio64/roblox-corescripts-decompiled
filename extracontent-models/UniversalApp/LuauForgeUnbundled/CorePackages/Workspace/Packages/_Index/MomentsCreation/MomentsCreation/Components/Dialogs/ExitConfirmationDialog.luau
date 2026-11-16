local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local dialog = Foundation.Dialog

local useCreationFlowStrings = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useCreationFlowStrings")

return function(p2)
	local v5 = useCreationFlowStrings()

	return React.createElement(
		dialog.Root,
		{
			disablePortal = false,
			size = Foundation.Enums.DialogSize.Medium,
			hasBackdrop = true
		},
		{
			DialogTitle = React.createElement(dialog.Title, {
				text = v5.LeaveMomentCreationTitle,
				LayoutOrder = 1
			}),
			DialogContent = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
				DialogText = React.createElement(dialog.Text, {
					Text = v5.LeaveMomentCreationBody
				})
			}),
			DialogActions = React.createElement(dialog.Actions, {
				LayoutOrder = 3,
				actions = {
					{
						text = v5.GeneralCtaLeave,
						variant = Foundation.Enums.ButtonVariant.Emphasis,
						onActivated = p2.onConfirm
					},
					{
						text = v5.GeneralCtaCancel,
						variant = Foundation.Enums.ButtonVariant.Standard,
						onActivated = p2.onCancel
					}
				}
			})
		}
	)
end
