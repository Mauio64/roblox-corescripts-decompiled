local module = require("@luauforge/deferred/eUE")
local module2 = require("@luauforge/deferred/eUC")

local defineFastInt = game:DefineFastInt("SchoolsAnalyticsThrottlingThousandths", 10000)

return module2.Telemetry.createEmitter({
	telemetryImpl = module.default,
	defaultTelemetryConfig = { throttlingThousandths = defineFastInt, links = "" },
	getSharedInfo = function()
		return {}
	end
})
