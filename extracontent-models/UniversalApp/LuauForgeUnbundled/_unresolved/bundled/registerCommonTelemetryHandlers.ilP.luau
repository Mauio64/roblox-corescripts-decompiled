local module = require("@luauforge/bundled/ilv")

local function registerCommonTelemetryHandlers()
	local module2 = require("@luauforge/bundled/ilx")
	module2.registerDiscoveryImpressions()
	require("@luauforge/bundled/ilL").registerPromptsImpressions()
	module2.registerDiscoveryActionTelemetryHandlers()

	local module3 = require("@luauforge/bundled/ily")

	if module3.FFlagSduiCreateSocialTelemetryRegistries then
		module3.registerSocialImpressions()
		module3.registerSocialActionTelemetryHandlers()
	end

	if module.FFlagEnableBuyRobuxSdui then
		local module4 = require("@luauforge/bundled/ilO")
		module4.registerBuyRobuxSduiTelemetryHandlers()
		module4.registerBuyRobuxSduiImpressions()
	end
end

return registerCommonTelemetryHandlers
