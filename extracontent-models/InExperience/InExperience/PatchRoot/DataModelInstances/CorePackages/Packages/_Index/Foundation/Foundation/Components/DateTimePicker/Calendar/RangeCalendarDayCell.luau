local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local CalendarGridDayLabel = require(script.Parent.CalendarGridDayLabel)

local DateTimeCalendarDayAppearanceUtilities = require(script.Parent.Parent.Utilities.DateTimeCalendarDayAppearanceUtilities)
local DateTimeUtilities = require(script.Parent.Parent.DateTimeUtilities)

local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function RangeCalendarDayCell(props)
	local v = useTokens()
	local dateTime = DateTime.fromLocalTime(props.year, props.month, props.day)
	local selectedDates = props.selectedDates or {}

	local v2 = {}

	for _, selectedDate in selectedDates do
		table.insert(v2, DateTimeUtilities.toLocalTime(selectedDate))
	end

	local highlightDates = DateTimeCalendarDayAppearanceUtilities.resolveHighlightDates(
		selectedDates,
		props.hoveredDate
	)
	local daySelectable = DateTimeCalendarDayAppearanceUtilities.isDaySelectable(dateTime, props.selectableDateRange)
	local daySelected = DateTimeCalendarDayAppearanceUtilities.isDaySelected(dateTime, v2, true)
	local dayHighlighted = DateTimeCalendarDayAppearanceUtilities.isDayHighlighted(dateTime, highlightDates, true)

	local rangeBand, bandSize, bandRadiusTag = DateTimeCalendarDayAppearanceUtilities.getRangeBand(
		dateTime,
		highlightDates,
		true,
		daySelected
	)

	local onHoverEnter = React.useMemo(function()
		if props.onHoverEnter == nil then
			return nil
		end

		return function()
			props.onHoverEnter(dateTime)
		end
	end, { props.onHoverEnter, dateTime })
	local v3

	if bandRadiusTag == nil then
		v3 = false
	else
		v3 = bandRadiusTag ~= ""
	end

	local createElement = React.createElement
	local v4 = {
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.fromOffset(props.cellSize, props.cellSize)
	}
	local rangeFill

	if dayHighlighted and not daySelected then
		rangeFill = React.createElement(View, {
			backgroundStyle = v.Color.ActionStandard.Background,
			tag = { ["size-full"] = true, [bandRadiusTag] = v3 },
			ZIndex = 0
		})
	end

	local createElement2 = React.createElement

	if not daySelected then
		rangeBand = nil
	end

	if not daySelected then
		bandRadiusTag = nil
	end

	if not daySelected then
		bandSize = nil
	end

	return createElement(View, v4, {
		RangeFill = rangeFill,
		Day = createElement2(CalendarGridDayLabel, {
			bandPosition = rangeBand,
			bandRadiusTag = bandRadiusTag,
			bandSize = bandSize,
			emphasizeText = daySelectable and not daySelected,
			highlight = false,
			isSelectable = daySelectable,
			isSelected = daySelected,
			LayoutOrder = 1,
			label = tostring(props.day),
			onActivated = function()
				props.onDayActivated(dateTime)
			end,
			onHoverEnter = onHoverEnter,
			testId = `{props.testId}--day-{props.year}-{props.month}-{props.day}`
		})
	})
end

return RangeCalendarDayCell
