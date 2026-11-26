local robloxLocaleIdKey = require("@luauforge/deferred/gAn").RobloxLocaleIdKey

require("@luauforge/deferred/gzP")

local function parseDateFromString(p2, p3, value)
	local dateTime = DateTime.fromIsoDate(p2)

	if dateTime then
		return dateTime:FormatLocalTime(value or "LLL", p3[robloxLocaleIdKey])
	end

	return p2
end

return parseDateFromString
