local TelemetryService = game:GetService("TelemetryService")

local v5 = {
	eventName = "LuaAppObservedErrorSignal",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 2026, 9, 4 },
	description = "Count every error observed on the LuaErrorReporter's signal, before rate limiting or parsing."
}

return {
	logObservedErrorSignal = function()
		TelemetryService:LogCounter(v5, {}, 1)
	end
}
