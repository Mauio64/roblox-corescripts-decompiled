local Foundation = script:FindFirstAncestor("Foundation")
local LocalizationService = require(Foundation.Utility.Wrappers).Services.LocalizationService
local Translator = require(Foundation.Utility.Localization.Translator)
local t1 = {
	[1] = Translator:FormatByKey("CommonUI.Controls.Label.January"),
	[2] = Translator:FormatByKey("CommonUI.Controls.Label.February"),
	[3] = Translator:FormatByKey("CommonUI.Controls.Label.March"),
	[4] = Translator:FormatByKey("CommonUI.Controls.Label.April"),
	[5] = Translator:FormatByKey("CommonUI.Controls.Label.May"),
	[6] = Translator:FormatByKey("CommonUI.Controls.Label.June"),
	[7] = Translator:FormatByKey("CommonUI.Controls.Label.July"),
	[8] = Translator:FormatByKey("CommonUI.Controls.Label.August"),
	[9] = Translator:FormatByKey("CommonUI.Controls.Label.September"),
	[10] = Translator:FormatByKey("CommonUI.Controls.Label.October"),
	[11] = Translator:FormatByKey("CommonUI.Controls.Label.November"),
	[12] = Translator:FormatByKey("CommonUI.Controls.Label.December")
}
local t2 = {
	[1] = Translator:FormatByKey("CommonUI.Controls.Label.SundayAbbreviated"),
	[2] = Translator:FormatByKey("CommonUI.Controls.Label.MondayAbbreviated"),
	[3] = Translator:FormatByKey("CommonUI.Controls.Label.TuesdayAbbreviated"),
	[4] = Translator:FormatByKey("CommonUI.Controls.Label.WednesdayAbbreviated"),
	[5] = Translator:FormatByKey("CommonUI.Controls.Label.ThursdayAbbreviated"),
	[6] = Translator:FormatByKey("CommonUI.Controls.Label.FridayAbbreviated"),
	[7] = Translator:FormatByKey("CommonUI.Controls.Label.SaturdayAbbreviated")
}

local function getDaysInMonth(n1: number, n2: number) -- line: 34
	if n1 == 2 and (n2 % 4 == 0 and n2 % 100 ~= 0 or n2 % 400 == 0) then
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
	})[n1]
end
local function getHoursAndMinutesFromString(s1: string) -- line: 104
	local v29 = s1:gsub("%s+", "")
	local match = string.match(v29, "^%d%d:%d%d$")
	local match2 = string.match(v29, "^%d%d?:%d%d[AP]M$")

	if not match and not match2 then
		return nil
	end

	if match2 then
		local v32, v33 = string.match(v29, "^(%d%d?):(%d%d)[AP]M$")
		local num = tonumber(v32)
		local num2 = tonumber(v33)

		if not num or not num2 or num < 1 or num > 12 or num2 < 0 or num2 > 59 then
			return nil
		end

		if string.sub(v29, -2) == "PM" and num ~= 12 then
			return num + 12, num2
		end

		if string.sub(v29, -2) == "AM" and num == 12 then
			return 0, num2
		end

		return num, num2
	end

	local v36, v37 = string.match(v29, "^(%d%d?):(%d%d)$")
	local num = tonumber(v36)
	local num3 = tonumber(v37)

	if not num or not num3 or num < 0 or num > 23 or num3 < 0 or num3 > 59 then
		return nil
	end

	return num, num3
end

