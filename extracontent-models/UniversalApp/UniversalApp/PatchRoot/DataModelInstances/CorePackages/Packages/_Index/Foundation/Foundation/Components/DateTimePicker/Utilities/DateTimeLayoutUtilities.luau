local Foundation = script:FindFirstAncestor("Foundation")

local DateTimeCalendarConstants = require(script.Parent.DateTimeCalendarConstants)
require(Foundation.Providers.Style.Tokens)

local DAYS_PER_WEEK = DateTimeCalendarConstants.DAYS_PER_WEEK

return {
	CALENDAR_WIDTH = 272,
	PANE_WIDTH = 280,
	TIME_LIST_WIDTH = 132,
	computeSingleWithTimeLayout = function(p: number, p2: number, data, p3: number)
		local large = data.Padding.Large
		local gridHeight = p3 * (p / DAYS_PER_WEEK)
		local v = data.Size.Size_800 + 2 * data.Padding.Small
		local bodyHeight = 2 * large + v + data.Gap.Small + gridHeight

		local calendarColumnWidth = p + 2 * large
		local timeListColumnWidth = p2 + 2 * large

		return {
			bodyHeight = bodyHeight,
			calendarColumnWidth = calendarColumnWidth,
			contentWidth = calendarColumnWidth + data.Stroke.Standard + timeListColumnWidth,
			gridHeight = gridHeight,
			timeListColumnWidth = timeListColumnWidth,
			timeListHeight = bodyHeight - 2 * large
		}
	end
}
