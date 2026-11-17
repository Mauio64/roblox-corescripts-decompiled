local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local CalendarGridDayLabel = require(script.Parent.CalendarGridDayLabel)
local DateTimeCalendarConstants = require(script.Parent.Parent.Utilities.DateTimeCalendarConstants)

local DateTimeCalendarDayAppearanceUtilities = require(script.Parent.Parent.Utilities.DateTimeCalendarDayAppearanceUtilities)
local DateTimeCalendarDayConfigUtilities = require(script.Parent.Parent.Utilities.DateTimeCalendarDayConfigUtilities)
require(script.Parent.Parent.Utilities.DateTimeCalendarViewUtilities)
local DateTimeUtilities = require(script.Parent.Parent.DateTimeUtilities)

local Text = require(Foundation.Components.Text)
local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)

local buildCalendarDayConfigs = DateTimeCalendarDayConfigUtilities.buildCalendarDayConfigs
local DAYS_PER_WEEK = DateTimeCalendarConstants.DAYS_PER_WEEK
local getDayCellAppearance = DateTimeCalendarDayAppearanceUtilities.getDayCellAppearance

local function CalendarGridDayCell(props)
	local v = useTokens()

	local onHoverEnter = React.useMemo(function()
		if props.onHoverEnter == nil then
			return nil
		end

		return function()
			props.onHoverEnter(DateTime.fromLocalTime(props.year, props.month, props.day))
		end
	end, { props.onHoverEnter, props.year, props.month, props.day })

	local onActivated = React.useCallback(function()
		props.handleDateActivated(props.day, props.month, props.year)
	end, { props.handleDateActivated, props.day, props.month, props.year })

	local v2 = props.isHighlighted and not props.isSelected
	local v3

	if props.bandRadiusTag == nil then
		v3 = false
	else
		v3 = props.bandRadiusTag ~= ""
	end

	local createElement = React.createElement
	local v4 = { LayoutOrder = props.LayoutOrder, tag = "size-full" }
	local rangeFill

	if v2 then
		rangeFill = React.createElement(View, {
			backgroundStyle = v.Color.ActionStandard.Background,
			tag = { ["size-full"] = true, [props.bandRadiusTag] = v3 },
			ZIndex = 0
		})
	end

	local createElement2 = React.createElement
	local bandPosition

	if props.isSelected then
		bandPosition = props.bandPosition
	end

	local bandRadiusTag

	if props.isSelected then
		bandRadiusTag = props.bandRadiusTag
	end

	local bandSize

	if props.isSelected then
		bandSize = props.bandSize
	end

	local emphasizeText

	if props.applyEmphasis then
		emphasizeText = props.isSelectable and not props.isSelected
	end

	return createElement(View, v4, {
		RangeFill = rangeFill,
		Day = createElement2(CalendarGridDayLabel, {
			bandPosition = bandPosition,
			bandRadiusTag = bandRadiusTag,
			bandSize = bandSize,
			emphasizeText = emphasizeText,
			highlight = false,
			isSelectable = props.isSelectable,
			isSelected = props.isSelected,
			LayoutOrder = 1,
			onActivated = onActivated,
			onHoverEnter = onHoverEnter,
			testId = props.testId,
			label = tostring(props.day)
		})
	})
end

local memo = React.memo(CalendarGridDayCell)

return {
	CalendarGrid = function(props)
		local none = useTokens().Padding.None
		local ref = React.useRef(nil)

		React.useEffect(function()
			local current = ref.current
			local onHoverLeave = props.onHoverLeave

			if current == nil or onHoverLeave == nil then
				return
			end

			local mouseLeaveConnection = current.MouseLeave:Connect(onHoverLeave)
			return function()
				mouseLeaveConnection:Disconnect()
			end
		end, { props.onHoverLeave })

		local v = React.useMemo(function()
			return buildCalendarDayConfigs(props.currViewDate)
		end, { props.currViewDate })

		local v2 = React.useMemo(function()
			local result = {}

			for _, v2 in v do
				local formatted = `{v2.keyPrefix}-{v2.day}`
				result[formatted] = getDayCellAppearance(
					DateTime.fromLocalTime(v2.year, v2.month, v2.day),
					props.localSelectedDateTimes,
					props.highlightDates,
					props.isDateRange,
					props.selectableDateRange
				)
			end

			return result
		end, {
			v,
			props.highlightDates,
			props.isDateRange,
			props.localSelectedDateTimes,
			props.selectableDateRange
		})

		local children = { React.createElement("UIGridLayout", {
				CellPadding = UDim2.fromOffset(none, none),
				CellSize = UDim2.fromOffset(
					props.scaledCalendarWidth / DAYS_PER_WEEK,
					props.scaledCalendarWidth / DAYS_PER_WEEK
				),
				FillDirection = Enum.FillDirection.Horizontal,
				FillDirectionMaxCells = DAYS_PER_WEEK,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				key = "layout",
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}) }
		local layoutOrder = 1

		for _, weekday in DateTimeUtilities.weekdays do
			table.insert(
				children,
				React.createElement(Text, {
					key = weekday,
					LayoutOrder = layoutOrder,
					tag = "text-body-small text-align-x-center text-align-y-center",
					Text = weekday
				})
			)

			layoutOrder += 1
		end

		for _, v3 in v do
			local formatted = `{v3.keyPrefix}-{v3.day}`
			local v4 = v2[formatted]
			table.insert(children, React.createElement(memo, {
				key = formatted,
				applyEmphasis = v3.applyEmphasis,
				bandPosition = v4.bandPosition,
				bandRadiusTag = v4.bandRadiusTag,
				bandSize = v4.bandSize,
				day = v3.day,
				handleDateActivated = props.handleDateActivated,
				isHighlighted = v4.isHighlighted,
				isSelectable = v4.isSelectable,
				isSelected = v4.isSelected,
				LayoutOrder = v3.LayoutOrder,
				month = v3.month,
				onHoverEnter = props.onHoverEnter,
				testId = `{props.testId}--{v3.keyPrefix}-calendar-day-{v3.day}`,
				year = v3.year
			}))
		end

		return React.createElement(View, {
			LayoutOrder = props.LayoutOrder,
			ref = ref,
			Size = props.Size,
			tag = "size-full-0 auto-y",
			testId = `{props.testId}--weekAndDates`
		}, children)
	end
}
