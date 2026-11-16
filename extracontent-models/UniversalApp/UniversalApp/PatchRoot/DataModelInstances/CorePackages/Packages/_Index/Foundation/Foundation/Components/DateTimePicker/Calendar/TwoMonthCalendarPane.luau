local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local DateTimeCalendarConstants = require(script.Parent.Parent.Utilities.DateTimeCalendarConstants)
local DateTimeCalendarDayConfigUtilities = require(script.Parent.Parent.Utilities.DateTimeCalendarDayConfigUtilities)
local DateTimeUtilities = require(script.Parent.Parent.DateTimeUtilities)

local RangeCalendarDayCell = require(script.Parent.RangeCalendarDayCell)
local Text = require(Foundation.Components.Text)
local View = require(Foundation.Components.View)

local DAYS_PER_WEEK = DateTimeCalendarConstants.DAYS_PER_WEEK
local buildTwoMonthPaneCellConfigs = DateTimeCalendarDayConfigUtilities.buildTwoMonthPaneCellConfigs

local function EmptyCell(p)
	return React.createElement(View, {
		LayoutOrder = p.LayoutOrder,
		Size = UDim2.fromOffset(p.cellSize, p.cellSize)
	})
end

local function TwoMonthCalendarPane(props)
	local v = React.useMemo(function()
		return buildTwoMonthPaneCellConfigs(props.month, props.year)
	end, { props.month, props.year })

	local children = { React.createElement("UIGridLayout", {
			CellPadding = UDim2.fromOffset(0, 0),
			CellSize = UDim2.fromOffset(props.cellSize, props.cellSize),
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
				key = `weekday-{weekday}`,
				LayoutOrder = layoutOrder,
				Text = weekday,
				tag = "text-body-small text-align-x-center text-align-y-center"
			})
		)

		layoutOrder += 1
	end

	for _, v2 in v do
		if v2.day == nil then
			table.insert(
				children,
				React.createElement(EmptyCell, {
					key = v2.key,
					cellSize = props.cellSize,
					LayoutOrder = v2.LayoutOrder
				})
			)
		else
			table.insert(children, React.createElement(RangeCalendarDayCell, {
				key = v2.key,
				cellSize = props.cellSize,
				day = v2.day,
				hoveredDate = props.hoveredDate,
				LayoutOrder = v2.LayoutOrder,
				month = v2.month,
				onDayActivated = props.onDayActivated,
				onHoverEnter = props.onHoverEnter,
				selectableDateRange = props.selectableDateRange,
				selectedDates = props.selectedDates,
				testId = props.testId,
				year = v2.year
			}))
		end
	end

	return React.createElement(
		View,
		{
			LayoutOrder = props.LayoutOrder,
			Size = UDim2.fromOffset(props.paneWidth, 0),
			tag = "auto-y",
			testId = `{props.testId}--pane-{props.LayoutOrder}`
		},
		children
	)
end

return TwoMonthCalendarPane
