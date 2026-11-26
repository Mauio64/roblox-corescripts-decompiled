local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/ArgCheck")
local dateTime = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Time").DateTime

local class = {}
local v5 = {}
class[v5] = true

function class.new(data)
	local v6 = { Month = 1, Day = 1, Year = 1970 }

	if data then
		v6.Month = data.Month or v6.Month
		v6.Day = data.Day or v6.Day
		v6.Year = data.Year or v6.Year

		ArgCheck.isNonNegativeNumber(v6.Month, "month in Birthday constructor")
		ArgCheck.isNonNegativeNumber(v6.Day, "day in Birthday constructor")
		ArgCheck.isNonNegativeNumber(v6.Year, "year in Birthday constructor")
	end

	setmetatable(v6, class)
	return v6
end

function class.IsUnder13(data)
	local v6 = class.new(dateTime.now():GetValues())

	if v6.Year - 13 < data.Year then
		return true
	end

	if v6.Year - 13 > data.Year then
		return false
	end

	local v7 = v6.Month < data.Month or v6.Month == data.Month and v6.Day < data.Day
	return v7
end

function class:GetAgeInYears(p2)
	local v6 = p2 or dateTime.now():GetValues()
	local v7 = class.new(v6)

	if v7.Month < self.Month or v7.Month == self.Month and v7.Day < self.Day then
		return v7.Year - self.Year - 1
	end

	return v7.Year - self.Year
end

function class.FormatForEndpoint(data)
	return data.Year .. "-" .. data.Month .. "-" .. data.Day .. "T12:00:00.000Z"
end

function class:ToString(value)
	local v6 = value or " "

	return self.Month .. v6 .. self.Day .. v6 .. self.Year
end

function class.is(p2): boolean
	if type(p2) == "table" then
		return p2[v5] == true
	end

	return false
end

class.__index = class

return class
