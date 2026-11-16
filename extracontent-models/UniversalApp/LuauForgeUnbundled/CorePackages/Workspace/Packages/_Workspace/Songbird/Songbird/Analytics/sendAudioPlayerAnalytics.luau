local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/LoggingProtocol")
require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Analytics/AnalyticActions")

local getFIntSongbirdTelemetryThrottle = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Flags/getFIntSongbirdTelemetryThrottle")

local v5 = {
	eventName = "AudioPlayerEvents",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = getFIntSongbirdTelemetryThrottle(),
	lastUpdated = { 25, 10, 24 },
	description = " Analytics for AudioPlayer component to track playback, favoriting, and reporting flows ",
	links = ""
}

local function createCounterEventConfig(action)
	return {
		eventName = `{v5.eventName}_{action}`,
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		throttlingPercentage = v5.throttlingPercentage,
		lastUpdated = v5.lastUpdated,
		description = v5.description,
		links = v5.links
	}
end

local function sendAudioPlayerAnalytics(p2)
	local counterEventConfig = createCounterEventConfig(p2.action)

	LoggingProtocol.default:logRobloxTelemetryEvent(v5, nil, p2)
	LoggingProtocol.default:logRobloxTelemetryCounter(counterEventConfig, 1)
end

return sendAudioPlayerAnalytics