return {
	DATE_COMPOSITE_TOKEN = "L",
	TIME_COMPOSITE_TOKEN = "LT",
	formatLocalTime = function(p1, b1: boolean?) -- line: 229
		-- upvalues: LocalizationService (copy)
		local v55 = p1:FormatLocalTime("L", LocalizationService.RobloxLocaleId)

		if b1 then
			v55 ..= ", " .. p1:FormatLocalTime("LT", LocalizationService.RobloxLocaleId)
		end

		return v55
	end,
	getDaysInMonth = getDaysInMonth,
	getFirstDayOfWeek = function(n3: number, n4: number) -- line: 48
		local dateTime = DateTime.fromLocalTime(n4, n3, 1)

		if dateTime then
			return tonumber((dateTime:FormatLocalTime("d", "en-us"))) or 0
		end

		return 0
	end,
	getLastDayOfWeek = function(n5: number, n6: number) -- line: 60
		-- upvalues: getDaysInMonth (copy)
		local dateTime = DateTime.fromLocalTime(n6, n5, (getDaysInMonth(n5, n6)))

		if dateTime then
			return tonumber((dateTime:FormatLocalTime("d", "en-us"))) or 0
		end

		return 0
	end,
	getNextMonthInfo = function(n7: number, n8: number) -- line: 222
		if n7 == 12 then
			return 1, n8 + 1
		end

		return n7 + 1, n8
	end,
	getPrevMonthInfo = function(n9: number, n10: number) -- line: 215
		if n9 == 1 then
			return 12, n10 - 1
		end

		return n9 - 1, n10
	end,
	isDateWithinRange = function(p2, t3: {[any]: any}) -- line: 84
		local v22 = t3.startDate:ToLocalTime()
		local UnixTimestamp = DateTime.fromLocalTime(v22.Year, v22.Month, v22.Day).UnixTimestamp
		local v24 = t3.endDate:ToLocalTime()
		local UnixTimestamp2 = DateTime.fromLocalTime(v24.Year, v24.Month, v24.Day).UnixTimestamp
		local v26 = p2:ToLocalTime()
		local UnixTimestamp3 = DateTime.fromLocalTime(v26.Year, v26.Month, v26.Day).UnixTimestamp

		return UnixTimestamp <= UnixTimestamp3 and UnixTimestamp3 <= UnixTimestamp2
	end,
	getDateTimeFromText = function(s2: string) -- line: 159
		-- upvalues: getHoursAndMinutesFromString (copy)
		local v41

		if string.find(s2, ",") then
			s2, v41 = s2:match("^([^,]+),%s*(.+)$")
		else
			v41 = "00:00"
		end

		if not s2 or not v41 then
			return nil
		end

		local v42 = s2:gsub("%s+", "")
		local v43, v44 = getHoursAndMinutesFromString(v41)

		if s2 then
			local v45 = v42:find("[/%.%-]")
			local ok, result = pcall(function() -- line: 183
				-- upvalues: v45 (copy), v42 (copy), v43 (copy), v44 (copy)
				if v45 == 3 then
					local v56, v57, v58 = v42:match("^(%d%d)[/%.%-](%d%d)[/%.%-](%d%d%d%d)$")

					return DateTime.fromLocalTime(tonumber(v58), tonumber(v56), tonumber(v57), v43, v44, 0)
				end

				if v45 == 5 then
					local v59, v60, v61 = v42:match("^(%d%d%d%d)[/%.%-](%d%d)[/%.%-](%d%d)$")

					return DateTime.fromLocalTime(tonumber(v59), tonumber(v60), tonumber(v61), v43, v44, 0)
				end

				error("Invalid date format: " .. v42)
			end)

			if ok and result then
				if os.date("*t", result.UnixTimestamp).isdst then
					local UnixTimestamp = result.UnixTimestamp

					result = DateTime.fromUnixTimestamp(UnixTimestamp - 3600)
				end

				return result
			end
		end

		return nil
	end,
	monthMap = t1,
	roundDownToNearestMinute = function(p3) -- line: 78
		local v19 = p3:ToLocalTime()

		return DateTime.fromLocalTime(v19.Year, v19.Month, v19.Day, v19.Hour, v19.Minute, 0)
	end,
	roundToStartOfDay = function(p4) -- line: 72
		local v17 = p4:ToLocalTime()

		return DateTime.fromLocalTime(v17.Year, v17.Month, v17.Day).UnixTimestamp
	end,
	weekdays = t2
}
