local TelemetryService = game:GetService("TelemetryService")

local v5 = {
	eventName = require("@luauforge/bundled/fsy").AuthEventName.AuthButtonShown,
	backends = { "EventIngest" },
	throttlingPercentage = 10000,
	lastUpdated = { 2026, 6, 10 },
	description = "Event fired when an auth button is shown",
	links = "https://roblox.atlassian.net/wiki/spaces/Client/pages/2496467637/Engine+Telemetry+V2+API+Migration+Guide"
}

return function(p2, p3, btn, state, origin, url)
	local v6 = {}

	if btn then
		v6.btn = btn
	end

	if state then
		v6.state = state
	end

	if origin then
		v6.origin = origin
	end

	if url then
		v6.url = url
	end

	TelemetryService:LogEvent(v5, { eventContext = p3, customFields = v6 })
end
