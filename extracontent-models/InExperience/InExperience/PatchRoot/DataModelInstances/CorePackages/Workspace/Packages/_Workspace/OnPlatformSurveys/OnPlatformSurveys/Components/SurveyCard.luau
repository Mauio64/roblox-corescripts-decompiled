local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local parent = OnPlatformSurveys.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Button = Foundation.Button
local ButtonSize = Foundation.Enums.ButtonSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local Text = Foundation.Text
local View = Foundation.View

require(OnPlatformSurveys.Components.surveyPhaseSlots)

local function SurveyCard(p)
	local slots = p.slots
	local primaryAction = slots.primaryAction

	local createElement = React.createElement

	local createElement2 = React.createElement
	local leading

	if slots.headerTitle then
		leading = React.createElement(Text, {
			Text = slots.headerTitle,
			tag = "fill auto-y text-heading-small text-wrap text-align-x-left content-emphasis",
			LayoutOrder = 1
		})
	else
		leading = React.createElement(View, { tag = "fill auto-y", LayoutOrder = 1 })
	end

	return createElement(
		View,
		{
			tag = "col gap-medium size-full-0 auto-y padding-large stroke-standard stroke-default radius-medium bg-surface-100"
		},
		{
			Header = createElement2(
				View,
				{ tag = "row align-y-center gap-small size-full-0 auto-y", LayoutOrder = 1 },
				{
					Leading = leading,
					DismissButton = React.createElement(IconButton, {
						icon = IconName.X,
						variant = ButtonVariant.Utility,
						size = ButtonSize.Small,
						isCircular = true,
						onActivated = p.onDismiss,
						LayoutOrder = 2
					})
				}
			),
			Body = React.createElement(View, { tag = "size-full-0 auto-y", LayoutOrder = 2 }, slots.body),
			Actions = primaryAction and React.createElement(View, {
				tag = "row size-full-0 auto-y",
				LayoutOrder = 3
			}, {
				PrimaryButton = React.createElement(Button, {
					text = primaryAction.text,
					variant = primaryAction.variant,
					fillBehavior = FillBehavior.Fill,
					isLoading = primaryAction.isLoading,
					isDisabled = primaryAction.isDisabled,
					onActivated = primaryAction.onActivated
				})
			}) or nil
		}
	)
end

return React.memo(SurveyCard)
