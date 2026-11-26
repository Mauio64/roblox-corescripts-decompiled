local module = require("@luauforge/bundled/icU")

local function logRobloxSubscriptionOnboardingSheetCounter(p2)
	module.default:logRobloxTelemetryCounter(p2, 1)
end

return logRobloxSubscriptionOnboardingSheetCounter
