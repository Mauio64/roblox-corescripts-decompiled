local module = require("@luauforge/bundled/guj")

local module2 = require("@luauforge/bundled/gui")
require("@luauforge/bundled/guk")
local module3 = require("@luauforge/bundled/gtY")

local function logPlusReferralEvent(p2, p3, items)
	local analyticsMetadata = module3.get().getAnalyticsMetadata(false)

	local v5 = { evt = p2, surface = p3 }

	if analyticsMetadata then
		v5.referrerId = analyticsMetadata.referrerId
		v5.referralCode = analyticsMetadata.referralCode
	end

	if items then
		for k, item in items do
			v5[k] = item
		end
	end

	module.default:logRobloxTelemetryEvent(
		module2.PlusReferralUiEvent,
		{ module.StandardizedFields.addSessionId },
		v5
	)
end

return logPlusReferralEvent
