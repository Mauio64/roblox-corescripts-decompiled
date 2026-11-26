local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/React")

local button = Foundation.Button
local buttonSize = Foundation.Enums.ButtonSize
local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local iconButton = Foundation.IconButton
local iconName = Foundation.Enums.IconName
local text = Foundation.Text
local view = Foundation.View

require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Components/surveyPhaseSlots")

local function SurveyCard(p2)
	local slots = p2.slots
	local primaryAction = slots.primaryAction

	local createElement = React.createElement

	local createElement2 = React.createElement

	local v10 = if slots.headerTitle then React.createElement(text, {
		Text = slots.headerTitle,
		tag = "fill auto-y text-heading-small text-wrap text-align-x-left content-emphasis",
		LayoutOrder = 1
	}) else React.createElement(view, { tag = "fill auto-y", LayoutOrder = 1 })
	return createElement(
		view,
		{
			tag = "col gap-medium size-full-0 auto-y padding-large stroke-standard stroke-default radius-medium bg-surface-100"
		},
		{
			Header = createElement2(
				view,
				{
					tag = "row align-y-center gap-small size-full-0 auto-y",
					LayoutOrder = 1
				},
				{
					Leading = v10,
					DismissButton = React.createElement(iconButton, {
						icon = iconName.X,
						variant = buttonVariant.Utility,
						size = buttonSize.Small,
						isCircular = true,
						onActivated = p2.onDismiss,
						LayoutOrder = 2
					})
				}
			),
			Body = React.createElement(view, {
				tag = "size-full-0 auto-y",
				LayoutOrder = 2
			}, slots.body),
			Actions = primaryAction and React.createElement(
				view,
				{ tag = "row size-full-0 auto-y", LayoutOrder = 3 },
				{
					PrimaryButton = React.createElement(button, {
						text = primaryAction.text,
						variant = primaryAction.variant,
						fillBehavior = fillBehavior.Fill,
						isLoading = primaryAction.isLoading,
						isDisabled = primaryAction.isDisabled,
						onActivated = primaryAction.onActivated
					})
				}
			) or nil
		}
	)
end

return React.memo(SurveyCard)
