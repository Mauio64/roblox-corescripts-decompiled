local robloxLocaleIdKey = require("@luauforge/deferred/fVp").RobloxLocaleIdKey

require("@luauforge/deferred/fUR")

local function parseDateFromString(p2, p3, value)
	local dateTime = DateTime.fromIsoDate(p2)

	if dateTime then
		return dateTime:FormatLocalTime(value or "LLL", p3[robloxLocaleIdKey])
	end

	return p2
end

return parseDateFromString
