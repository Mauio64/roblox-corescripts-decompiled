local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local React = require(parent.React)

local Icon = BuilderIcons.Icon

require(script.Parent.Parent.Utilities.DateTimeCalendarViewUtilities)
local DateTimeUtilities = require(script.Parent.Parent.DateTimeUtilities)

local ButtonVariant = require(Foundation.Enums.ButtonVariant)
local IconButton = require(Foundation.Components.IconButton)
local InputSize = require(Foundation.Enums.InputSize)
local Text = require(Foundation.Components.Text)
local View = require(Foundation.Components.View)

local function TwoMonthCalendarHeader(props)
	return React.createElement(
		View,
		{
			LayoutOrder = 1,
			tag = "row align-y-center gap-small size-full-0 auto-y padding-x-large padding-y-medium"
		},
		{
			PreviousMonthButton = React.createElement(IconButton, {
				icon = Icon.ChevronSmallLeft,
				isCircular = false,
				LayoutOrder = 1,
				onActivated = props.onPreviousMonth,
				size = InputSize.Small,
				testId = `{props.testId}--previous-month-button`,
				variant = ButtonVariant.Utility
			}),
			FirstMonthLabel = React.createElement(Text, {
				LayoutOrder = 2,
				tag = "grow auto-y text-title-small text-align-x-center",
				testId = `{props.testId}--first-month-label`,
				Text = `{DateTimeUtilities.monthMap[props.currViewDate.month]} {props.currViewDate.year}`
			}),
			SecondMonthLabel = React.createElement(Text, {
				LayoutOrder = 3,
				tag = "grow auto-y text-title-small text-align-x-center",
				testId = `{props.testId}--second-month-label`,
				Text = `{DateTimeUtilities.monthMap[props.secondMonth]} {props.secondYear}`
			}),
			NextMonthButton = React.createElement(IconButton, {
				icon = Icon.ChevronSmallRight,
				isCircular = false,
				LayoutOrder = 4,
				onActivated = props.onNextMonth,
				size = InputSize.Small,
				testId = `{props.testId}--next-month-button`,
				variant = ButtonVariant.Utility
			})
		}
	)
end

return TwoMonthCalendarHeader
