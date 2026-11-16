local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)

local Dialog = Foundation.Dialog
local Text = Foundation.Text
local useLocalization = Localization.Hooks.useLocalization

local useCreationFlowStrings = require(MomentsCreation.Hooks.useCreationFlowStrings)

local v = {
	title = "Feature.Moments.Title.GenerateTextFeedbackReason",
	notHelpful = "Feature.Moments.Action.GenerateTextFeedbackNotHelpful",
	policy = "Feature.Moments.Action.GenerateTextFeedbackPolicy"
}

local function TextFeedbackReasonDialog(props)
	local v2 = useCreationFlowStrings()
	local v3 = useLocalization(v)

	return React.createElement(
		Dialog.Root,
		{ size = Foundation.Enums.DialogSize.Small, hasBackdrop = true, disablePortal = false },
		{
			DialogTitle = React.createElement(Text, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-center content-emphasis",
				Text = v3.title
			}),
			DialogActions = React.createElement(Dialog.Actions, {
				LayoutOrder = 2,
				orientation = Foundation.Enums.Orientation.Vertical,
				actions = {
					{
						text = v3.notHelpful,
						variant = Foundation.Enums.ButtonVariant.Standard,
						onActivated = props.onNotHelpful
					},
					{
						text = v3.policy,
						variant = Foundation.Enums.ButtonVariant.Standard,
						onActivated = props.onPolicyViolation
					},
					{
						text = v2.GeneralCtaCancel,
						variant = Foundation.Enums.ButtonVariant.Standard,
						onActivated = props.onDismiss
					}
				}
			})
		}
	)
end

return TextFeedbackReasonDialog
