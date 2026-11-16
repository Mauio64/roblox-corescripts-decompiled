local parent = script:FindFirstAncestor("MomentsCreation").Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)

local Dialog = Foundation.Dialog
local useLocalization = Localization.Hooks.useLocalization

local function VoiceoverErrorDialog(props)
	local v = useLocalization({
		title = "CommonUI.Messages.Response.SomethingWentWrong",
		tryAgain = "Feature.Moments.Action.TryAgain"
	})

	return React.createElement(
		Dialog.Root,
		{ size = Foundation.Enums.DialogSize.Small, hasBackdrop = true, onClose = props.onDismiss },
		{
			DialogTitle = React.createElement(Dialog.Title, { text = v.title, LayoutOrder = 1 }),
			DialogContent = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
				DialogText = React.createElement(Dialog.Text, { Text = props.message })
			}),
			DialogActions = React.createElement(Dialog.Actions, {
				LayoutOrder = 3,
				actions = {
					{
						text = v.tryAgain,
						variant = Foundation.Enums.ButtonVariant.Standard,
						onActivated = props.onTryAgain
					}
				}
			})
		}
	)
end

return VoiceoverErrorDialog
