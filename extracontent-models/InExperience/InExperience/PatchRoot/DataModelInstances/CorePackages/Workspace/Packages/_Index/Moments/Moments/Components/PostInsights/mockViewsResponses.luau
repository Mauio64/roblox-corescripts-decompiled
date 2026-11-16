local mockViewsDailyQuarterResponse = require(script.Parent.mockViewsDailyQuarterResponse)
local mockViewsDailyWeekResponse = require(script.Parent.mockViewsDailyWeekResponse)
local mockViewsHourlyResponse = require(script.Parent.mockViewsHourlyResponse)

return table.freeze({
	hourly = mockViewsHourlyResponse,
	dailyWeek = mockViewsDailyWeekResponse,
	dailyQuarter = mockViewsDailyQuarterResponse,
	all = table.freeze({ mockViewsHourlyResponse, mockViewsDailyWeekResponse, mockViewsDailyQuarterResponse })
})
