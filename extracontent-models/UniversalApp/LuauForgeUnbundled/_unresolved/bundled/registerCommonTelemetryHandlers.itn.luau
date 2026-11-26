local module = require("@luauforge/bundled/isS")

local function registerCommonTelemetryHandlers()
	local module2 = require("@luauforge/bundled/isU")
	module2.registerDiscoveryImpressions()
	require("@luauforge/bundled/iti").registerPromptsImpressions()
	module2.registerDiscoveryActionTelemetryHandlers()

	local module3 = require("@luauforge/bundled/isV")

	if module3.FFlagSduiCreateSocialTelemetryRegistries then
		module3.registerSocialImpressions()
		module3.registerSocialActionTelemetryHandlers()
	end

	if module.FFlagEnableBuyRobuxSdui then
		local module4 = require("@luauforge/bundled/itl")
		module4.registerBuyRobuxSduiTelemetryHandlers()
		module4.registerBuyRobuxSduiImpressions()
	end
end

return registerCommonTelemetryHandlers
