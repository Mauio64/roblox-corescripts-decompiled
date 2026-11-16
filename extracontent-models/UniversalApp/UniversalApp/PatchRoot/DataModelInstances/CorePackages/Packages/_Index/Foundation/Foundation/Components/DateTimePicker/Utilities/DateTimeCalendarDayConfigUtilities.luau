local Foundation = script:FindFirstAncestor("Foundation")

local DateTimeCalendarConstants = require(script.Parent.DateTimeCalendarConstants)
require(script.Parent.DateTimeCalendarViewUtilities)
local DateTimePickerCalendarDayKeyPrefix = require(Foundation.Enums.DateTimePickerCalendarDayKeyPrefix)
local DateTimeUtilities = require(script.Parent.Parent.DateTimeUtilities)

local DAYS_PER_WEEK = DateTimeCalendarConstants.DAYS_PER_WEEK
local NUM_ELEMENTS_IN_DATES_GRID = DateTimeCalendarConstants.NUM_ELEMENTS_IN_DATES_GRID
local NUM_NON_DAY_ELEMENTS = DateTimeCalendarConstants.NUM_NON_DAY_ELEMENTS
local NUM_WEEKDAY_HEADERS = DateTimeCalendarConstants.NUM_WEEKDAY_HEADERS

local function countLeadingPadDays(month: number, year: number) -- 1 equivalent call inferred from this helper
	local firstDayOfWeek = DateTimeUtilities.getFirstDayOfWeek(month, year)

	return if firstDayOfWeek == 0 then DAYS_PER_WEEK else firstDayOfWeek
end

local function countTrailingEmptyDays(firstDayOfWeek: number, daysInMonth: number) -- 1 equivalent call inferred from this helper
	return (DAYS_PER_WEEK - (firstDayOfWeek + daysInMonth) % DAYS_PER_WEEK) % DAYS_PER_WEEK
end

local DateTimeCalendarDayConfigUtilities = {}

function DateTimeCalendarDayConfigUtilities.buildCalendarDayConfigs(p)
	local calendarDayConfigs = {}
	local layoutOrder = NUM_WEEKDAY_HEADERS + 1

	local prevMonthInfo, year = DateTimeUtilities.getPrevMonthInfo(p.month, p.year)
	local daysInMonth = DateTimeUtilities.getDaysInMonth(prevMonthInfo, year)
	local v = countLeadingPadDays(p.month, p.year) -- inferred equivalent call

	for i = 1, v do
		table.insert(calendarDayConfigs, {
			day = daysInMonth - v + i,
			keyPrefix = DateTimePickerCalendarDayKeyPrefix.PrevMonth,
			LayoutOrder = layoutOrder,
			month = prevMonthInfo,
			year = year
		})

		layoutOrder += 1
	end

	for i = 1, DateTimeUtilities.getDaysInMonth(p.month, p.year) do
		table.insert(calendarDayConfigs, {
			applyEmphasis = true,
			day = i,
			keyPrefix = DateTimePickerCalendarDayKeyPrefix.CurrentMonth,
			LayoutOrder = layoutOrder,
			month = p.month,
			year = p.year
		})

		layoutOrder += 1
	end

	local lastDayOfWeek = DateTimeUtilities.getLastDayOfWeek(p.month, p.year)
	local nextMonthInfo, year2 = DateTimeUtilities.getNextMonthInfo(p.month, p.year)
	local v2 = DAYS_PER_WEEK - (lastDayOfWeek + 1)

	local v3 = NUM_NON_DAY_ELEMENTS + #calendarDayConfigs

	if v2 + v3 < NUM_ELEMENTS_IN_DATES_GRID then
		v2 += NUM_ELEMENTS_IN_DATES_GRID - v3 - v2
	end

	for i = 1, v2 do
		table.insert(calendarDayConfigs, {
			day = i,
			keyPrefix = DateTimePickerCalendarDayKeyPrefix.NextMonth,
			LayoutOrder = layoutOrder,
			month = nextMonthInfo,
			year = year2
		})

		layoutOrder += 1
	end

	return calendarDayConfigs
end

function DateTimeCalendarDayConfigUtilities.buildTwoMonthPaneCellConfigs(month: number, year: number)
	local layoutOrder = NUM_WEEKDAY_HEADERS + 1

	local firstDayOfWeek = DateTimeUtilities.getFirstDayOfWeek(month, year)
	local twoMonthPaneCellConfigs = {}

	for i = 1, firstDayOfWeek do
		table.insert(twoMonthPaneCellConfigs, { key = `lead-{i}`, LayoutOrder = layoutOrder })

		layoutOrder += 1
	end

	local daysInMonth = DateTimeUtilities.getDaysInMonth(month, year)

	for i = 1, daysInMonth do
		table.insert(twoMonthPaneCellConfigs, {
			day = i,
			key = `day-{i}`,
			LayoutOrder = layoutOrder,
			month = month,
			year = year
		})

		layoutOrder += 1
	end

	for i = 1, countTrailingEmptyDays(firstDayOfWeek, daysInMonth) do -- inferred equivalent call
		table.insert(twoMonthPaneCellConfigs, { key = `trail-{i}`, LayoutOrder = layoutOrder })

		layoutOrder += 1
	end

	return twoMonthPaneCellConfigs
end

return DateTimeCalendarDayConfigUtilities
