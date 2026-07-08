local Parent = script:FindFirstAncestor("Time").Parent
local ArgCheck = require(Parent.ArgCheck)
local TimeUnit = require(script.Parent.TimeUnit)
local DateTime = require(script.Parent.DateTime)
local GetFFlagSignUpBirthdayPickerRequireManualSelection = require(Parent.SharedFlags).GetFFlagSignUpBirthdayPickerRequireManualSelection
local t1 = {
	ReasonDateInvalid = {
		IsFutureDate = "IsFutureDate",
		IsInvalidDayOfMonth = "IsInvalidDayOfMonth",
		IsIncompleteDate = "IsIncompleteDate"
	},
	MonthsLocalizationKeys = {
		"CommonUI.Controls.Label.January",
		"CommonUI.Controls.Label.February",
		"CommonUI.Controls.Label.March",
		"CommonUI.Controls.Label.April",
		"CommonUI.Controls.Label.May",
		"CommonUI.Controls.Label.June",
		"CommonUI.Controls.Label.July",
		"CommonUI.Controls.Label.August",
		"CommonUI.Controls.Label.September",
		"CommonUI.Controls.Label.October",
		"CommonUI.Controls.Label.November",
		"CommonUI.Controls.Label.December"
	},
	DateTypeOrder = setmetatable({
		["en-us"] = {
			[TimeUnit.Months] = 1,
			[TimeUnit.Days] = 2,
			[TimeUnit.Years] = 3
		},
		["es-es"] = {
			[TimeUnit.Days] = 1,
			[TimeUnit.Months] = 2,
			[TimeUnit.Years] = 3
		},
		["fr-fr"] = {
			[TimeUnit.Days] = 1,
			[TimeUnit.Months] = 2,
			[TimeUnit.Years] = 3
		},
		["de-de"] = {
			[TimeUnit.Days] = 1,
			[TimeUnit.Months] = 2,
			[TimeUnit.Years] = 3
		},
		["pt-br"] = {
			[TimeUnit.Days] = 1,
			[TimeUnit.Months] = 2,
			[TimeUnit.Years] = 3
		},
		["zh-cn"] = {
			[TimeUnit.Years] = 1,
			[TimeUnit.Months] = 2,
			[TimeUnit.Days] = 3
		},
		["zh-cjv"] = {
			[TimeUnit.Years] = 1,
			[TimeUnit.Months] = 2,
			[TimeUnit.Days] = 3
		},
		["zh-tw"] = {
			[TimeUnit.Years] = 1,
			[TimeUnit.Months] = 2,
			[TimeUnit.Days] = 3
		},
		["ko-kr"] = {
			[TimeUnit.Years] = 1,
			[TimeUnit.Months] = 2,
			[TimeUnit.Days] = 3
		},
		["ja-jp"] = {
			[TimeUnit.Years] = 1,
			[TimeUnit.Months] = 2,
			[TimeUnit.Days] = 3
		},
		["it-it"] = {
			[TimeUnit.Days] = 1,
			[TimeUnit.Months] = 2,
			[TimeUnit.Years] = 3
		},
		["ru-ru"] = {
			[TimeUnit.Days] = 1,
			[TimeUnit.Months] = 2,
			[TimeUnit.Years] = 3
		},
		["id-id"] = {
			[TimeUnit.Days] = 1,
			[TimeUnit.Months] = 2,
			[TimeUnit.Years] = 3
		},
		["vi-vn"] = {
			[TimeUnit.Days] = 1,
			[TimeUnit.Months] = 2,
			[TimeUnit.Years] = 3
		},
		["th-th"] = {
			[TimeUnit.Days] = 1,
			[TimeUnit.Months] = 2,
			[TimeUnit.Years] = 3
		},
		["tr-tr"] = {
			[TimeUnit.Days] = 1,
			[TimeUnit.Months] = 2,
			[TimeUnit.Years] = 3
		}
	}, {
		__index = function(_, _) -- line: 118
			-- upvalues: TimeUnit (copy)
			return {
				[TimeUnit.Years] = 1,
				[TimeUnit.Months] = 2,
				[TimeUnit.Days] = 3
			}
		end
	})
}
local _ = {
	Prefix = "Prefix",
	Suffix = "Suffix",
	None = "None"
}

