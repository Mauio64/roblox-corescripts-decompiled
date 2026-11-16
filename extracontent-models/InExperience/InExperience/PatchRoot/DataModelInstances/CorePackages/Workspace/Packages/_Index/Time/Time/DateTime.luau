local LocalizationService = game:GetService("LocalizationService")

local TimeZone = require(script.Parent.TimeZone)

local DateTime2 = {}

function DateTime2.new(value, value2, value3, value4, value5, value6, value7)
	local v = {
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

	setmetatable(v, DateTime2)
	return v
end

function DateTime2.now()
	local v = { dateTime = DateTime.now() }
	setmetatable(v, DateTime2)
	return v
end

function DateTime2.fromUnixTimestamp(value)
	assert(type(value) == "number", "Invalid argument #1 to fromUnixTimestamp, expected number.")

	local v = {
		dateTime = DateTime.fromUnixTimestampMillis(value * 1000)
	}
	setmetatable(v, DateTime2)
	return v
end

function DateTime2.fromUnixTimestampMillis(value)
	assert(type(value) == "number", "Invalid argument #1 to fromUnixTimestampMillis, expected number.")

	local v = {
		dateTime = DateTime.fromUnixTimestampMillis(value)
	}
	setmetatable(v, DateTime2)
	return v
end

function DateTime2.fromIsoDate(value)
	assert(type(value) == "string", "Invalid argument #1 to DateTime.fromIsoDate, expected string.")

	local v = { dateTime = DateTime.fromIsoDate(value) }
	setmetatable(v, DateTime2)
	return v
end

function DateTime2:Format(value, p, p2)
	assert(type(value) == "string", "Invalid argument #1 to Format, expected string.")

	local v = p or TimeZone.Current
	local v2 = p2 or LocalizationService.RobloxLocaleId

	if v == TimeZone.UTC then
		return self.dateTime:FormatUniversalTime(value, v2)
	end

	if v == TimeZone.Current then
		return self.dateTime:FormatLocalTime(value, v2)
	end

	error(("Invalid TimeZone \"%s\""):format((tostring(v))), 2)
end

function DateTime2.GetValues(p, p2)
	local v = p2 or TimeZone.Current

	if v == TimeZone.UTC then
		return p.dateTime:ToUniversalTime()
	end

	if v == TimeZone.Current then
		return p.dateTime:ToLocalTime()
	end

	error(("Invalid TimeZone \"%s\""):format((tostring(v))), 2)
end

function DateTime2.GetUnixTimestamp(p)
	if p.dateTime:ToUniversalTime().Millisecond > 0 then
		return p.dateTime.UnixTimestamp + p.dateTime.UnixTimestampMillis % 1000 / 1000
	end

	return p.dateTime.UnixTimestamp
end

function DateTime2.GetIsoDate(p)
	return p.dateTime:ToIsoDate()
end

function DateTime2:GetLongRelativeTime(_, p, p2)
	return self:Format("lll", p, p2)
end

function DateTime2:GetShortRelativeTime(_, p, p2)
	return self:Format("ll", p or TimeZone.Current, p2)
end

DateTime2.__index = DateTime2

return DateTime2
