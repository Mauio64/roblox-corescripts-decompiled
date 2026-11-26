local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local iconButton = Foundation.IconButton
local text = Foundation.Text
local view = Foundation.View
local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local iconVariant = Foundation.Enums.IconVariant
local inputSize = Foundation.Enums.InputSize

local TextFeedbackReasonDialog = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/Dialogs/TextFeedbackReasonDialog")

local GetFFlagMomentsGeneratedTextDisclosureWrap = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFFlagMomentsGeneratedTextDisclosureWrap")

local function GeneratedTextFeedbackView(props)
	if not props.visible then
		return nil
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local createElement2 = React.createElement
	local v9 = {
		LayoutOrder = props.layoutOrder,
		tag = "col align-x-center gap-small size-full-0 auto-y"
	}

	local v10 = {
		Disclosure = React.createElement(text, {
			LayoutOrder = 1,
			tag = GetFFlagMomentsGeneratedTextDisclosureWrap and "size-full-0 auto-y text-body-small text-wrap text-align-x-center text-align-y-top content-neutral" or "size-full-0 auto-y text-body-small text-align-x-center text-align-y-top content-neutral",
			Text = props.disclosureText
		}),
		Icons = 0
	}

	local createElement3 = React.createElement

	local createElement4 = React.createElement

	local v15 = if props.selectedAction == "thumbs_up" then {
		name = iconName.ThumbUp,
		variant = iconVariant.Filled
	} else iconName.ThumbUp
	local children = {
		ThumbsUp = createElement4(iconButton, {
			LayoutOrder = 1,
			icon = v15,
			onActivated = props.onThumbsUp,
			size = inputSize.Small,
			variant = buttonVariant.Utility,
			testId = "generated-text-feedback-thumbs-up"
		}),
		ThumbsDown = 0
	}

	local createElement5 = React.createElement

	local v18 = if props.selectedAction == "thumbs_down" then {
		name = iconName.ThumbDown,
		variant = iconVariant.Filled
	} else iconName.ThumbDown
	children.ThumbsDown = createElement5(iconButton, {
		LayoutOrder = 2,
		icon = v18,
		onActivated = props.onThumbsDown,
		size = inputSize.Small,
		variant = buttonVariant.Utility,
		testId = "generated-text-feedback-thumbs-down"
	})
	v10.Icons = createElement3(
		view,
		{ LayoutOrder = 2, tag = "row align-x-center align-y-center gap-small auto-xy" },
		children
	)
	local v7 = { Feedback = createElement2(view, v9, v10), ReasonDialog = 0 }

	local v19 = if props.showReasonDialog then React.createElement(TextFeedbackReasonDialog, {
		onNotHelpful = props.onNotHelpful,
		onPolicyViolation = props.onPolicyViolation,
		onDismiss = props.onDismissDialog
	}) else nil
	v7.ReasonDialog = v19
	return createElement(fragment, nil, v7)
end

return GeneratedTextFeedbackView
