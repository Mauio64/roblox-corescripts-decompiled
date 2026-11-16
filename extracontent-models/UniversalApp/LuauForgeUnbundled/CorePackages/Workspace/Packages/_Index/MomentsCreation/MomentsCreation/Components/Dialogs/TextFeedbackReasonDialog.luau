local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local dialog = Foundation.Dialog
local text = Foundation.Text
local useLocalization = Localization.Hooks.useLocalization

local useCreationFlowStrings = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useCreationFlowStrings")

local v5 = {
	title = "Feature.Moments.Title.GenerateTextFeedbackReason",
	notHelpful = "Feature.Moments.Action.GenerateTextFeedbackNotHelpful",
	policy = "Feature.Moments.Action.GenerateTextFeedbackPolicy"
}

local function TextFeedbackReasonDialog(props)
	local v6 = useCreationFlowStrings()
	local v7 = useLocalization(v5)

	return React.createElement(
		dialog.Root,
		{
			size = Foundation.Enums.DialogSize.Small,
			hasBackdrop = true,
			disablePortal = false
		},
		{
			DialogTitle = React.createElement(text, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-center content-emphasis",
				Text = v7.title
			}),
			DialogActions = React.createElement(dialog.Actions, {
				LayoutOrder = 2,
				orientation = Foundation.Enums.Orientation.Vertical,
				actions = {
					{
						text = v7.notHelpful,
						variant = Foundation.Enums.ButtonVariant.Standard,
						onActivated = props.onNotHelpful
					},
					{
						text = v7.policy,
						variant = Foundation.Enums.ButtonVariant.Standard,
						onActivated = props.onPolicyViolation
					},
					{
						text = v6.GeneralCtaCancel,
						variant = Foundation.Enums.ButtonVariant.Standard,
						onActivated = props.onDismiss
					}
				}
			})
		}
	)
end

return TextFeedbackReasonDialog
