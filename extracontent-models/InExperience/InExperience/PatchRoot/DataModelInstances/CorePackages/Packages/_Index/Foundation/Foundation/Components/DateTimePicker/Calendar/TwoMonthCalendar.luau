local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local DateTimeCalendarViewUtilities = require(script.Parent.Parent.Utilities.DateTimeCalendarViewUtilities)
local DateTimeLayoutUtilities = require(script.Parent.Parent.Utilities.DateTimeLayoutUtilities)
local DateTimeUtilities = require(script.Parent.Parent.DateTimeUtilities)

local Divider = require(Foundation.Components.Divider)
local TwoMonthCalendarHeader = require(script.Parent.TwoMonthCalendarHeader)
local TwoMonthCalendarPane = require(script.Parent.TwoMonthCalendarPane)
local View = require(Foundation.Components.View)
local useScaledValue = require(Foundation.Utility.useScaledValue)

local function TwoMonthCalendar(props)
	local paneWidth = useScaledValue(DateTimeLayoutUtilities.PANE_WIDTH)
	local cellSize = paneWidth / 7

	local state, setState = React.useState(DateTimeCalendarViewUtilities.toViewDate(DateTimeCalendarViewUtilities.resolveAnchorDate(
		props.selectedDates,
		props.referenceDate
	)))

	local state2, setState2 = React.useState(function(): nil
		return nil
	end)

	local ref = React.useRef(nil)

	React.useEffect(function()
		if not props.viewAnchorDate then
			return
		end

		setState(DateTimeCalendarViewUtilities.toViewDate(props.viewAnchorDate))
	end, { props.viewAnchorDate })

	React.useEffect(function()
		if props.viewAnchorDate or props.selectedDates and props.selectedDates[1] then
			return
		end

		if props.referenceDate then
			setState(DateTimeCalendarViewUtilities.toViewDate(props.referenceDate))
		end
	end, { props.viewAnchorDate, props.referenceDate, props.selectedDates })

	React.useEffect(function()
		local selectedDates = props.selectedDates

		if not selectedDates or not selectedDates[1] or selectedDates[2] then
			setState2(nil)
		end
	end, { props.selectedDates })

	React.useEffect(function()
		local current = ref.current

		if current == nil then
			return
		end

		local mouseLeaveConnection = current.MouseLeave:Connect(function()
			setState2(nil)
		end)
		return function()
			mouseLeaveConnection:Disconnect()
		end
	end, {})

	local onPreviousMonth = React.useCallback(function()
		setState(function(p)
			local prevMonthInfo, year = DateTimeUtilities.getPrevMonthInfo(p.month, p.year)
			return { month = prevMonthInfo, year = year }
		end)
	end, {})

	local onNextMonth = React.useCallback(function()
		setState(function(p)
			local nextMonthInfo, year = DateTimeUtilities.getNextMonthInfo(p.month, p.year)
			return { month = nextMonthInfo, year = year }
		end)
	end, {})

	local onHoverEnter = React.useCallback(function(p)
		setState2(p)
	end, {})

	local onDayActivated = React.useCallback(function(p)
		setState2(nil)
		props.onDayActivated(p)
	end, { props.onDayActivated })

	local nextMonthInfo, v = DateTimeUtilities.getNextMonthInfo(state.month, state.year)

	return React.createElement(
		View,
		{ LayoutOrder = props.LayoutOrder, tag = "col size-full-0 auto-y", testId = props.testId },
		{
			Header = React.createElement(TwoMonthCalendarHeader, {
				currViewDate = state,
				onNextMonth = onNextMonth,
				onPreviousMonth = onPreviousMonth,
				secondMonth = nextMonthInfo,
				secondYear = v,
				testId = props.testId
			}),
			HeaderDivider = React.createElement(Divider, { LayoutOrder = 2 }),
			Panes = React.createElement(
				View,
				{
					LayoutOrder = 3,
					ref = ref,
					tag = "row align-y-top gap-large auto-xy padding-x-large padding-y-small"
				},
				{
					FirstPane = React.createElement(TwoMonthCalendarPane, {
						cellSize = cellSize,
						hoveredDate = state2,
						LayoutOrder = 1,
						month = state.month,
						onDayActivated = onDayActivated,
						onHoverEnter = onHoverEnter,
						paneWidth = paneWidth,
						selectableDateRange = props.selectableDateRange,
						selectedDates = props.selectedDates,
						testId = props.testId,
						year = state.year
					}),
					SecondPane = React.createElement(TwoMonthCalendarPane, {
						cellSize = cellSize,
						hoveredDate = state2,
						LayoutOrder = 2,
						month = nextMonthInfo,
						onDayActivated = onDayActivated,
						onHoverEnter = onHoverEnter,
						paneWidth = paneWidth,
						selectableDateRange = props.selectableDateRange,
						selectedDates = props.selectedDates,
						testId = props.testId,
						year = v
					})
				}
			)
		}
	)
end

return TwoMonthCalendar
