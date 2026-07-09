local CorePackages = game:GetService("CorePackages")
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local TimeUnit = require(CorePackages.Workspace.Packages.Time).TimeUnit
local DateTime = require(CorePackages.Workspace.Packages.Time).DateTime
local t1 = {
	ReasonDateInvalid = {
		IsFutureDate = "IsFutureDate",
		IsInvalidDayOfMonth = "IsInvalidDayOfMonth"
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
		__index = function(p1, _) -- line: 117
			return p1["en-us"]
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
	__index = function(_, _) -- line: 135
		return "None"
	end
})
t1.YearAffixLocalizationKey = "CommonUI.Controls.Label.Year"
t1.YearAffixType = setmetatable({
	["zh-cn"] = "Suffix",
	["zh-tw"] = "Suffix",
	["ko-kr"] = "Suffix",
	["ja-jp"] = "Suffix",
	["th-th"] = "Prefix"
}, {
	__index = function(_, _) -- line: 148
		return "None"
	end
})

function t1.GetFormattedDayString(p7, p8, p9, p10) -- line: 153
	-- upvalues: TimeUnit (copy)
	return p7:GetFormattedString(TimeUnit.Days, p8, p9, p10)
end
function t1.GetFormattedYearString(p11, p12, p13, p14) -- line: 157
	-- upvalues: TimeUnit (copy)
	return p11:GetFormattedString(TimeUnit.Years, p12, p13, p14)
end
function t1.GetFormattedString(p15, p16, p17, p18, p19) -- line: 161
	-- upvalues: ArgCheck (copy), TimeUnit (copy)
	ArgCheck.isNotNil(p16, "timeUnit passed into DateHelper:GetFormattedString")
	ArgCheck.isNotNil(p18, "affix passed into DateHelper:GetFormattedString")

	local v29 = ArgCheck.isType(tostring(p17), "string", "dateValue passed into DateHelper:GetFormattedString")
	local v30 = nil

	if p16 == TimeUnit.Days then
		v30 = p15.DayAffixType[p19]
	elseif p16 == TimeUnit.Years then
		v30 = p15.YearAffixType[p19]
	end

	if v30 == "Prefix" then
		return p18 .. v29
	end

	if v30 == "Suffix" then
		return v29 .. p18
	end

	return v29
end
function t1.GetFormattedFullString(p20, p21, p22, p23, p24, p25, p26, p27) -- line: 182
	-- upvalues: ArgCheck (copy), TimeUnit (copy)
	local v39 = ArgCheck.isType(p21, "string", "localizedMonthString passed into DateHelper:GetFormattedFullString")
	local v40 = ArgCheck.isType(p26, "string", "divider passed into DateHelper:GetFormattedFullString")
	local v41 = ArgCheck.isType(p27, "string", "localeKey passed into DateHelper:GetFormattedFullString")
	local v42 = p20.DateTypeOrder[v41]
	local FormattedDayString = p20:GetFormattedDayString(p22, p23, v41)
	local FormattedYearString = p20:GetFormattedYearString(p24, p25, v41)
	local s1 = ""
	local t2 = {
		[v42[TimeUnit.Months]] = v39,
		[v42[TimeUnit.Days]] = FormattedDayString,
		[v42[TimeUnit.Years]] = FormattedYearString
	}

	for i, v in ipairs(t2) do
		s1 ..= v

		if i < #t2 then
			s1 ..= v40
		end
	end

	return s1
end

local function getCurrentDate() -- line: 213
	-- upvalues: DateTime (copy), TimeUnit (copy), ArgCheck (copy)
	local Values = DateTime.now():GetValues()

	return {
		[TimeUnit.Months] = ArgCheck.isNonNegativeNumber(Values.Month, "current month in BirthdayPicker"),
		[TimeUnit.Days] = ArgCheck.isNonNegativeNumber(Values.Day, "current day in BirthdayPicker"),
		[TimeUnit.Years] = ArgCheck.isNonNegativeNumber(Values.Year, "current year in BirthdayPicker")
	}
end
local function getCurrentDateWithOffset(p28) -- line: 223
	-- upvalues: DateTime (copy), TimeUnit (copy), ArgCheck (copy)
	local Values = DateTime.fromUnixTimestamp(DateTime.now():GetUnixTimestamp() + p28):GetValues()

	return {
		[TimeUnit.Months] = ArgCheck.isNonNegativeNumber(Values.Month, "current month in BirthdayPicker"),
		[TimeUnit.Days] = ArgCheck.isNonNegativeNumber(Values.Day, "current day in BirthdayPicker"),
		[TimeUnit.Years] = ArgCheck.isNonNegativeNumber(Values.Year, "current year in BirthdayPicker")
	}
end

function t1.isLeapYear(_, p30) -- line: 234
	return p30 % 4 == 0 and (p30 % 100 ~= 0 or p30 % 400 == 0)
end

local t3 = {}

function t1._isFutureDate(_, p32, p33, p34, p35) -- line: 240
	-- upvalues: TimeUnit (copy)
	if p35 > p32[TimeUnit.Years] then
		return true
	end

	if p35 == p32[TimeUnit.Years] and p33 > p32[TimeUnit.Months] then
		return true
	end

	if p35 == p32[TimeUnit.Years] and p33 == p32[TimeUnit.Months] and p34 > p32[TimeUnit.Days] then
		return true
	end

	return false
end
function t1.isFutureDate(p36, p37, p38, p39) -- line: 256
	-- upvalues: getCurrentDate (copy)
	return p36:_isFutureDate(getCurrentDate(), p37, p38, p39)
end
function t1.isRecentOrFutureDate(p40, p41, p42, p43) -- line: 262
	-- upvalues: getCurrentDateWithOffset (copy)
	return p40:_isFutureDate(getCurrentDateWithOffset(-172800), p41, p42, p43)
end
function t1.getLastDayOfTheMonthInYear(p44, p45, p46) -- line: 267
	-- upvalues: t3 (copy)
	if t3[p45] and t3[p45][p46] then
		return t3[p45][p46]
	end

	local v70 = if p45 ~= 2 then not (p45 % 2 == 0 and p45 < 7) and (p45 % 2 ~= 1 or not (p45 > 7)) and 31 or 30 else not p44:isLeapYear(p46) and 28 or 29

	if not t3[p45] then
		t3[p45] = {}
	end

	t3[p45][p46] = v70

	return v70
end
function t1.isInvalidDayOfTheMonth(p47, p48, p49, p50) -- line: 289
	return p49 > p47:getLastDayOfTheMonthInYear(p48, p50)
end
function t1.isValidDate(p51, p52, p53, p54) -- line: 301
	if p51:isRecentOrFutureDate(p52, p53, p54) then
		return false, p51.ReasonDateInvalid.IsFutureDate
	end

	if p51:isInvalidDayOfTheMonth(p52, p53, p54) then
		return false, p51.ReasonDateInvalid.IsInvalidDayOfMonth
	end

	return true, nil
end

return t1
