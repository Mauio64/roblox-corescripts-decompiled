local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/Time/ArgCheck")
local TimeUnit = require("@game/CorePackages/Workspace/Packages/_Index/Time/Time/TimeUnit")
local DateTime = require("@game/CorePackages/Workspace/Packages/_Index/Time/Time/DateTime")

local getFFlagSignUpBirthdayPickerRequireManualSelection = require("@game/CorePackages/Workspace/Packages/_Workspace/Time/SharedFlags").GetFFlagSignUpBirthdayPickerRequireManualSelection

local v6 = {
	["en-us"] = { [TimeUnit.Months] = 1, [TimeUnit.Days] = 2, [TimeUnit.Years] = 3 },
	["es-es"] = { [TimeUnit.Days] = 1, [TimeUnit.Months] = 2, [TimeUnit.Years] = 3 },
	["fr-fr"] = { [TimeUnit.Days] = 1, [TimeUnit.Months] = 2, [TimeUnit.Years] = 3 },
	["de-de"] = { [TimeUnit.Days] = 1, [TimeUnit.Months] = 2, [TimeUnit.Years] = 3 },
	["pt-br"] = { [TimeUnit.Days] = 1, [TimeUnit.Months] = 2, [TimeUnit.Years] = 3 },
	["zh-cn"] = { [TimeUnit.Years] = 1, [TimeUnit.Months] = 2, [TimeUnit.Days] = 3 },
	["zh-cjv"] = { [TimeUnit.Years] = 1, [TimeUnit.Months] = 2, [TimeUnit.Days] = 3 },
	["zh-tw"] = { [TimeUnit.Years] = 1, [TimeUnit.Months] = 2, [TimeUnit.Days] = 3 },
	["ko-kr"] = { [TimeUnit.Years] = 1, [TimeUnit.Months] = 2, [TimeUnit.Days] = 3 },
	["ja-jp"] = { [TimeUnit.Years] = 1, [TimeUnit.Months] = 2, [TimeUnit.Days] = 3 },
	["it-it"] = { [TimeUnit.Days] = 1, [TimeUnit.Months] = 2, [TimeUnit.Years] = 3 },
	["ru-ru"] = { [TimeUnit.Days] = 1, [TimeUnit.Months] = 2, [TimeUnit.Years] = 3 },
	["id-id"] = { [TimeUnit.Days] = 1, [TimeUnit.Months] = 2, [TimeUnit.Years] = 3 },
	["vi-vn"] = { [TimeUnit.Days] = 1, [TimeUnit.Months] = 2, [TimeUnit.Years] = 3 },
	["th-th"] = { [TimeUnit.Days] = 1, [TimeUnit.Months] = 2, [TimeUnit.Years] = 3 },
	["tr-tr"] = { [TimeUnit.Days] = 1, [TimeUnit.Months] = 2, [TimeUnit.Years] = 3 }
}
local v5 = {}

v5.ReasonDateInvalid = {
	IsFutureDate = "IsFutureDate",
	IsInvalidDayOfMonth = "IsInvalidDayOfMonth",
	IsIncompleteDate = "IsIncompleteDate"
}

v5.MonthsLocalizationKeys = {
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
}

v5.DateTypeOrder = setmetatable(v6, {
	__index = function(p2, p3)
		return { [TimeUnit.Years] = 1, [TimeUnit.Months] = 2, [TimeUnit.Days] = 3 }
	end
})

local v23 = { Prefix = "Prefix", Suffix = "Suffix", None = "None" }

v5.DayAffixLocalizationKey = "CommonUI.Controls.Label.Day"
v5.DayAffixType = setmetatable(
	{
		["zh-cn"] = "Suffix",
		["zh-tw"] = "Suffix",
		["ko-kr"] = "Suffix",
		["ja-jp"] = "Suffix"
	},
	{
		__index = function(p2, p3): string
			return "None"
		end
	}
)

v5.YearAffixLocalizationKey = "CommonUI.Controls.Label.Year"
v5.YearAffixType = setmetatable(
	{
		["zh-cn"] = "Suffix",
		["zh-tw"] = "Suffix",
		["ko-kr"] = "Suffix",
		["ja-jp"] = "Suffix"
	},
	{
		__index = function(p2, p3): string
			return "None"
		end
	}
)

function v5:GetFormattedDayString(p2, p3, p4)
	return self:GetFormattedString(TimeUnit.Days, p2, p3, p4)
end

function v5:GetFormattedYearString(p2, p3, p4)
	return self:GetFormattedString(TimeUnit.Years, p2, p3, p4)
end

function v5:GetFormattedString(p3, p4, p5, p6)
	ArgCheck.isNotNil(p3, "timeUnit passed into DateHelper:GetFormattedString")
	ArgCheck.isNotNil(p5, "affix passed into DateHelper:GetFormattedString")
	local kind = ArgCheck.isType(
		tostring(p4),
		"string",
		"dateValue passed into DateHelper:GetFormattedString"
	)

	local v24 = nil

	if p3 == TimeUnit.Days then
		v24 = self.DayAffixType[p6]
	elseif p3 == TimeUnit.Years then
		v24 = self.YearAffixType[p6]
	end

	if v24 == "Prefix" then
		return p5 .. kind
	elseif v24 == "Suffix" then
		return kind .. p5
	end

	return kind