t1.DayAffixLocalizationKey = "CommonUI.Controls.Label.Day"
t1.DayAffixType = setmetatable({
	["zh-cn"] = "Suffix",
	["zh-tw"] = "Suffix",
	["ko-kr"] = "Suffix",
	["ja-jp"] = "Suffix"
}, {
	__index = function(_, _) -- line: 140
		return "None"
	end
})
t1.YearAffixLocalizationKey = "CommonUI.Controls.Label.Year"
t1.YearAffixType = setmetatable({
	["zh-cn"] = "Suffix",
	["zh-tw"] = "Suffix",
	["ko-kr"] = "Suffix",
	["ja-jp"] = "Suffix"
}, {
	__index = function(_, _) -- line: 152
		return "None"
	end
})

function t1.GetFormattedDayString(t2: {[any]: any}, n1: number, s1: string, s2: string) -- line: 157
	-- upvalues: TimeUnit (copy)
	return t2:GetFormattedString(TimeUnit.Days, n1, s1, s2)
end
function t1.GetFormattedYearString(t3: {[any]: any}, n2: number, s3: string, s4: string) -- line: 161
	-- upvalues: TimeUnit (copy)
	return t3:GetFormattedString(TimeUnit.Years, n2, s3, s4)
end
function t1.GetFormattedString(t4: {[any]: any}, s5: string, p7, p8, p9) -- line: 165
	-- upvalues: ArgCheck (copy), TimeUnit (copy)
	ArgCheck.isNotNil(s5, "timeUnit passed into DateHelper:GetFormattedString")
	ArgCheck.isNotNil(p8, "affix passed into DateHelper:GetFormattedString")

	local v31 = ArgCheck.isType(tostring(p7), "string", "dateValue passed into DateHelper:GetFormattedString")
	local v32 = nil

	if s5 == TimeUnit.Days then
		v32 = t4.DayAffixType[p9]
	elseif s5 == TimeUnit.Years then
		v32 = t4.YearAffixType[p9]
	end

	if v32 == "Prefix" then
		return p8 .. v31
	end

	if v32 == "Suffix" then
		return v31 .. p8
	end

	return v31
end
function t1.GetFormattedFullString(p10, p11, p12, p13, p14, p15, p16, p17) -- line: 186
	-- upvalues: ArgCheck (copy), TimeUnit (copy)
	local v41 = ArgCheck.isType(p11, "string", "localizedMonthString passed into DateHelper:GetFormattedFullString")
	local v42 = ArgCheck.isType(p16, "string", "divider passed into DateHelper:GetFormattedFullString")
	local v43 = ArgCheck.isType(p17, "string", "localeKey passed into DateHelper:GetFormattedFullString")
	local v44 = p10.DateTypeOrder[v43]
	local FormattedDayString = p10:GetFormattedDayString(p12, p13, v43)
	local FormattedYearString = p10:GetFormattedYearString(p14, p15, v43)
	local s6 = ""
	local t5 = {
		[v44[TimeUnit.Months]] = v41,
		[v44[TimeUnit.Days]] = FormattedDayString,
		[v44[TimeUnit.Years]] = FormattedYearString
	}

	for i, v in ipairs(t5) do
		s6 ..= v

		if i < #t5 then
			s6 ..= v42
		end
	end

	return s6
end

local function getCurrentDate() -- line: 217
	-- upvalues: DateTime (copy), TimeUnit (copy), ArgCheck (copy)
	local Values = DateTime.now():GetValues()

	return {
		[TimeUnit.Months] = ArgCheck.isNonNegativeNumber(Values.Month, "current month in BirthdayPicker"),
		[TimeUnit.Days] = ArgCheck.isNonNegativeNumber(Values.Day, "current day in BirthdayPicker"),
		[TimeUnit.Years] = ArgCheck.isNonNegativeNumber(Values.Year, "current year in BirthdayPicker")
	}
end

function t1.getCurrentDate(_) -- line: 227
	-- upvalues: getCurrentDate (copy)
	return (getCurrentDate())
end

