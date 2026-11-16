local Foundation = script:FindFirstAncestor("Foundation")

local DateTimeCalendarViewUtilities = require(script.Parent.DateTimeCalendarViewUtilities)
local DateTimePickerDateRangePreset = require(Foundation.Enums.DateTimePickerDateRangePreset)
local DateTimeUtilities = require(script.Parent.Parent.DateTimeUtilities)

local function toStartOfDay(dateTime) -- 1 equivalent call inferred from this helper
	local localTime = DateTimeUtilities.toLocalTime(dateTime)
	return DateTime.fromLocalTime(localTime.Year, localTime.Month, localTime.Day)
end

local function shiftDays(p, p2: number) -- 4 equivalent calls inferred from this helper
	local localTime = DateTimeUtilities.toLocalTime(p)
	local dateTime = DateTime.fromLocalTime(localTime.Year, localTime.Month, localTime.Day, 12, 0, 0)
	return toStartOfDay(DateTime.fromUnixTimestamp(dateTime.UnixTimestamp + p2 * 86400))
end

return {
	resolvePresetRange = function(p, p2)
		local v = p2 or DateTime.now()
		local localTime = DateTimeUtilities.toLocalTime(v)
		local v2 = toStartOfDay(v) -- inferred equivalent call

		if p == DateTimePickerDateRangePreset.Today then
			return { startDate = v2, endDate = v2 }
		end

		if p == DateTimePickerDateRangePreset.ThisWeek then
			local startDate = shiftDays(v2, -DateTimeCalendarViewUtilities.getDayOfWeek(v)) -- inferred equivalent call
			return { startDate = startDate, endDate = shiftDays(startDate, 6) } -- inferred equivalent call
		elseif p == DateTimePickerDateRangePreset.LastWeek then
			local startDate = shiftDays(v2, -DateTimeCalendarViewUtilities.getDayOfWeek(v) - 7) -- inferred equivalent call
			return { startDate = startDate, endDate = shiftDays(startDate, 6) } -- inferred equivalent call
		else
			if p == DateTimePickerDateRangePreset.ThisMonth then
				return {
					startDate = DateTime.fromLocalTime(localTime.Year, localTime.Month, 1),
					endDate = DateTime.fromLocalTime(
						localTime.Year,
						localTime.Month,
						DateTimeUtilities.getDaysInMonth(localTime.Month, localTime.Year)
					)
				}
			end

			if p == DateTimePickerDateRangePreset.ThisYear then
				return {
					startDate = DateTime.fromLocalTime(localTime.Year, 1, 1),
					endDate = DateTime.fromLocalTime(localTime.Year, 12, 31)
				}
			end

			return {
				startDate = DateTime.fromLocalTime(localTime.Year - 1, 1, 1),
				endDate = DateTime.fromLocalTime(localTime.Year - 1, 12, 31)
			}
		end
	end
}