end

function v5:GetFormattedFullString(p2, p3, p4, p5, p6, p7, p8)
	local kind = ArgCheck.isType(
		p2,
		"string",
		"localizedMonthString passed into DateHelper:GetFormattedFullString"
	)

	local kind2 = ArgCheck.isType(p7, "string", "divider passed into DateHelper:GetFormattedFullString")
	local kind3 = ArgCheck.isType(p8, "string", "localeKey passed into DateHelper:GetFormattedFullString")

	local v24 = self.DateTypeOrder[kind3]

	local formattedDayString = self:GetFormattedDayString(p3, p4, kind3)
	local formattedYearString = self:GetFormattedYearString(p5, p6, kind3)

	local v25 = {}
	v25[v24[TimeUnit.Months]] = kind
	v25[v24[TimeUnit.Days]] = formattedDayString
	v25[v24[TimeUnit.Years]] = formattedYearString
	local formattedFullString = ""

	for i, v26 in ipairs(v25) do
		formattedFullString ..= v26

		if i < #v25 then
			formattedFullString ..= kind2
		end
	end

	return formattedFullString
end

local function getCurrentDate()
	local values = DateTime.now():GetValues()

	return {
		[TimeUnit.Months] = ArgCheck.isNonNegativeNumber(values.Month, "current month in BirthdayPicker"),
		[TimeUnit.Days] = ArgCheck.isNonNegativeNumber(values.Day, "current day in BirthdayPicker"),
		[TimeUnit.Years] = ArgCheck.isNonNegativeNumber(values.Year, "current year in BirthdayPicker")
	}
end

function v5:getCurrentDate()
	return getCurrentDate()
end

local function getCurrentDateWithOffset(p2)
	local values = DateTime.fromUnixTimestamp(DateTime.now():GetUnixTimestamp() + p2):GetValues()

	return {
		[TimeUnit.Months] = ArgCheck.isNonNegativeNumber(values.Month, "current month in BirthdayPicker"),
		[TimeUnit.Days] = ArgCheck.isNonNegativeNumber(values.Day, "current day in BirthdayPicker"),
		[TimeUnit.Years] = ArgCheck.isNonNegativeNumber(values.Year, "current year in BirthdayPicker")
	}
end

function v5.isLeapYear(p2, p3): boolean
	return p3 % 4 == 0 and (p3 % 100 ~= 0 or p3 % 400 == 0)
end

local v24 = {}

function v5:_isFutureDate(p3, p4, p5, p6): boolean
	if p3[TimeUnit.Years] < p6 or p6 == p3[TimeUnit.Years] and p3[TimeUnit.Months] < p4 then
		return true
	end

	return p6 == p3[TimeUnit.Years] and p4 == p3[TimeUnit.Months] and p3[TimeUnit.Days] < p5
end

function v5:isFutureDate(p2, p3, p4)
	return self:_isFutureDate(getCurrentDate(), p2, p3, p4)
end

function v5:isRecentOrFutureDate(p2, p3, p4)
	return self:_isFutureDate(getCurrentDateWithOffset(-172800), p2, p3, p4)
end

function v5:getLastDayOfTheMonthInYear(p2, p3)
	if v24[p2] and v24[p2][p3] then
		return v24[p2][p3]
	end

	local v25

	if p2 == 2 then
		v25 = self:isLeapYear(p3) and 29 or 28
	else
		v25 = (p2 % 2 == 0 and p2 < 7 or p2 % 2 == 1 and p2 > 7) and 30 or 31
	end

	if not v24[p2] then
		v24[p2] = {}
	end

	v24[p2][p3] = v25

	return v25
end

function v5:isInvalidDayOfTheMonth(p2, p3, p4): boolean
	return self:getLastDayOfTheMonthInYear(p2, p4) < p3
end

function v5:isValidDate(p2, p3, p4)
	if getFFlagSignUpBirthdayPickerRequireManualSelection() and (p2 == nil or p3 == nil or p4 == nil) then
		return false, self.ReasonDateInvalid.IsIncompleteDate
	end

	if self:isRecentOrFutureDate(p2, p3, p4) then
		return false, self.ReasonDateInvalid.IsFutureDate
	end

	if self:isInvalidDayOfTheMonth(p2, p3, p4) then
		return false, self.ReasonDateInvalid.IsInvalidDayOfMonth
	end

	return true, nil
end

local function generateCellDatas(p2, p3, value)
	local cellDatas = {}

	for i = p2, p3, value or 1 do
		table.insert(cellDatas, { text = tostring(i), value = i })
	end

	return cellDatas
end

function v5.generateMonthCellDatas(p2)
	return generateCellDatas(1, 12)
end

function v5:generateDayCellDatas()
	return generateCellDatas(1, 31)
end

function v5:generateYearCellDatas(p3, p4)
	local currentDate = getCurrentDate()
	return generateCellDatas(p4 or currentDate[TimeUnit.Years], p3 or p4 - 100, -1)
end

return v5