local function getCurrentDateWithOffset(n3: number) -- line: 231
	-- upvalues: DateTime (copy), TimeUnit (copy), ArgCheck (copy)
	local Values = DateTime.fromUnixTimestamp(DateTime.now():GetUnixTimestamp() + n3):GetValues()

	return {
		[TimeUnit.Months] = ArgCheck.isNonNegativeNumber(Values.Month, "current month in BirthdayPicker"),
		[TimeUnit.Days] = ArgCheck.isNonNegativeNumber(Values.Day, "current day in BirthdayPicker"),
		[TimeUnit.Years] = ArgCheck.isNonNegativeNumber(Values.Year, "current year in BirthdayPicker")
	}
end

function t1.isLeapYear(_: {[any]: any}, n4: number) -- line: 242
	return n4 % 4 == 0 and (n4 % 100 ~= 0 or n4 % 400 == 0)
end

local t7 = {}

function t1._isFutureDate(_: {[any]: any}, p19, n5: number, n6: number, n7: number) -- line: 248
	-- upvalues: TimeUnit (copy)
	if n7 > p19[TimeUnit.Years] then
		return true
	end

	if n7 == p19[TimeUnit.Years] and n5 > p19[TimeUnit.Months] then
		return true
	end

	if n7 == p19[TimeUnit.Years] and n5 == p19[TimeUnit.Months] and n6 > p19[TimeUnit.Days] then
		return true
	end

	return false
end
function t1.isFutureDate(t9: {[any]: any}, n8: number, n9: number, n10: number) -- line: 264
	-- upvalues: getCurrentDate (copy)
	return t9:_isFutureDate(getCurrentDate(), n8, n9, n10)
end
function t1.isRecentOrFutureDate(t10: {[any]: any}, n11: number, n12: number, n13: number) -- line: 270
	-- upvalues: getCurrentDateWithOffset (copy)
	return t10:_isFutureDate(getCurrentDateWithOffset(-172800), n11, n12, n13)
end
function t1.getLastDayOfTheMonthInYear(t11: {[any]: any}, n14: number, n15: number) -- line: 275
	-- upvalues: t7 (copy)
	if t7[n14] and t7[n14][n15] then
		return t7[n14][n15]
	end

	local v73 = if n14 ~= 2 then not (n14 % 2 == 0 and n14 < 7) and (n14 % 2 ~= 1 or not (n14 > 7)) and 31 or 30 else not t11:isLeapYear(n15) and 28 or 29

	if not t7[n14] then
		t7[n14] = {}
	end

	t7[n14][n15] = v73

	return v73
end
function t1.isInvalidDayOfTheMonth(t12: {[any]: any}, n16: number, n17: number, n18: number) -- line: 297
	return n17 > t12:getLastDayOfTheMonthInYear(n16, n18)
end
function t1.isValidDate(p20, p21, p22, p23) -- line: 309
	-- upvalues: GetFFlagSignUpBirthdayPickerRequireManualSelection (copy)
	if GetFFlagSignUpBirthdayPickerRequireManualSelection() and (p21 == nil or p22 == nil or p23 == nil) then
		return false, p20.ReasonDateInvalid.IsIncompleteDate
	end

	if p20:isRecentOrFutureDate(p21, p22, p23) then
		return false, p20.ReasonDateInvalid.IsFutureDate
	end

	if p20:isInvalidDayOfTheMonth(p21, p22, p23) then
		return false, p20.ReasonDateInvalid.IsInvalidDayOfMonth
	end

	return true, nil
end

local function generateCellDatas(n19: number, n20: number, n21: number?) -- line: 326
	local t13 = {}

	for i = n19, n20, n21 or 1 do
		table.insert(t13, {
			text = tostring(i),
			value = i
		})
	end

	return t13
end

function t1.generateMonthCellDatas(_) -- line: 338
	-- upvalues: generateCellDatas (copy)
	return (generateCellDatas(1, 12))
end
function t1.generateDayCellDatas(_) -- line: 342
	-- upvalues: generateCellDatas (copy)
	return (generateCellDatas(1, 31))
end
function t1.generateYearCellDatas(_: {[any]: any}, n22: number, n23: number) -- line: 346
	-- upvalues: getCurrentDate (copy), TimeUnit (copy), generateCellDatas (copy)
	local v92 = getCurrentDate()
	local v93 = n23 or v92[TimeUnit.Years]
	local v94 = n22 or n23 - 100

	return (generateCellDatas(v93, v94, -1))
end

return t1
