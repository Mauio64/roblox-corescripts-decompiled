local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/LoggingProtocol")

local v5 = {
	eventName = "MomentsAnalyticsSkip",
	backends = { "RobloxTelemetryCounter" },
	throttlingPercentage = 10000,
	lastUpdated = { 2026, 9, 2 },
	description = "Counts schema-targeted moment-scoped analytics events skipped because the raw feedItemId was absent. Dimensioned by surface/reason/entry."
}

local function defaultEmit(p2, p3, p4)
	LoggingProtocol.default:logRobloxTelemetryCounter(p2, p3, p4)
end

local function reportMomentSkip(p2, p3, data, p4)
	local v6 = { surface = p2, reason = p3 }

	if data then
		if data.entry ~= nil then
			v6.entry = data.entry
		end

		if data.action ~= nil then
			v6.action = data.action
		end

		if data.parentEntity ~= nil then
			v6.parentEntity = data.parentEntity
		end
	end

	(p4 or defaultEmit)(v5, 1, v6)
end

return reportMomentSkip
