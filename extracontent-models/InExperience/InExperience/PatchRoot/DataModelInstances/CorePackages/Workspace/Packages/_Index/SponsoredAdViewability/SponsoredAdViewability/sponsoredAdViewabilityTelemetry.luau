local TelemetryService = game:GetService("TelemetryService")

require(script.Parent.sponsoredAdViewabilityState)
require(script.Parent.sponsoredAdViewabilityTypes)

local standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" }

local v = {
	eventName = "SponsoredAdLoad",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("LuaAppSponsoredAdLoadTelemetryThrottlingHundredthsPercent", 0),
	lastUpdated = { 26, 6, 11 },
	description = "\t\tFires once per served sponsored ad when its tile begins to render on a surface.\n\t"
}

local v2 = {
	eventName = "SponsoredAdViewableImpression",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt(
		"LuaAppSponsoredAdViewableImpressionTelemetryThrottlingHundredthsPercent",
		0
	),
	lastUpdated = { 26, 6, 16 },
	description = [[
			Fires once per IAB viewable-impression milestone reached by a served sponsored ad
			(image: standard 50% / 1s, large 30% / 1s, full 100% / 1s;
			video: standard 50% / 2s while playing, full 100% / 1s while playing).
		]]
}

local v3 = {
	eventName = "SponsoredAdUnload",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("LuaAppSponsoredAdUnloadTelemetryThrottlingHundredthsPercent", 0),
	lastUpdated = { 26, 6, 25 },
	description = [[
		Fires once per served sponsored ad when its viewability session reaches a terminal
		boundary, carrying the session's dwell and in-view duration summary.
	]]
}

local v4 = {
	eventName = "SponsoredAdVideoProgress",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("LuaAppSponsoredAdVideoProgressTelemetryThrottlingHundredthsPercent", 0),
	lastUpdated = { 26, 7, 21 },
	description = [[
			Fires once for each 0 / 25 / 50 / 75 / 100 video-progress milestone reached
			within a served sponsored ad session.
		]]
}

local function buildGeometryFields(p)
	local adSize = p.adSize
	local viewportBounds = p.viewportBounds
	local adWidth

	if adSize.X > 0 then
		adWidth = adSize.X
	end

	local adHeight

	if adSize.Y > 0 then
		adHeight = adSize.Y
	end

	return {
		adWidth = adWidth,
		adHeight = adHeight,
		viewportWidth = viewportBounds.max.X - viewportBounds.min.X,
		viewportHeight = viewportBounds.max.Y - viewportBounds.min.Y
	}
end

local SponsoredAdViewabilityTelemetry = {}

function SponsoredAdViewabilityTelemetry.logSponsoredAdLoad(data, p, viewabilitySessionStartTimestampMs: number, p2)
	local geometryFields = buildGeometryFields(p)
	local customFields = {
		encryptedAdTrackingData = data.encryptedAdTrackingData,
		tileType = data.tileType,
		viewabilitySessionStartTimestampMs = viewabilitySessionStartTimestampMs,
		adWidth = geometryFields.adWidth,
		adHeight = geometryFields.adHeight,
		viewportWidth = geometryFields.viewportWidth,
		viewportHeight = geometryFields.viewportHeight
	}

	if data.mediaType == "video" then
		customFields.isFullScreen = data.isFullscreen == true
	end

	if p2 ~= nil then
		customFields.videoLengthMs = p2.videoLengthMs
	end

	TelemetryService:LogEvent(v, {
		standardizedFields = standardizedFields,
		customFields = customFields
	})
end

function SponsoredAdViewabilityTelemetry.logSponsoredAdViewableImpression(p, data)
	local geometryFields = buildGeometryFields(data.geometry)
	local customFields = {
		encryptedAdTrackingData = p.encryptedAdTrackingData,
		tileType = p.tileType,
		milestoneLabel = data.milestoneLabel,
		viewabilitySessionStartTimestampMs = data.viewabilitySessionStartTimestampMs,
		adWidth = geometryFields.adWidth,
		adHeight = geometryFields.adHeight,
		viewportWidth = geometryFields.viewportWidth,
		viewportHeight = geometryFields.viewportHeight,
		cumulative30PercentInViewDurationMs = data.cumulative30PercentInViewDurationMs,
		cumulative50PercentInViewDurationMs = data.cumulative50PercentInViewDurationMs,
		cumulative100PercentInViewDurationMs = data.cumulative100PercentInViewDurationMs,
		maxContinuous30PercentInViewDurationMs = data.maxContinuous30PercentInViewDurationMs,
		maxContinuous50PercentInViewDurationMs = data.maxContinuous50PercentInViewDurationMs,
		maxContinuous100PercentInViewDurationMs = data.maxContinuous100PercentInViewDurationMs
	}

	customFields.isFullScreen = data.isFullScreen
	customFields.videoLengthMs = data.videoLengthMs
	customFields.maxAudioLevel = data.maxAudioLevel
	customFields.cumulativeInGridViewDurationMs = data.cumulativeInGridViewDurationMs
	customFields.cumulativeFullScreenViewDurationMs = data.cumulativeFullScreenViewDurationMs

	TelemetryService:LogEvent(v2, {
		standardizedFields = standardizedFields,
		customFields = customFields
	})
