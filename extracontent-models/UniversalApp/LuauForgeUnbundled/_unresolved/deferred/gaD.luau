local module = require("@luauforge/bundled/eeH")
local module2 = require("@luauforge/bundled/edB")

return function(p2, value)
	local v5 = module(module2)

	local dateTime = p2 and DateTime.fromIsoDate(p2)

	if not dateTime then
		return nil
	end

	return dateTime:FormatLocalTime(value or "l", (v5:GetLocale()))
end
