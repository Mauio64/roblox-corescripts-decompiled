local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local LoggingProtocol = require(parent.LoggingProtocol)

local FFlagMomentsCreationMusicSearchCountTelemetry = require(MomentsCommon.Flags.FFlagMomentsCreationMusicSearchCountTelemetry)

local v = {
	eventName = "MomentsCreationMusicSearchRawCount",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2026, 8, 27 },
	links = "",
	description = "Music-search result count BEFORE the creation-flow ISRC/RecordingCode filter (post creator-filter). Aggregated to p50/p95/p99; compare against MomentsCreationMusicSearchFilteredCount to see the filter drop. Dimensioned by queryPresent."
}

local v2 = {
	eventName = "MomentsCreationMusicSearchFilteredCount",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 2026, 8, 27 },
	links = "",
	description = "Music-search result count AFTER the creation-flow ISRC/RecordingCode filter (tracks shown to the user). Aggregated to p50/p95/p99; compare against MomentsCreationMusicSearchRawCount to see the filter drop. Dimensioned by queryPresent."
}

local function defaultEmit(p, p2: number, p3)
	LoggingProtocol.default:logRobloxTelemetryStat(p, p2, p3)
end

local function reportMusicSearchCounts(p: number, p2: number, p3, callback)
	if not FFlagMomentsCreationMusicSearchCountTelemetry then
		return
	end

	local v3 = { queryPresent = tostring(p3.queryPresent) }
	local v4 = callback or defaultEmit
	pcall(v4, v, p, v3)
	pcall(v4, v2, p2, v3)
end

return reportMusicSearchCounts
