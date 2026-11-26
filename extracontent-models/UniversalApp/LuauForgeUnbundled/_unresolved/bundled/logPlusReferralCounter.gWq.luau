local module = require("@luauforge/bundled/gWo")

local function logPlusReferralCounter(p2)
	module.default:logRobloxTelemetryCounter(p2, 1)
end

return logPlusReferralCounter
