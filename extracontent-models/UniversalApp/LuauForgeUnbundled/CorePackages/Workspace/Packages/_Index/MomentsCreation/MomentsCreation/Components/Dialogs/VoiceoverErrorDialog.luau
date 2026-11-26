local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local dialog = Foundation.Dialog
local useLocalization = Localization.Hooks.useLocalization

local function VoiceoverErrorDialog(props)
	local v5 = useLocalization({
		title = "CommonUI.Messages.Response.SomethingWentWrong",
		tryAgain = "Feature.Moments.Action.TryAgain"
	})

	return React.createElement(
		dialog.Root,
		{
			size = Foundation.Enums.DialogSize.Small,
			hasBackdrop = true,
			onClose = props.onDismiss
		},
		{
			DialogTitle = React.createElement(dialog.Title, {
				text = v5.title,
				LayoutOrder = 1
			}),
			DialogContent = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
				DialogText = React.createElement(dialog.Text, { Text = props.message })
			}),
			DialogActions = React.createElement(dialog.Actions, {
				LayoutOrder = 3,
				actions = {
					{
						text = v5.tryAgain,
						variant = Foundation.Enums.ButtonVariant.Standard,
						onActivated = props.onTryAgain
					}
				}
			})
		}
	)
end

return VoiceoverErrorDialog
