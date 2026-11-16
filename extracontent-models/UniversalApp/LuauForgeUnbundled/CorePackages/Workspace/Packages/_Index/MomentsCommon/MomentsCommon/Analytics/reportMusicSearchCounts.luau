local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/LoggingProtocol")

local FFlagMomentsCreationMusicSearchCountTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsCreationMusicSearchCountTelemetry")

local v5 = {
	eventName = "MomentsCreationMusicSearchRawCount",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2026, 8, 27 },
	links = "",
	description = "Music-search result count BEFORE the creation-flow ISRC/RecordingCode filter (post creator-filter). Aggregated to p50/p95/p99; compare against MomentsCreationMusicSearchFilteredCount to see the filter drop. Dimensioned by queryPresent."
}

local v6 = {
	eventName = "MomentsCreationMusicSearchFilteredCount",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2026, 8, 27 },
	links = "",
	description = "Music-search result count AFTER the creation-flow ISRC/RecordingCode filter (tracks shown to the user). Aggregated to p50/p95/p99; compare against MomentsCreationMusicSearchRawCount to see the filter drop. Dimensioned by queryPresent."
}

local function defaultEmit(p2, p3, p4)
	LoggingProtocol.default:logRobloxTelemetryStat(p2, p3, p4)
end

local function reportMusicSearchCounts(p2, p3, p4, p5)
	if not FFlagMomentsCreationMusicSearchCountTelemetry then
		return
	end

	local v7 = { queryPresent = tostring(p4.queryPresent) }
	local v8 = p5 or defaultEmit
	pcall(v8, v5, p2, v7)
	pcall(v8, v6, p3, v7)
end

return reportMusicSearchCounts
