local Foundation = script:FindFirstAncestor("Foundation")

local Wrappers = require(Foundation.Utility.Wrappers)
local LocalizationService = Wrappers.Services.LocalizationService
local Translator = require(Foundation.Utility.Localization.Translator)

local function getDaysInMonth(p: number, p2: number)
	if p == 2 and (p2 % 4 == 0 and p2 % 100 ~= 0 or p2 % 400 == 0) then
		return 29
	end

	return ({
		31,
		28,
		31,
		30,
		31,
		30,
		31,
		31,
		30,
		31,
		30,
		31
	})[p]
end

local function toLocalTime(object) -- 2 equivalent calls inferred from this helper
	return (object:ToLocalTime())
end

local function roundToStartOfDay(object) -- 3 equivalent calls inferred from this helper
	local localTime = toLocalTime(object) -- inferred equivalent call
	return DateTime.fromLocalTime(localTime.Year, localTime.Month, localTime.Day).UnixTimestamp
end

local function getHoursAndMinutesFromString(value: string)
	local v = value:gsub("%s+", "")

	local v2 = string.match(v, "^%d%d:%d%d$")
	local v3 = string.match(v, "^%d%d?:%d%d[AP]M$")

	if not (v2 or v3) then
		return nil
	end

	if v3 then
		local v4, v5 = string.match(v, "^(%d%d?):(%d%d)[AP]M$")
		local v6 = tonumber(v4)
		local v7 = tonumber(v5)

		if not v6 or not v7 or v6 < 1 or v6 > 12 or v7 < 0 or v7 > 59 then
			return nil
		end

		if string.sub(v, -2) == "PM" and v6 ~= 12 then
			return v6 + 12, v7
		end

		if string.sub(v, -2) == "AM" and v6 == 12 then
			return 0, v7
		end

		return v6, v7
	else
		local v4, v5 = string.match(v, "^(%d%d?):(%d%d)$")
		local v6 = tonumber(v4)
		local v7 = tonumber(v5)

		if v6 and v7 and not (v6 < 0 or v6 > 23 or v7 < 0 or v7 > 59) then
			return v6, v7
		end

		return nil
	end
end

local DateTimeUtilities = {}

function DateTimeUtilities.formatLocalTime(object, flag: boolean?)
	local v = object:FormatLocalTime("L", LocalizationService.RobloxLocaleId)

	if flag then
		return v .. ", " .. object:FormatLocalTime("LT", LocalizationService.RobloxLocaleId)
	end

	return v
end

function DateTimeUtilities.getDateTimeFromText(value: string)
	local v

	if string.find(value, ",") then
		value, v = value:match("^([^,]+),%s*(.+)$")
	else
		v = "00:00"
	end

	if not (value and v) then
		return nil
	end

	local v2 = value:gsub("%s+", "")

	local hoursAndMinutesFromString, v3 = getHoursAndMinutesFromString(v)

	if not value then
		return nil
	end

	local v4 = v2:find("[/%.%-]")

	local success, result = pcall(function()
		if v4 == 3 then
			local match, v5, v6 = v2:match("^(%d%d)[/%.%-](%d%d)[/%.%-](%d%d%d%d)$")
			return DateTime.fromLocalTime(tonumber(v6), tonumber(match), tonumber(v5), hoursAndMinutesFromString, v3, 0)
		end

		if v4 == 5 then
			local match, v5, v6 = v2:match("^(%d%d%d%d)[/%.%-](%d%d)[/%.%-](%d%d)$")
			return DateTime.fromLocalTime(tonumber(match), tonumber(v5), tonumber(v6), hoursAndMinutesFromString, v3, 0)
		end

		error("Invalid date format: " .. v2)
	end)

	if success and result then
		if os.date("*t", result.UnixTimestamp).isdst then
			local unixTimestamp = result.UnixTimestamp
			result = DateTime.fromUnixTimestamp(unixTimestamp - 3600)
		end

		return result
	end

	return nil
end

DateTimeUtilities.getDaysInMonth = getDaysInMonth

function DateTimeUtilities.getFirstDayOfWeek(p: number, p2: number)
	local dateTime = DateTime.fromLocalTime(p2, p, 1)

	if dateTime then
		return tonumber((dateTime:FormatLocalTime("d", "en-us"))) or 0
	end

	return 0
end

function DateTimeUtilities.getLastDayOfWeek(p: number, p2: number)
	local dateTime = DateTime.fromLocalTime(p2, p, getDaysInMonth(p, p2))

	if dateTime then
		return tonumber((dateTime:FormatLocalTime("d", "en-us"))) or 0
	end

	return 0
end

function DateTimeUtilities.getNextMonthInfo(p: number, p2: number)
	if p == 12 then
		return 1, p2 + 1
	end

	return p + 1, p2
end

function DateTimeUtilities.getPrevMonthInfo(p: number, p2: number)
	if p == 1 then
		return 12, p2 - 1
	end

	return p - 1, p2
end

function DateTimeUtilities.isDateWithinRange(p, p2): boolean
	local unixTimestamp = roundToStartOfDay(p2.startDate) -- inferred equivalent call
	local unixTimestamp2 = roundToStartOfDay(p2.endDate) -- inferred equivalent call
	local unixTimestamp3 = roundToStartOfDay(p) -- inferred equivalent call
	return unixTimestamp <= unixTimestamp3 and unixTimestamp3 <= unixTimestamp2
end

DateTimeUtilities.monthMap = {
	Translator:FormatByKey("CommonUI.Controls.Label.January"),
	Translator:FormatByKey("CommonUI.Controls.Label.February"),
	Translator:FormatByKey("CommonUI.Controls.Label.March"),
	Translator:FormatByKey("CommonUI.Controls.Label.April"),
	Translator:FormatByKey("CommonUI.Controls.Label.May"),
	Translator:FormatByKey("CommonUI.Controls.Label.June"),
	Translator:FormatByKey("CommonUI.Controls.Label.July"),
	Translator:FormatByKey("CommonUI.Controls.Label.August"),
	Translator:FormatByKey("CommonUI.Controls.Label.September"),
	Translator:FormatByKey("CommonUI.Controls.Label.October"),
	Translator:FormatByKey("CommonUI.Controls.Label.November"),
	(Translator:FormatByKey("CommonUI.Controls.Label.December"))
}

function DateTimeUtilities.roundDownToNearestMinute(object)
	local localTime = toLocalTime(object) -- inferred equivalent call
	return DateTime.fromLocalTime(localTime.Year, localTime.Month, localTime.Day, localTime.Hour, localTime.Minute, 0)
end

DateTimeUtilities.roundToStartOfDay = roundToStartOfDay
DateTimeUtilities.toLocalTime = toLocalTime
DateTimeUtilities.weekdays = {
	Translator:FormatByKey("CommonUI.Controls.Label.SundayAbbreviated"),
	Translator:FormatByKey("CommonUI.Controls.Label.MondayAbbreviated"),
	Translator:FormatByKey("CommonUI.Controls.Label.TuesdayAbbreviated"),
	Translator:FormatByKey("CommonUI.Controls.Label.WednesdayAbbreviated"),
	Translator:FormatByKey("CommonUI.Controls.Label.ThursdayAbbreviated"),
	Translator:FormatByKey("CommonUI.Controls.Label.FridayAbbreviated"),
	(Translator:FormatByKey("CommonUI.Controls.Label.SaturdayAbbreviated"))
}
return DateTimeUtilities
