local Foundation = script:FindFirstAncestor("Foundation")

local DateTimePickerRangeBandRole = require(Foundation.Enums.DateTimePickerRangeBandRole)
local DateTimeUtilities = require(script.Parent.Parent.DateTimeUtilities)
local Wrappers = require(Foundation.Utility.Wrappers)
local LocalizationService = Wrappers.Services.LocalizationService

local function roundUpToNearestHalfHour(p)
	local localTime = DateTimeUtilities.toLocalTime(p)

	if localTime.Second == 0 and (localTime.Minute == 0 or localTime.Minute == 30) then
		return DateTimeUtilities.roundDownToNearestMinute(p)
	end

	local roundToStartOfDay = DateTimeUtilities.roundToStartOfDay(p)
	local v = math.min(math.ceil((p.UnixTimestamp - roundToStartOfDay) / 1800) * 1800, 84600)

	return DateTime.fromUnixTimestamp(roundToStartOfDay + v)
end

local function getDayOfWeek(object) -- 1 equivalent call inferred from this helper
	return tonumber((object:FormatLocalTime("d", "en-us"))) or 0
end

local function getRangeDayBounds(p) -- 1 equivalent call inferred from this helper
	local roundToStartOfDay = DateTimeUtilities.roundToStartOfDay(p.startDate)
	local roundToStartOfDay2 = DateTimeUtilities.roundToStartOfDay(p.endDate)
	return math.min(roundToStartOfDay, roundToStartOfDay2), (math.max(roundToStartOfDay, roundToStartOfDay2))
end

local DateTimeCalendarViewUtilities = {}
DateTimeCalendarViewUtilities.getDayOfWeek = getDayOfWeek

function DateTimeCalendarViewUtilities.getRangeBandRadiusTag(object, p, p2): string
	local rangeDayBounds, v = getRangeDayBounds(p) -- inferred equivalent call
	local roundToStartOfDay = DateTimeUtilities.roundToStartOfDay(object)
	local v2 = rangeDayBounds < roundToStartOfDay
	local v3 = roundToStartOfDay < v
	local dayOfWeek = getDayOfWeek(object) -- inferred equivalent call
	local v4

	if p2 == DateTimePickerRangeBandRole.Start then
		v4 = false
	else
		v4 = dayOfWeek == 0 or not v2
	end

	local v5

	if p2 == DateTimePickerRangeBandRole.End then
		v5 = false
	else
		v5 = dayOfWeek == 6 or not v3
	end

	if v4 and v5 then
		return "radius-circle"
	end

	if v4 then
		return "radius-left-circle"
	end

	return if v5 then "radius-right-circle" else ""
end

DateTimeCalendarViewUtilities.getRangeDayBounds = getRangeDayBounds

function DateTimeCalendarViewUtilities.getTimeSlotIndex(items, p: number?)
	if p == nil then
		return nil
	end

	for k, item in items do
		if item.id == p then
			return k
		end
	end

	return nil
end

function DateTimeCalendarViewUtilities.getTimeSlotsForDay(p)
	local v = roundUpToNearestHalfHour(p)
	local localTime = DateTimeUtilities.toLocalTime(v)
	local unixTimestamp = DateTime.fromLocalTime(
		localTime.Year,
		localTime.Month,
		localTime.Day,
		localTime.Hour,
		localTime.Minute,
		0
	).UnixTimestamp

	local result = {}

	for i = 0, 47 do
		local v2 = math.floor(i / 2)
		local dateTime = DateTime.fromLocalTime(localTime.Year, localTime.Month, localTime.Day, v2, i % 2 * 30, 0)

		table.insert(result, {
			id = dateTime.UnixTimestamp,
			text = dateTime:FormatLocalTime("LT", LocalizationService.RobloxLocaleId)
		})
	end

	return result, unixTimestamp
end

function DateTimeCalendarViewUtilities.resolveAnchorDate(list, p)
	if list and list[1] then
		return list[1]
	end

	if p then
		return p
	end

	return DateTime.now()
end

DateTimeCalendarViewUtilities.roundUpToNearestHalfHour = roundUpToNearestHalfHour

function DateTimeCalendarViewUtilities.toViewDate(p)
	local localTime = DateTimeUtilities.toLocalTime(p)
	return { month = localTime.Month, year = localTime.Year }
end

return DateTimeCalendarViewUtilities
