local parent = script:FindFirstAncestor("AuthCommon").Parent

local ArgCheck = require(parent.ArgCheck)
local Time = require(parent.Time)
local DateTime = Time.DateTime

local Birthday = {}
local v = {}
Birthday[v] = true

function Birthday.new(data)
	local v2 = { Month = 1, Day = 1, Year = 1970 }

	if data then
		v2.Month = data.Month or v2.Month
		v2.Day = data.Day or v2.Day
		v2.Year = data.Year or v2.Year

		ArgCheck.isNonNegativeNumber(v2.Month, "month in Birthday constructor")
		ArgCheck.isNonNegativeNumber(v2.Day, "day in Birthday constructor")
		ArgCheck.isNonNegativeNumber(v2.Year, "year in Birthday constructor")
	end

	setmetatable(v2, Birthday)
	return v2
end

function Birthday.IsUnder13(data): boolean
	local v2 = Birthday.new(DateTime.now():GetValues())

	if v2.Year - 13 < data.Year then
		return true
	end

	if v2.Year - 13 > data.Year then
		return false
	end

	if v2.Month < data.Month then
		return true
	elseif v2.Month == data.Month then
		return v2.Day < data.Day
	else
		return false
	end
end

function Birthday.GetAgeInYears(data, p)
	local v2 = p or DateTime.now():GetValues()
	local v3 = Birthday.new(v2)

	if v3.Month < data.Month or v3.Month == data.Month and v3.Day < data.Day then
		return v3.Year - data.Year - 1
	end

	return v3.Year - data.Year
end

function Birthday.FormatForEndpoint(data)
	return data.Year .. "-" .. data.Month .. "-" .. data.Day .. "T12:00:00.000Z"
end

function Birthday.ToString(data, value)
	value = value or " "

	return data.Month .. value .. data.Day .. value .. data.Year
end

function Birthday.is(p): boolean
	return type(p) == "table" and p[v] == true
end

Birthday.__index = Birthday

return Birthday
