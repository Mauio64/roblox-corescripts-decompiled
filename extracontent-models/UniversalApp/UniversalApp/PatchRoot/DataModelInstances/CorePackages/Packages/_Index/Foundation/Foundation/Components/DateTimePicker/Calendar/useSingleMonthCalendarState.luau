local parent = script:FindFirstAncestor("Foundation").Parent

local React = require(parent.React)

local DateTimeCalendarDayAppearanceUtilities = require(script.Parent.Parent.Utilities.DateTimeCalendarDayAppearanceUtilities)
local DateTimeCalendarViewUtilities = require(script.Parent.Parent.Utilities.DateTimeCalendarViewUtilities)
local DateTimeParsingUtilities = require(script.Parent.Parent.Utilities.DateTimeParsingUtilities)
local DateTimeRangeSelectionUtilities = require(script.Parent.Parent.Utilities.DateTimeRangeSelectionUtilities)
local DateTimeUtilities = require(script.Parent.Parent.DateTimeUtilities)

local function useSingleMonthCalendarState(data)
	local isDateRange = data.isDateRange == true

	local v = React.useMemo(function()
		if data.selectedDates then
			return DateTimeRangeSelectionUtilities.normalizeDates({
				acceptsDateRange = isDateRange,
				dates = data.selectedDates
			})
		end

		return {}
	end, { data.selectedDates, isDateRange })

	local state, setState = React.useState(v)

	React.useEffect(function()
		setState(v)
	end, { v })

	React.useEffect(function()
		if data.selectedDates then
			return
		end

		data.onSelectedDateChanged(v)
	end, { data.selectedDates, v, data.onSelectedDateChanged })

	local localSelectedDateTimes = React.useMemo(function()
		local result = {}

		for _, v2 in state do
			table.insert(result, DateTimeUtilities.toLocalTime(v2))
		end

		return result
	end, { state })

	local state2, setState2 = React.useState(DateTimeCalendarViewUtilities.toViewDate(DateTimeCalendarViewUtilities.resolveAnchorDate(
		data.selectedDates,
		data.referenceDate
	)))

	React.useEffect(function()
		if not data.viewAnchorDate then
			return
		end

		setState2(DateTimeCalendarViewUtilities.toViewDate(data.viewAnchorDate))
	end, { data.viewAnchorDate })

	local navigateToNextMonth = React.useCallback(function()
		local nextMonthInfo, year = DateTimeUtilities.getNextMonthInfo(state2.month, state2.year)
		setState2({ month = nextMonthInfo, year = year })
	end, { state2 })

	local navigateToPreviousMonth = React.useCallback(function()
		local prevMonthInfo, year = DateTimeUtilities.getPrevMonthInfo(state2.month, state2.year)
		setState2({ month = prevMonthInfo, year = year })
	end, { state2 })

	local onViewDateChanged = React.useCallback(function(p)
		setState2(p)
	end, {})

	local state3, setState3 = React.useState(function(): nil
		return nil
	end)

	local highlightDates = React.useMemo(function()
		if isDateRange then
			return DateTimeCalendarDayAppearanceUtilities.resolveHighlightDates(state, state3)
		end

		return state
	end, { isDateRange, state, state3 })

	local onHoverEnter = React.useCallback(function(p)
		if not isDateRange then
			return
		end

		setState3(p)
	end, { isDateRange })

	local onHoverLeave = React.useCallback(function()
		setState3(nil)
	end, {})

	React.useEffect(function()
		if not isDateRange then
			return
		end

		if not state[1] or state[2] then
			setState3(nil)
		end
	end, { isDateRange, state })

	return {
		currViewDate = state2,
		handleDateActivated = React.useCallback(function(p: number, month: number, year: number)
			local v2 = state[1]
			local v3, v4

			if v2 then
				local localTime = DateTimeUtilities.toLocalTime(v2)
				v3 = localTime.Hour
				v4 = localTime.Minute
			else
				v3 = 0
				v4 = 0
			end

			local dateTime = DateTime.fromLocalTime(year, month, p, v3, v4)

			if data.showTimeList then
				dateTime = DateTimeCalendarViewUtilities.roundUpToNearestHalfHour(dateTime)
			end

			setState2({ month = month, year = year })
			setState3(nil)

			local v5 = not isDateRange and { dateTime }
				or DateTimeRangeSelectionUtilities.selectRangeEndpoint(state, dateTime)
			setState(v5)
			data.onSelectedDateChanged(v5)
		end, { isDateRange, data.showTimeList, data.onSelectedDateChanged, state }),
		highlightDates = highlightDates,
		isDateRange = isDateRange,
		localSelectedDateTimes = localSelectedDateTimes,
		navigateToNextMonth = navigateToNextMonth,
		navigateToPreviousMonth = navigateToPreviousMonth,
		onHoverEnter = onHoverEnter,
		onHoverLeave = onHoverLeave,
		onTimeListItemChanged = React.useCallback(function(p: number)
			local adjustForDaylightSaving = DateTimeParsingUtilities.adjustForDaylightSaving(DateTime.fromUnixTimestamp(p))
			setState({ adjustForDaylightSaving })
			data.onSelectedDateChanged({ adjustForDaylightSaving })
		end, { data.onSelectedDateChanged }),
		onViewDateChanged = onViewDateChanged,
		selectedDateTimes = state
	}
end

return useSingleMonthCalendarState
