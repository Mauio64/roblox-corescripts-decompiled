local LocalizationService = game:GetService("LocalizationService")
local TimeZone = require(script.Parent.TimeZone)
local t1 = {}

function t1.new(p1, p2, p3, p4, p5, p6, p7) -- line: 27
	-- upvalues: t1 (copy)
	local t2 = {
		dateTime = DateTime.fromUniversalTime(p1 or 1970, p2 or 1, p3 or 1, p4 or 0, p5 or 0, p6 or 0, p7 or 0)
	}

	setmetatable(t2, t1)

	return t2
end
function t1.now() -- line: 45
	-- upvalues: t1 (copy)
	local t3 = {
		dateTime = DateTime.now()
	}

	setmetatable(t3, t1)

	return t3
end
function t1.fromUnixTimestamp(p8) -- line: 58
	-- upvalues: t1 (copy)
	assert(type(p8) == "number", "Invalid argument #1 to fromUnixTimestamp, expected number.")

	local t4 = {
		dateTime = DateTime.fromUnixTimestampMillis(p8 * 1000)
	}

	setmetatable(t4, t1)

	return t4
end
function t1.fromIsoDate(p9) -- line: 74
	-- upvalues: t1 (copy)
	assert(type(p9) == "string", "Invalid argument #1 to DateTime.fromIsoDate, expected string.")

	local t5 = {
		dateTime = DateTime.fromIsoDate(p9)
	}

	setmetatable(t5, t1)

	return t5
end
function t1.Format(p10, p11, p12, p13) -- line: 91
	-- upvalues: TimeZone (copy), LocalizationService (copy)
	assert(type(p11) == "string", "Invalid argument #1 to Format, expected string.")

	local v21 = p12 or TimeZone.Current
	local v22 = p13 or LocalizationService.RobloxLocaleId

	if v21 == TimeZone.UTC then
		return p10.dateTime:FormatUniversalTime(p11, v22)
	end

	if v21 == TimeZone.Current then
		return p10.dateTime:FormatLocalTime(p11, v22)
	end

	error(("Invalid TimeZone \"%s\""):format((tostring(v21))), 2)
end
function t1.GetValues(p14, p15) -- line: 114
	-- upvalues: TimeZone (copy)
	local v25 = p15 or TimeZone.Current

	if v25 == TimeZone.UTC then
		return p14.dateTime:ToUniversalTime()
	end

	if v25 == TimeZone.Current then
		return p14.dateTime:ToLocalTime()
	end

	error(("Invalid TimeZone \"%s\""):format((tostring(v25))), 2)
end
function t1.GetUnixTimestamp(p16) -- line: 129
	if p16.dateTime:ToUniversalTime().Millisecond > 0 then
		return p16.dateTime.UnixTimestamp + p16.dateTime.UnixTimestampMillis % 1000 / 1000
	end

	return p16.dateTime.UnixTimestamp
end
function t1.GetIsoDate(p17) -- line: 143
	return p17.dateTime:ToIsoDate()
end
function t1.GetLongRelativeTime(p18, _, p20, p21) -- line: 151
	return p18:Format("lll", p20, p21)
end
function t1.GetShortRelativeTime(p22, _, p24, p25) -- line: 160
	-- upvalues: TimeZone (copy)
	return p22:Format("ll", p24 or TimeZone.Current, p25)
end

t1.__index = t1

return t1
