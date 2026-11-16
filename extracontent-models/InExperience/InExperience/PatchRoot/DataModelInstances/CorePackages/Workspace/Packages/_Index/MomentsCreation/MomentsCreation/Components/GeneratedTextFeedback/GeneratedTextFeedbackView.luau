local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local IconButton = Foundation.IconButton
local Text = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant
local InputSize = Foundation.Enums.InputSize

local TextFeedbackReasonDialog = require(MomentsCreation.Components.Dialogs.TextFeedbackReasonDialog)

local GetFFlagMomentsGeneratedTextDisclosureWrap = require(MomentsCreation.Flags.GetFFlagMomentsGeneratedTextDisclosureWrap)

local function GeneratedTextFeedbackView(props)
	if not props.visible then
		return nil
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local createElement2 = React.createElement
	local v = {
		LayoutOrder = props.layoutOrder,
		tag = "col align-x-center gap-small size-full-0 auto-y"
	}

	local v2 = {
		Disclosure = React.createElement(Text, {
			LayoutOrder = 1,
			tag = GetFFlagMomentsGeneratedTextDisclosureWrap and "size-full-0 auto-y text-body-small text-wrap text-align-x-center text-align-y-top content-neutral" or "size-full-0 auto-y text-body-small text-align-x-center text-align-y-top content-neutral",
			Text = props.disclosureText
		}),
		Icons = 0
	}

	local createElement3 = React.createElement

	local createElement4 = React.createElement
	local icon

	if props.selectedAction == "thumbs_up" then
		icon = { name = IconName.ThumbUp, variant = IconVariant.Filled }
	else
		icon = IconName.ThumbUp
	end

	local children = {
		ThumbsUp = createElement4(IconButton, {
			LayoutOrder = 1,
			icon = icon,
			onActivated = props.onThumbsUp,
			size = InputSize.Small,
			variant = ButtonVariant.Utility,
			testId = "generated-text-feedback-thumbs-up"
		}),
		ThumbsDown = 0
	}

	local createElement5 = React.createElement
	local icon2

	if props.selectedAction == "thumbs_down" then
		icon2 = { name = IconName.ThumbDown, variant = IconVariant.Filled }
	else
		icon2 = IconName.ThumbDown
	end

	children.ThumbsDown = createElement5(IconButton, {
		LayoutOrder = 2,
		icon = icon2,
		onActivated = props.onThumbsDown,
		size = InputSize.Small,
		variant = ButtonVariant.Utility,
		testId = "generated-text-feedback-thumbs-down"
	})
	v2.Icons = createElement3(
		View,
		{ LayoutOrder = 2, tag = "row align-x-center align-y-center gap-small auto-xy" },
		children
	)
	local v3 = { Feedback = createElement2(View, v, v2), ReasonDialog = 0 }
	local reasonDialog

	if props.showReasonDialog then
		reasonDialog = React.createElement(TextFeedbackReasonDialog, {
			onNotHelpful = props.onNotHelpful,
			onPolicyViolation = props.onPolicyViolation,
			onDismiss = props.onDismissDialog
		})
	end

	v3.ReasonDialog = reasonDialog
	return createElement(fragment, nil, v3)
end

return GeneratedTextFeedbackView
