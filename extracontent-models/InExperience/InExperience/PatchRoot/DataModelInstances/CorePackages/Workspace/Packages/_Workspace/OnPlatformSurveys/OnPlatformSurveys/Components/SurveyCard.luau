local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local OnPlatformSurveysParent = OnPlatformSurveys.Parent
local Foundation = require(OnPlatformSurveysParent.Foundation)
local React = require(OnPlatformSurveysParent.React)
local Button = Foundation.Button
local ButtonSize = Foundation.Enums.ButtonSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local FoundationText = Foundation.Text
local View = Foundation.View

require(OnPlatformSurveys.Components.surveyPhaseSlots)

local function SurveyCard(t1: {[any]: any}) -- line: 24
	-- upvalues: React (copy), View (copy), FoundationText (copy), IconButton (copy), IconName (copy), ButtonVariant (copy), ButtonSize (copy), Button (copy), FillBehavior (copy)
	local slots = t1.slots
	local primaryAction = slots.primaryAction

	return React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y padding-large stroke-standard stroke-default radius-medium bg-surface-100"
	}, {
		Header = React.createElement(View, {
			tag = "row align-y-center gap-small size-full-0 auto-y",
			LayoutOrder = 1
		}, {
			Leading = if not slots.headerTitle then React.createElement(View, {
				tag = "fill auto-y",
				LayoutOrder = 1
			}) else React.createElement(FoundationText, {
				tag = "fill auto-y text-heading-small text-wrap text-align-x-left content-emphasis",
				LayoutOrder = 1,
				Text = slots.headerTitle
			}),
			DismissButton = React.createElement(IconButton, {
				isCircular = true,
				LayoutOrder = 2,
				icon = IconName.X,
				variant = ButtonVariant.Utility,
				size = ButtonSize.Small,
				onActivated = t1.onDismiss
			})
		}),
		Body = React.createElement(View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 2
		}, slots.body),
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
	})
end

return React.memo(SurveyCard)