end

function SponsoredAdViewabilityTelemetry.logSponsoredAdVideoProgress(p, data)
	local geometryFields = buildGeometryFields(data.geometry)

	TelemetryService:LogEvent(v4, {
		standardizedFields = standardizedFields,
		customFields = {
			encryptedAdTrackingData = p.encryptedAdTrackingData,
			tileType = p.tileType,
			isFullScreen = data.isFullScreen,
			adWidth = geometryFields.adWidth,
			adHeight = geometryFields.adHeight,
			viewportWidth = geometryFields.viewportWidth,
			viewportHeight = geometryFields.viewportHeight,
			viewabilitySessionStartTimestampMs = data.viewabilitySessionStartTimestampMs,
			cumulative30PercentInViewDurationMs = data.cumulative30PercentInViewDurationMs,
			cumulative50PercentInViewDurationMs = data.cumulative50PercentInViewDurationMs,
			cumulative100PercentInViewDurationMs = data.cumulative100PercentInViewDurationMs,
			maxContinuous30PercentInViewDurationMs = data.maxContinuous30PercentInViewDurationMs,
			maxContinuous50PercentInViewDurationMs = data.maxContinuous50PercentInViewDurationMs,
			maxContinuous100PercentInViewDurationMs = data.maxContinuous100PercentInViewDurationMs,
			videoProgress = data.videoProgress,
			videoLengthMs = data.videoLengthMs,
			videoCumulativePlaytimeMs = data.videoCumulativePlaytimeMs,
			cumulativeAudioPlaybackDurationMs = data.cumulativeAudioPlaybackDurationMs,
			cumulative100PercentAudibleTimeMs = data.cumulative100PercentAudibleTimeMs,
			maxAudioLevel = data.maxAudioLevel,
			audioOnAtEvent = data.audioOnAtEvent,
			cumulativeInGridViewDurationMs = data.cumulativeInGridViewDurationMs,
			cumulativeFullScreenViewDurationMs = data.cumulativeFullScreenViewDurationMs
		}
	})
end

function SponsoredAdViewabilityTelemetry.logSponsoredAdUnload(p, data, unloadReason: string)
	local geometryFields = buildGeometryFields(data.geometry)
	local customFields = {
		encryptedAdTrackingData = p.encryptedAdTrackingData,
		tileType = p.tileType,
		adWidth = geometryFields.adWidth,
		adHeight = geometryFields.adHeight,
		viewportWidth = geometryFields.viewportWidth,
		viewportHeight = geometryFields.viewportHeight,
		viewabilitySessionStartTimestampMs = data.viewabilitySessionStartTimestampMs,
		cumulative30PercentInViewDurationMs = data.cumulative30PercentInViewDurationMs,
		cumulative50PercentInViewDurationMs = data.cumulative50PercentInViewDurationMs,
		cumulative100PercentInViewDurationMs = data.cumulative100PercentInViewDurationMs,
		maxContinuous30PercentInViewDurationMs = data.maxContinuous30PercentInViewDurationMs,
		maxContinuous50PercentInViewDurationMs = data.maxContinuous50PercentInViewDurationMs,
		maxContinuous100PercentInViewDurationMs = data.maxContinuous100PercentInViewDurationMs,
		dwellDurationMs = data.dwellDurationMs,
		averagePercentSeen = data.averagePercentSeen,
		minPercentSeen = data.minPercentSeen,
		maxPercentSeen = data.maxPercentSeen,
		averageOnScreenRealEstate = data.averageOnScreenRealEstate,
		viewabilitySessionEndTimestampMs = data.viewabilitySessionEndTimestampMs,
		unloadReason = unloadReason
	}

	customFields.isFullScreen = data.isFullScreen
	customFields.videoProgress = data.videoProgress
	customFields.videoLengthMs = data.videoLengthMs
	customFields.videoCumulativePlaytimeMs = data.videoCumulativePlaytimeMs
	customFields.cumulativeAudioPlaybackDurationMs = data.cumulativeAudioPlaybackDurationMs
	customFields.cumulative100PercentAudibleTimeMs = data.cumulative100PercentAudibleTimeMs
	customFields.maxAudioLevel = data.maxAudioLevel
	customFields.audioOnAtEvent = data.audioOnAtEvent
	customFields.cumulativeInGridViewDurationMs = data.cumulativeInGridViewDurationMs
	customFields.cumulativeFullScreenViewDurationMs = data.cumulativeFullScreenViewDurationMs

	TelemetryService:LogEvent(v3, {
		standardizedFields = standardizedFields,
		customFields = customFields
	})
end

return SponsoredAdViewabilityTelemetry
