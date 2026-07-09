local Songbird = script:FindFirstAncestor("Songbird")
local LoggingProtocol = require(Songbird.Parent.LoggingProtocol)

require(Songbird.Analytics.AnalyticActions)

local getFIntSongbirdTelemetryThrottle = require(Songbird.Flags.getFIntSongbirdTelemetryThrottle)
local t1 = {
	eventName = "AudioPlayerEvents",
	description = " Analytics for AudioPlayer component to track playback, favoriting, and reporting flows ",
	links = "",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = getFIntSongbirdTelemetryThrottle(),
	lastUpdated = {
		25,
		10,
		24
	}
}

local function createCounterEventConfig(s1: string) -- line: 23
	-- upvalues: t1 (copy), LoggingProtocol (copy)
	return {
		eventName = `{ t1.eventName }_{ s1 }`,
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		throttlingPercentage = t1.throttlingPercentage,
		lastUpdated = t1.lastUpdated,
		description = t1.description,
		links = t1.links
	}
end
local function sendAudioPlayerAnalytics(t2: {[any]: any}) -- line: 45
	-- upvalues: createCounterEventConfig (copy), LoggingProtocol (copy), t1 (copy)
	local v9 = createCounterEventConfig(t2.action)

	LoggingProtocol.default:logRobloxTelemetryEvent(t1, nil, t2)
	LoggingProtocol.default:logRobloxTelemetryCounter(v9, 1)
end

return sendAudioPlayerAnalytics
