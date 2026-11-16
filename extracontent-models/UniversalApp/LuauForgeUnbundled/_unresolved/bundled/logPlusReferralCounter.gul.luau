local module = require("@luauforge/bundled/guj")

local function logPlusReferralCounter(p2)
	module.default:logRobloxTelemetryCounter(p2, 1)
end

return logPlusReferralCounter
