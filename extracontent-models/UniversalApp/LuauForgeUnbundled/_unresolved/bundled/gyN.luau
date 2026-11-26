local module = require("@luauforge/bundled/dzP")
local timeUnit = require("@luauforge/bundled/geM").TimeUnit
local dateTime = require("@luauforge/bundled/geM").DateTime

local v6 = {
	["en-us"] = { [timeUnit.Months] = 1, [timeUnit.Days] = 2, [timeUnit.Years] = 3 },
	["es-es"] = { [timeUnit.Days] = 1, [timeUnit.Months] = 2, [timeUnit.Years] = 3 },
	["fr-fr"] = { [timeUnit.Days] = 1, [timeUnit.Months] = 2, [timeUnit.Years] = 3 },
	["de-de"] = { [timeUnit.Days] = 1, [timeUnit.Months] = 2, [timeUnit.Years] = 3 },
	["pt-br"] = { [timeUnit.Days] = 1, [timeUnit.Months] = 2, [timeUnit.Years] = 3 },
	["zh-cn"] = { [timeUnit.Years] = 1, [timeUnit.Months] = 2, [timeUnit.Days] = 3 },
	["zh-cjv"] = { [timeUnit.Years] = 1, [timeUnit.Months] = 2, [timeUnit.Days] = 3 },
	["zh-tw"] = { [timeUnit.Years] = 1, [timeUnit.Months] = 2, [timeUnit.Days] = 3 },
	["ko-kr"] = { [timeUnit.Years] = 1, [timeUnit.Months] = 2, [timeUnit.Days] = 3 },
	["ja-jp"] = { [timeUnit.Years] = 1, [timeUnit.Months] = 2, [timeUnit.Days] = 3 },
	["it-it"] = { [timeUnit.Days] = 1, [timeUnit.Months] = 2, [timeUnit.Years] = 3 },
	["ru-ru"] = { [timeUnit.Days] = 1, [timeUnit.Months] = 2, [timeUnit.Years] = 3 },
	["id-id"] = { [timeUnit.Days] = 1, [timeUnit.Months] = 2, [timeUnit.Years] = 3 },
	["vi-vn"] = { [timeUnit.Days] = 1, [timeUnit.Months] = 2, [timeUnit.Years] = 3 },
	["th-th"] = { [timeUnit.Days] = 1, [timeUnit.Months] = 2, [timeUnit.Years] = 3 },
	["tr-tr"] = { [timeUnit.Days] = 1, [timeUnit.Months] = 2, [timeUnit.Years] = 3 }
}
local v5 = {}

v5.ReasonDateInvalid = {
	IsFutureDate = "IsFutureDate",
	IsInvalidDayOfMonth = "IsInvalidDayOfMonth"
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
		return p2["en-us"]
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
v5.YearAffixType = setmetatable({
	["zh-cn"] = "Suffix",
	["zh-tw"] = "Suffix",
	["ko-kr"] = "Suffix",
	["ja-jp"] = "Suffix",
	["th-th"] = "Prefix"
}, {
	__index = function(p2, p3): string
		return "None"
	end
})

function v5:GetFormattedDayString(p2, p3, p4)
	return self:GetFormattedString(timeUnit.Days, p2, p3, p4)
end

function v5:GetFormattedYearString(p2, p3, p4)
	return self:GetFormattedString(timeUnit.Years, p2, p3, p4)
end

function v5:GetFormattedString(p3, p4, p5, p6)
	module.isNotNil(p3, "timeUnit passed into DateHelper:GetFormattedString")
	module.isNotNil(p5, "affix passed into DateHelper:GetFormattedString")
	local kind = module.isType(
		tostring(p4),
		"string",
		"dateValue passed into DateHelper:GetFormattedString"
	)

	local v24 = nil

	if p3 == timeUnit.Days then
		v24 = self.DayAffixType[p6]
	elseif p3 == timeUnit.Years then
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
	local kind = module.isType(
		p2,
		"string",
		"localizedMonthString passed into DateHelper:GetFormattedFullString"
	)

	local kind2 = module.isType(p7, "string", "divider passed into DateHelper:GetFormattedFullString")
	local kind3 = module.isType(p8, "string", "localeKey passed into DateHelper:GetFormattedFullString")

	local v24 = self.DateTypeOrder[kind3]

	local formattedDayString = self:GetFormattedDayString(p3, p4, kind3)
	local formattedYearString = self:GetFormattedYearString(p5, p6, kind3)

	local v25 = {}
	v25[v24[timeUnit.Months]] = kind
	v25[v24[timeUnit.Days]] = formattedDayString
	v25[v24[timeUnit.Years]] = formattedYearString
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
	local values = dateTime.now():GetValues()

	return {
		[timeUnit.Months] = module.isNonNegativeNumber(values.Month, "current month in BirthdayPicker"),
		[timeUnit.Days] = module.isNonNegativeNumber(values.Day, "current day in BirthdayPicker"),
		[timeUnit.Years] = module.isNonNegativeNumber(values.Year, "current year in BirthdayPicker")
	}
end

local function getCurrentDateWithOffset(p2)
	local values = dateTime.fromUnixTimestamp(dateTime.now():GetUnixTimestamp() + p2):GetValues()

	return {
		[timeUnit.Months] = module.isNonNegativeNumber(values.Month, "current month in BirthdayPicker"),
		[timeUnit.Days] = module.isNonNegativeNumber(values.Day, "current day in BirthdayPicker"),
		[timeUnit.Years] = module.isNonNegativeNumber(values.Year, "current year in BirthdayPicker")
	}
end

function v5.isLeapYear(p2, p3): boolean
	return p3 % 4 == 0 and (p3 % 100 ~= 0 or p3 % 400 == 0)
end

local v24 = {}

function v5:_isFutureDate(p3, p4, p5, p6): boolean
	if p3[timeUnit.Years] < p6 or p6 == p3[timeUnit.Years] and p3[timeUnit.Months] < p4 then
		return true
	end

	return p6 == p3[timeUnit.Years] and p4 == p3[timeUnit.Months] and p3[timeUnit.Days] < p5
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
	if self:isRecentOrFutureDate(p2, p3, p4) then
		return false, self.ReasonDateInvalid.IsFutureDate
	end

	if self:isInvalidDayOfTheMonth(p2, p3, p4) then
		return false, self.ReasonDateInvalid.IsInvalidDayOfMonth
	end

	return true, nil
end

return v5
