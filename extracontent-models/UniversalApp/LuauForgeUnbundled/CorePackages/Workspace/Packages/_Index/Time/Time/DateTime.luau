local LocalizationService = game:GetService("LocalizationService")

local TimeZone = require("@game/CorePackages/Workspace/Packages/_Index/Time/Time/TimeZone")

local class = {}

function class.new(value, value2, value3, value4, value5, value6, value7)
	local v5 = {
		dateTime = DateTime.fromUniversalTime(
			value or 1970,
			value2 or 1,
			value3 or 1,
			value4 or 0,
			value5 or 0,
			value6 or 0,
			value7 or 0
		)
	}

	setmetatable(v5, class)
	return v5
end

function class.now()
	local v5 = { dateTime = DateTime.now() }
	setmetatable(v5, class)
	return v5
end

function class.fromUnixTimestamp(value)
	assert(type(value) == "number", "Invalid argument #1 to fromUnixTimestamp, expected number.")

	local v5 = {
		dateTime = DateTime.fromUnixTimestampMillis(value * 1000)
	}
	setmetatable(v5, class)
	return v5
end

function class.fromUnixTimestampMillis(value)
	assert(type(value) == "number", "Invalid argument #1 to fromUnixTimestampMillis, expected number.")

	local v5 = {
		dateTime = DateTime.fromUnixTimestampMillis(value)
	}
	setmetatable(v5, class)
	return v5
end

function class.fromIsoDate(value)
	assert(type(value) == "string", "Invalid argument #1 to DateTime.fromIsoDate, expected string.")

	local v5 = { dateTime = DateTime.fromIsoDate(value) }
	setmetatable(v5, class)
	return v5
end

function class:Format(value, p3, p4)
	assert(type(value) == "string", "Invalid argument #1 to Format, expected string.")

	local v5 = p3 or TimeZone.Current
	local v6 = p4 or LocalizationService.RobloxLocaleId

	if v5 == TimeZone.UTC then
		return self.dateTime:FormatUniversalTime(value, v6)
	end

	if v5 == TimeZone.Current then
		return self.dateTime:FormatLocalTime(value, v6)
	end

	error(("Invalid TimeZone \"%s\""):format((tostring(v5))), 2)
end

function class:GetValues(p3)
	local v5 = p3 or TimeZone.Current

	if v5 == TimeZone.UTC then
		return self.dateTime:ToUniversalTime()
	end

	if v5 == TimeZone.Current then
		return self.dateTime:ToLocalTime()
	end

	error(("Invalid TimeZone \"%s\""):format((tostring(v5))), 2)
end

function class:GetUnixTimestamp()
	if self.dateTime:ToUniversalTime().Millisecond > 0 then
		return self.dateTime.UnixTimestamp + self.dateTime.UnixTimestampMillis % 1000 / 1000
	end

	return self.dateTime.UnixTimestamp
end

function class:GetIsoDate()
	return self.dateTime:ToIsoDate()
end

function class:GetLongRelativeTime(p2, p3, p4)
	return self:Format("lll", p3, p4)
end

function class:GetShortRelativeTime(p2, p3, p4)
	return self:Format("ll", p3 or TimeZone.Current, p4)
end

class.__index = class

return class
