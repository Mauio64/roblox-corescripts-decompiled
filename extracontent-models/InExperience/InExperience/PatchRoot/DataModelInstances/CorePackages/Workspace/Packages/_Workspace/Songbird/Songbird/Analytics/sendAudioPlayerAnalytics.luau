local Songbird = script:FindFirstAncestor("Songbird")

local LoggingProtocol = require(Songbird.Parent.LoggingProtocol)
require(Songbird.Analytics.AnalyticActions)

local getFIntSongbirdTelemetryThrottle = require(Songbird.Flags.getFIntSongbirdTelemetryThrottle)

local v = {
	eventName = "AudioPlayerEvents",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = getFIntSongbirdTelemetryThrottle(),
	lastUpdated = { 25, 10, 24 },
	description = " Analytics for AudioPlayer component to track playback, favoriting, and reporting flows ",
	links = ""
}

local function createCounterEventConfig(action: string)
	return {
		eventName = `{v.eventName}_{action}`,
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		throttlingPercentage = v.throttlingPercentage,
		lastUpdated = v.lastUpdated,
		description = v.description,
		links = v.links
	}
end

local function sendAudioPlayerAnalytics(p)
	local counterEventConfig = createCounterEventConfig(p.action)

	LoggingProtocol.default:logRobloxTelemetryEvent(v, nil, p)
	LoggingProtocol.default:logRobloxTelemetryCounter(counterEventConfig, 1)
end

return sendAudioPlayerAnalytics
