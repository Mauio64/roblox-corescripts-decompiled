local module = require("@luauforge/deferred/fbD")
local module2 = require("@luauforge/deferred/fbB")

local defineFastInt = game:DefineFastInt("SchoolsAnalyticsThrottlingThousandths", 10000)

return module2.Telemetry.createEmitter({
	telemetryImpl = module.default,
	defaultTelemetryConfig = { throttlingThousandths = defineFastInt, links = "" },
	getSharedInfo = function()
		return {}
	end
})
