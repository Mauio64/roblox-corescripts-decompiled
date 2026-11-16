local parent = script:FindFirstAncestor("MomentsCommon").Parent

local LoggingProtocol = require(parent.LoggingProtocol)

local v = {
	eventName = "MomentsAnalyticsSkip",
	backends = { "RobloxTelemetryCounter" },
	throttlingPercentage = 10000,
	lastUpdated = { 2026, 9, 2 },
	description = "Counts schema-targeted moment-scoped analytics events skipped because the raw feedItemId was absent. Dimensioned by surface/reason/entry."
}

local function defaultEmit(p, p2: number, p3)
	LoggingProtocol.default:logRobloxTelemetryCounter(p, p2, p3)
end

local function reportMomentSkip(surface: string, reason: string, data, callback)
	local v2 = { surface = surface, reason = reason }

	if data then
		if data.entry ~= nil then
			v2.entry = data.entry
		end

		if data.action ~= nil then
			v2.action = data.action
		end

		if data.parentEntity ~= nil then
			v2.parentEntity = data.parentEntity
		end
	end

	(callback or defaultEmit)(v, 1, v2)
end

return reportMomentSkip
