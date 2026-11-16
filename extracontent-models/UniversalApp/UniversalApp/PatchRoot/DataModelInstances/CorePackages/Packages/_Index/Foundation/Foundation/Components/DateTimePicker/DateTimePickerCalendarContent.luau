local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

require(script.Parent.DateTimeUtilities)
local SingleMonthCalendar = require(script.Parent.Calendar.SingleMonthCalendar)

local DateTimePickerVariant = require(Foundation.Enums.DateTimePickerVariant)

local Divider = require(Foundation.Components.Divider)
local View = require(Foundation.Components.View)

local function DateTimePickerCalendarContent(props)
	local formatted = `{props.testId}--calendar`

	if props.variant ~= DateTimePickerVariant.DualWithPresets then
		return React.createElement(SingleMonthCalendar, {
			isDateRange = props.variant == DateTimePickerVariant.Dual,
			LayoutOrder = 1,
			onSelectedDateChanged = props.onSelectedDatesChanged,
			referenceDate = props.referenceDate,
			selectableDateRange = props.selectableDateRange,
			selectedDates = props.selectedDates,
			showTimeList = props.variant == DateTimePickerVariant.SingleWithTime,
			testId = formatted,
			viewAnchorDate = props.viewAnchorDate
		})
	end

	local TwoMonthCalendar = require(script.Parent.Calendar.TwoMonthCalendar)
	local DateRangePresets = require(script.Parent.Presets.DateRangePresets)
	return React.createElement(View, { tag = "col size-full-0 auto-y" }, {
		Calendar = React.createElement(TwoMonthCalendar, {
			LayoutOrder = 1,
			onDayActivated = props.onDayActivated,
			referenceDate = props.referenceDate,
			selectableDateRange = props.selectableDateRange,
			selectedDates = props.selectedDates,
			testId = formatted,
			viewAnchorDate = props.viewAnchorDate
		}),
		PresetsDivider = React.createElement(Divider, { LayoutOrder = 2 }),
		PresetsBar = React.createElement(
			View,
			{ LayoutOrder = 3, tag = "row size-full-0 auto-y padding-x-large padding-y-medium" },
			{
				Presets = React.createElement(DateRangePresets, {
					LayoutOrder = 1,
					onPresetSelected = props.onPresetSelected,
					referenceDate = props.referenceDate,
					selectableDateRange = props.selectableDateRange,
					selectedDates = props.selectedDates,
					testId = `{formatted}--presets`
				})
			}
		)
	})
end

return DateTimePickerCalendarContent
