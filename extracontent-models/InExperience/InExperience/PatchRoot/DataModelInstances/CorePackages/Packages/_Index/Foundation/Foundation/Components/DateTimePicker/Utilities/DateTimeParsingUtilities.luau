local Foundation = script:FindFirstAncestor("Foundation")

local DateTimeEqualityUtilities = require(script.Parent.DateTimeEqualityUtilities)
local DateTimePickerVariant = require(Foundation.Enums.DateTimePickerVariant)
local DateTimeUtilities = require(script.Parent.Parent.DateTimeUtilities)

local function parseTimeFromText(value: string)
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

local function adjustForDaylightSaving(result)
	local v = os.date("*t", result.UnixTimestamp)

	if v and v.isdst then
		return DateTime.fromUnixTimestamp(result.UnixTimestamp - 3600)
	end

	return result
end

local function parseDateTimeFromText(value: string)
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
	local v3, v4 = parseTimeFromText(v)

	if v3 == nil or v4 == nil then
		return nil
	end

	local v5 = v2:find("[/%.%-]")

	local success, result = pcall(function()
		if v5 == 3 then
			local match, v6, v7 = v2:match("^(%d%d)[/%.%-](%d%d)[/%.%-](%d%d%d%d)$")
			return DateTime.fromLocalTime(tonumber(v7), tonumber(match), tonumber(v6), v3, v4, 0)
		end

		if v5 == 5 then
			local match, v6, v7 = v2:match("^(%d%d%d%d)[/%.%-](%d%d)[/%.%-](%d%d)$")
			return DateTime.fromLocalTime(tonumber(match), tonumber(v6), tonumber(v7), v3, v4, 0)
		end

		error("Invalid date format: " .. v2)
	end)

	if success and result then
		return adjustForDaylightSaving(result)
	end

	return nil
end

local function trimInputText(value: string) -- 2 equivalent calls inferred from this helper
	return (value:gsub("^%s*(.-)%s*$", "%1"))
end

local function parseDualInputEndpoints(value: string) -- 1 equivalent call inferred from this helper
	local parts = value:split(" - ")
	local selected

	if parts[1] then
		selected = parseDateTimeFromText(trimInputText(parts[1])) -- inferred equivalent call
	end

	if parts[2] then
		return selected, (parseDateTimeFromText(trimInputText(parts[2]))) -- inferred equivalent call
	end

	return selected, nil
end

local DateTimeParsingUtilities = {}
DateTimeParsingUtilities.adjustForDaylightSaving = adjustForDaylightSaving

function DateTimeParsingUtilities.formatInputText(p)
	local date = p.dates[1]

	if not date then
		return ""
	end

	if p.variant == DateTimePickerVariant.Dual or p.variant == DateTimePickerVariant.DualWithPresets then
		local date2 = p.dates[2]
		return `{DateTimeUtilities.formatLocalTime(date)} - {not date2 and "" or DateTimeUtilities.formatLocalTime(date2)}`
	end

	local v = p.variant == DateTimePickerVariant.SingleWithTime
	return DateTimeUtilities.formatLocalTime(date, v)
end

DateTimeParsingUtilities.parseDateTimeFromText = parseDateTimeFromText
DateTimeParsingUtilities.parseDualInputEndpoints = parseDualInputEndpoints

function DateTimeParsingUtilities.parseInputToDraftDates(value: string, p)
	if #value:split(" - ") ~= 2 then
		return nil
	end

	local endDate, startDate = parseDualInputEndpoints(value) -- inferred equivalent call

	if not (endDate and startDate) then
		return nil
	end

	if not (DateTimeUtilities.roundToStartOfDay(endDate) > DateTimeUtilities.roundToStartOfDay(startDate)) then
		endDate, startDate = startDate, endDate
	end

	if
		p
		and not DateTimeEqualityUtilities.isRangeWithinSelectableRange({
			startDate = startDate,
			endDate = endDate
		}, p)
	then
		return nil
	end

	return { startDate, endDate }
end

DateTimeParsingUtilities.trimInputText = trimInputText
return DateTimeParsingUtilities
