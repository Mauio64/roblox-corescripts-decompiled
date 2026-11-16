local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local CalendarGrid = require(script.Parent.CalendarGrid)
local calendarGrid = CalendarGrid.CalendarGrid
local CalendarHeader = require(script.Parent.CalendarHeader)
local DateTimeCalendarConstants = require(script.Parent.Parent.Utilities.DateTimeCalendarConstants)
local DateTimeCalendarViewUtilities = require(script.Parent.Parent.Utilities.DateTimeCalendarViewUtilities)
local DateTimeLayoutUtilities = require(script.Parent.Parent.Utilities.DateTimeLayoutUtilities)
require(script.Parent.Parent.DateTimeUtilities)

local TimeList = require(script.Parent.Parent.Time.TimeList)
local View = require(Foundation.Components.View)
local useSingleMonthCalendarState = require(script.Parent.useSingleMonthCalendarState)

local useScaledValue = require(Foundation.Utility.useScaledValue)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withDefaults = require(Foundation.Utility.withDefaults)

local v = { testId = "--foundation-calendar" }

local function CalendarPane(props)
	local state = props.state

	return React.createElement(View, {
		LayoutOrder = props.LayoutOrder,
		Size = props.Size,
		tag = {
			["col gap-small padding-large"] = props.showTimeList == true,
			["col auto-y"] = props.showTimeList ~= true
		},
		testId = props.rootTestId
	}, {
		CalendarHeader = React.createElement(CalendarHeader, {
			LayoutOrder = 1,
			onNextMonth = state.navigateToNextMonth,
			onPreviousMonth = state.navigateToPreviousMonth,
			onViewDateChanged = state.onViewDateChanged,
			selectableDateRange = props.selectableDateRange,
			testId = props.testId,
			viewDate = state.currViewDate
		}),
		WeekAndDates = React.createElement(calendarGrid, {
			currViewDate = state.currViewDate,
			handleDateActivated = state.handleDateActivated,
			highlightDates = state.highlightDates,
			isDateRange = state.isDateRange,
			localSelectedDateTimes = state.localSelectedDateTimes,
			LayoutOrder = 2,
			onHoverEnter = state.onHoverEnter,
			onHoverLeave = state.onHoverLeave,
			scaledCalendarWidth = props.scaledCalendarWidth,
			selectableDateRange = props.selectableDateRange,
			Size = props.gridSize,
			testId = props.testId
		})
	})
end

local function SingleMonthCalendar(p)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local scaledCalendarWidth = useScaledValue(DateTimeLayoutUtilities.CALENDAR_WIDTH)
	local v4 = useScaledValue(DateTimeLayoutUtilities.TIME_LIST_WIDTH)

	local state = useSingleMonthCalendarState({
		isDateRange = v2.isDateRange,
		onSelectedDateChanged = v2.onSelectedDateChanged,
		referenceDate = v2.referenceDate,
		selectableDateRange = v2.selectableDateRange,
		selectedDates = v2.selectedDates,
		showTimeList = v2.showTimeList,
		viewAnchorDate = v2.viewAnchorDate
	})

	if not v2.showTimeList then
		return React.createElement(CalendarPane, {
			LayoutOrder = v2.LayoutOrder,
			rootTestId = v2.testId,
			scaledCalendarWidth = scaledCalendarWidth,
			selectableDateRange = v2.selectableDateRange,
			Size = UDim2.fromOffset(scaledCalendarWidth, 0),
			state = state,
			testId = v2.testId
		})
	end

	local singleWithTimeLayout = DateTimeLayoutUtilities.computeSingleWithTimeLayout(
		scaledCalendarWidth,
		v4,
		v3,
		DateTimeCalendarConstants.NUM_CALENDAR_GRID_ROWS
	)

	return React.createElement(
		View,
		{ LayoutOrder = v2.LayoutOrder, tag = "row align-y-top auto-xy", testId = v2.testId },
		{
			CalendarPane = React.createElement(CalendarPane, {
				gridSize = UDim2.fromOffset(scaledCalendarWidth, singleWithTimeLayout.gridHeight),
				LayoutOrder = 1,
				scaledCalendarWidth = scaledCalendarWidth,
				selectableDateRange = v2.selectableDateRange,
				showTimeList = true,
				Size = UDim2.fromOffset(singleWithTimeLayout.calendarColumnWidth, singleWithTimeLayout.bodyHeight),
				state = state,
				testId = v2.testId
			}),
			Divider = React.createElement(View, {
				backgroundStyle = v3.Color.Stroke.Default,
				LayoutOrder = 2,
				Size = UDim2.fromOffset(v3.Stroke.Standard, singleWithTimeLayout.bodyHeight)
			}),
			TimeListColumn = React.createElement(
				View,
				{
					LayoutOrder = 3,
					Size = UDim2.fromOffset(singleWithTimeLayout.timeListColumnWidth, singleWithTimeLayout.bodyHeight),
					tag = "col padding-large"
				},
				{
					TimeList = React.createElement(TimeList, {
						dateTime = state.selectedDateTimes[1],
						dayAnchor = DateTimeCalendarViewUtilities.resolveAnchorDate(
							state.selectedDateTimes,
							v2.viewAnchorDate or v2.referenceDate
						),
						height = singleWithTimeLayout.timeListHeight,
						LayoutOrder = 1,
						onItemChanged = state.onTimeListItemChanged,
						testId = `{v2.testId}--time-list`,
						width = UDim.new(0, v4)
					})
				}
			)
		}
	)
end

return SingleMonthCalendar
