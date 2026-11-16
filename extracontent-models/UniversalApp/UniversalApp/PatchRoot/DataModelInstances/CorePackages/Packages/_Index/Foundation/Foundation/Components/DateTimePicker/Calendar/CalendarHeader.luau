local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local React = require(parent.React)

local Icon = BuilderIcons.Icon

require(script.Parent.Parent.Utilities.DateTimeCalendarViewUtilities)
local DateTimeUtilities = require(script.Parent.Parent.DateTimeUtilities)

local ButtonVariant = require(Foundation.Enums.ButtonVariant)
local Dropdown = require(Foundation.Components.Dropdown)
local IconButton = require(Foundation.Components.IconButton)
local InputSize = require(Foundation.Enums.InputSize)
local InputVariant = require(Foundation.Enums.InputVariant)
local View = require(Foundation.Components.View)
local useScaledValue = require(Foundation.Utility.useScaledValue)
local useScrollToSelectedRef = require(script.Parent.useScrollToSelectedRef)
local useTextSize = require(Foundation.Utility.useTextSize)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function CalendarHeader(props)
	local viewDate = props.viewDate
	local v = useTokens()

	local month = DateTimeUtilities.monthMap[viewDate.month]
	local year = tostring(viewDate.year)
	local v2 = useTextSize(month, v.Typography.BodySmall)
	local v3 = useTextSize(year, v.Typography.BodySmall)
	local v4 = useScaledValue(44)
	local maxHeight = useScaledValue(200)
	local v5 = not v2 and 110 or math.ceil(v2.X) + v4
	local v6 = not v3 and 70 or math.ceil(v3.X) + v4

	local items = React.useMemo(function()
		local result = {}

		for k, month2 in DateTimeUtilities.monthMap do
			table.insert(result, { id = k, text = month2 })
		end

		return result
	end, {})

	local items2 = React.useMemo(function()
		local v7, v8

		if props.selectableDateRange then
			local localTime = DateTimeUtilities.toLocalTime(props.selectableDateRange.startDate)
			local localTime2 = DateTimeUtilities.toLocalTime(props.selectableDateRange.endDate)
			v7 = localTime.Year
			v8 = localTime2.Year
		else
			v7 = viewDate.year - 50
			v8 = viewDate.year + 50
		end

		local result = {}

		for i = v7, v8 do
			table.insert(result, { id = i, text = tostring(i) })
		end

		return result
	end, { props.selectableDateRange, viewDate.year })

	local onItemChanged = React.useCallback(function(p)
		local month2 = tonumber(p)

		if month2 then
			props.onViewDateChanged({ month = month2, year = viewDate.year })
		end
	end, { props.onViewDateChanged, viewDate.year })

	local onItemChanged2 = React.useCallback(function(p)
		local year2 = tonumber(p)

		if year2 then
			props.onViewDateChanged({ month = viewDate.month, year = year2 })
		end
	end, { props.onViewDateChanged, viewDate.month })

	local scrollingFrameRef = useScrollToSelectedRef(items, viewDate.month)
	local scrollingFrameRef2 = useScrollToSelectedRef(items2, viewDate.year)

	return React.createElement(
		View,
		{
			LayoutOrder = props.LayoutOrder,
			tag = "row align-y-center gap-small size-full-0 auto-y padding-y-small"
		},
		{
			PreviousMonthButton = React.createElement(IconButton, {
				icon = Icon.ChevronSmallLeft,
				LayoutOrder = 1,
				onActivated = props.onPreviousMonth,
				size = InputSize.Small,
				testId = `{props.testId}--previous-month-button`,
				variant = ButtonVariant.Utility
			}),
			MonthYearDropdowns = React.createElement(
				View,
				{ LayoutOrder = 2, tag = "row align-x-center align-y-center grow gap-small auto-y" },
				{
					MonthDropdown = React.createElement(Dropdown.Root, {
						items = items,
						label = "",
						LayoutOrder = 1,
						maxHeight = maxHeight,
						onItemChanged = onItemChanged,
						scrollingFrameRef = scrollingFrameRef,
						size = InputSize.XSmall,
						testId = `{props.testId}--month-dropdown`,
						value = viewDate.month,
						variant = InputVariant.Utility,
						width = UDim.new(0, v5)
					}),
					YearDropdown = React.createElement(Dropdown.Root, {
						items = items2,
						label = "",
						LayoutOrder = 2,
						maxHeight = maxHeight,
						onItemChanged = onItemChanged2,
						scrollingFrameRef = scrollingFrameRef2,
						size = InputSize.XSmall,
						testId = `{props.testId}--year-dropdown`,
						value = viewDate.year,
						variant = InputVariant.Utility,
						width = UDim.new(0, v6)
					})
				}
			),
			NextMonthButton = React.createElement(IconButton, {
				icon = Icon.ChevronSmallRight,
				LayoutOrder = 3,
				onActivated = props.onNextMonth,
				size = InputSize.Small,
				testId = `{props.testId}--next-month-button`,
				variant = ButtonVariant.Utility
			})
		}
	)
end

return CalendarHeader
