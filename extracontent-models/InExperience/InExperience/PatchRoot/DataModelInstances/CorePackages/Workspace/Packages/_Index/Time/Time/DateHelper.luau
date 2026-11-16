local parent = script:FindFirstAncestor("Time").Parent

local ArgCheck = require(parent.ArgCheck)
local TimeUnit = require(script.Parent.TimeUnit)
local DateTime = require(script.Parent.DateTime)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagSignUpBirthdayPickerRequireManualSelection = SharedFlags.GetFFlagSignUpBirthdayPickerRequireManualSelection

local v = {
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
local DateHelper = {}

DateHelper.ReasonDateInvalid = {
	IsFutureDate = "IsFutureDate",
	IsInvalidDayOfMonth = "IsInvalidDayOfMonth",
	IsIncompleteDate = "IsIncompleteDate"
}

DateHelper.MonthsLocalizationKeys = {
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

DateHelper.DateTypeOrder = setmetatable(v, {
	__index = function(_, _)
		return { [TimeUnit.Years] = 1, [TimeUnit.Months] = 2, [TimeUnit.Days] = 3 }
	end
})

local _ = { Prefix = "Prefix", Suffix = "Suffix", None = "None" }

DateHelper.DayAffixLocalizationKey = "CommonUI.Controls.Label.Day"
DateHelper.DayAffixType = setmetatable(
	{ ["zh-cn"] = "Suffix", ["zh-tw"] = "Suffix", ["ko-kr"] = "Suffix", ["ja-jp"] = "Suffix" },
	{
		__index = function(_, _): string
			return "None"
		end
	}
)

DateHelper.YearAffixLocalizationKey = "CommonUI.Controls.Label.Year"
DateHelper.YearAffixType = setmetatable(
	{ ["zh-cn"] = "Suffix", ["zh-tw"] = "Suffix", ["ko-kr"] = "Suffix", ["ja-jp"] = "Suffix" },
	{
		__index = function(_, _): string
			return "None"
		end
	}
)

function DateHelper:GetFormattedDayString(p: number, p2: string, p3: string)
	return self:GetFormattedString(TimeUnit.Days, p, p2, p3)
end

function DateHelper:GetFormattedYearString(p: number, p2: string, p3: string)
	return self:GetFormattedString(TimeUnit.Years, p, p2, p3)
end

function DateHelper:GetFormattedString(p: string, p2, p3, p4)
	ArgCheck.isNotNil(p, "timeUnit passed into DateHelper:GetFormattedString")
	ArgCheck.isNotNil(p3, "affix passed into DateHelper:GetFormattedString")
	local kind = ArgCheck.isType(tostring(p2), "string", "dateValue passed into DateHelper:GetFormattedString")

	local v2 = nil

	if p == TimeUnit.Days then
		v2 = self.DayAffixType[p4]
	elseif p == TimeUnit.Years then
		v2 = self.YearAffixType[p4]
	end

	if v2 == "Prefix" then
		return p3 .. kind
	elseif v2 == "Suffix" then
		return kind .. p3
	end

	return kind
end

function DateHelper:GetFormattedFullString(p, p2, p3, p4, p5, p6, p7)
	local kind = ArgCheck.isType(p, "string", "localizedMonthString passed into DateHelper:GetFormattedFullString")

	local kind2 = ArgCheck.isType(p6, "string", "divider passed into DateHelper:GetFormattedFullString")
	local kind3 = ArgCheck.isType(p7, "string", "localeKey passed into DateHelper:GetFormattedFullString")

	local v2 = self.DateTypeOrder[kind3]

	local formattedDayString = self:GetFormattedDayString(p2, p3, kind3)
	local formattedYearString = self:GetFormattedYearString(p4, p5, kind3)

	local v3 = {}
	v3[v2[TimeUnit.Months]] = kind
	v3[v2[TimeUnit.Days]] = formattedDayString
	v3[v2[TimeUnit.Years]] = formattedYearString
	local formattedFullString = ""

	for i, v4 in ipairs(v3) do
		formattedFullString ..= v4

		if i < #v3 then
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

function DateHelper.getCurrentDate(_)
	return getCurrentDate()
end

local function getCurrentDateWithOffset(p: number)
	local values = DateTime.fromUnixTimestamp(DateTime.now():GetUnixTimestamp() + p):GetValues()

	return {
		[TimeUnit.Months] = ArgCheck.isNonNegativeNumber(values.Month, "current month in BirthdayPicker"),
		[TimeUnit.Days] = ArgCheck.isNonNegativeNumber(values.Day, "current day in BirthdayPicker"),
		[TimeUnit.Years] = ArgCheck.isNonNegativeNumber(values.Year, "current year in BirthdayPicker")
	}
end

function DateHelper.isLeapYear(_, p: number): boolean
	return p % 4 == 0 and (p % 100 ~= 0 or p % 400 == 0)
end

local v2 = {}

function DateHelper:_isFutureDate(p, p2: number, p3: number, p4: number): boolean
	if p[TimeUnit.Years] < p4 or p4 == p[TimeUnit.Years] and p[TimeUnit.Months] < p2 then
		return true
	end

	return p4 == p[TimeUnit.Years] and p2 == p[TimeUnit.Months] and p[TimeUnit.Days] < p3
end

function DateHelper:isFutureDate(p: number, p2: number, p3: number)
	return self:_isFutureDate(getCurrentDate(), p, p2, p3)
end

function DateHelper:isRecentOrFutureDate(p: number, p2: number, p3: number)
	return self:_isFutureDate(getCurrentDateWithOffset(-172800), p, p2, p3)
end

function DateHelper:getLastDayOfTheMonthInYear(p: number, p2: number)
	if v2[p] and v2[p][p2] then
		return v2[p][p2]
	end

	local v3

	if p == 2 then
		v3 = self:isLeapYear(p2) and 29 or 28
	else
		v3 = (p % 2 == 0 and p < 7 or p % 2 == 1 and p > 7) and 30 or 31
	end

	if not v2[p] then
		v2[p] = {}
	end

	v2[p][p2] = v3

	return v3
end

function DateHelper:isInvalidDayOfTheMonth(p: number, p2: number, p3: number): boolean
	return self:getLastDayOfTheMonthInYear(p, p3) < p2
end

function DateHelper:isValidDate(p, p2, p3)
	if GetFFlagSignUpBirthdayPickerRequireManualSelection() and (p == nil or p2 == nil or p3 == nil) then
		return false, self.ReasonDateInvalid.IsIncompleteDate
	end

	if self:isRecentOrFutureDate(p, p2, p3) then
		return false, self.ReasonDateInvalid.IsFutureDate
	end

	if self:isInvalidDayOfTheMonth(p, p2, p3) then
		return false, self.ReasonDateInvalid.IsInvalidDayOfMonth
	end

	return true, nil
end

local function generateCellDatas(p: number, p2: number, value: number?)
	local cellDatas = {}

	for i = p, p2, value or 1 do
		table.insert(cellDatas, { text = tostring(i), value = i })
	end

	return cellDatas
end

function DateHelper.generateMonthCellDatas(_)
	return generateCellDatas(1, 12)
end

function DateHelper.generateDayCellDatas(_)
	return generateCellDatas(1, 31)
end

function DateHelper.generateYearCellDatas(_, p: number, p2: number)
	local currentDate = getCurrentDate()
	return generateCellDatas(p2 or currentDate[TimeUnit.Years], p or p2 - 100, -1)
end

return DateHelper
