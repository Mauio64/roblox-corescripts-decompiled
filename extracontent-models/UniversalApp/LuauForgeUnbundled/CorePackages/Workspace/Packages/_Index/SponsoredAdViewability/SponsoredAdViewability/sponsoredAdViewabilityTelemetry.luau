local TelemetryService = game:GetService("TelemetryService")

require("@game/CorePackages/Workspace/Packages/_Index/SponsoredAdViewability/SponsoredAdViewability/sponsoredAdViewabilityState")
require("@game/CorePackages/Workspace/Packages/_Index/SponsoredAdViewability/SponsoredAdViewability/sponsoredAdViewabilityTypes")

local v5 = { "addSessionInfo", "addSessionId", "addOSInfo" }

local v6 = {
	eventName = "SponsoredAdLoad",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt(
		"LuaAppSponsoredAdLoadTelemetryThrottlingHundredthsPercent",
		0
	),
	lastUpdated = { 26, 6, 11 },
	description = "\t\t\tFires once per served sponsored ad when its tile begins to render on a surface.\n\t\t"
}

local v7 = {
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

local v8 = {
	eventName = "SponsoredAdUnload",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt(
		"LuaAppSponsoredAdUnloadTelemetryThrottlingHundredthsPercent",
		0
	),
	lastUpdated = { 26, 6, 25 },
	description = [[
Fires once per served sponsored ad when its viewability session reaches a terminal
boundary, carrying the session's dwell and in-view duration summary.
		]]
}

local v9 = {
	eventName = "SponsoredAdVideoProgress",
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt(
		"LuaAppSponsoredAdVideoProgressTelemetryThrottlingHundredthsPercent",
		0
	),
	lastUpdated = { 26, 7, 21 },
	description = [[
	Fires once for each 0 / 25 / 50 / 75 / 100 video-progress milestone reached
	within a served sponsored ad session.
]]
}

local function buildGeometryFields(p2)
	local adSize = p2.adSize
	local viewportBounds = p2.viewportBounds

	local v10 = if adSize.X > 0 then adSize.X else nil
	local v11 = if adSize.Y > 0 then adSize.Y else nil
	return {
		adWidth = v10,
		adHeight = v11,
		viewportWidth = viewportBounds.max.X - viewportBounds.min.X,
		viewportHeight = viewportBounds.max.Y - viewportBounds.min.Y
	}
end

return {
	logSponsoredAdLoad = function(data, p2, p3, p4)
		local geometryFields = buildGeometryFields(p2)
		local v10 = {
			encryptedAdTrackingData = data.encryptedAdTrackingData,
			tileType = data.tileType,
			viewabilitySessionStartTimestampMs = p3,
			adWidth = geometryFields.adWidth,
			adHeight = geometryFields.adHeight,
			viewportWidth = geometryFields.viewportWidth,
			viewportHeight = geometryFields.viewportHeight
		}

		if data.mediaType == "video" then
			v10.isFullScreen = data.isFullscreen == true
		end

		if p4 ~= nil then
			v10.videoLengthMs = p4.videoLengthMs
		end

		TelemetryService:LogEvent(v6, { standardizedFields = v5, customFields = v10 })
	end,
	logSponsoredAdViewableImpression = function(p2, data)
		local geometryFields = buildGeometryFields(data.geometry)
		local v10 = {
			encryptedAdTrackingData = p2.encryptedAdTrackingData,
			tileType = p2.tileType,
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

		v10.isFullScreen = data.isFullScreen
		v10.videoLengthMs = data.videoLengthMs
		v10.maxAudioLevel = data.maxAudioLevel
		v10.cumulativeInGridViewDurationMs = data.cumulativeInGridViewDurationMs
		v10.cumulativeFullScreenViewDurationMs = data.cumulativeFullScreenViewDurationMs

		TelemetryService:LogEvent(v7, { standardizedFields = v5, customFields = v10 })
	end,
	logSponsoredAdVideoProgress = function(p2, data)
		local geometryFields = buildGeometryFields(data.geometry)

		TelemetryService:LogEvent(v9, {
			standardizedFields = v5,
			customFields = {
				encryptedAdTrackingData = p2.encryptedAdTrackingData,
				tileType = p2.tileType,
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
	end,
	logSponsoredAdUnload = function(p2, data, p3)
		local geometryFields = buildGeometryFields(data.geometry)
		local v10 = {
			encryptedAdTrackingData = p2.encryptedAdTrackingData,
			tileType = p2.tileType,
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
			unloadReason = p3
		}

		v10.isFullScreen = data.isFullScreen
		v10.videoProgress = data.videoProgress
		v10.videoLengthMs = data.videoLengthMs
		v10.videoCumulativePlaytimeMs = data.videoCumulativePlaytimeMs
		v10.cumulativeAudioPlaybackDurationMs = data.cumulativeAudioPlaybackDurationMs
		v10.cumulative100PercentAudibleTimeMs = data.cumulative100PercentAudibleTimeMs
		v10.maxAudioLevel = data.maxAudioLevel
		v10.audioOnAtEvent = data.audioOnAtEvent
		v10.cumulativeInGridViewDurationMs = data.cumulativeInGridViewDurationMs
		v10.cumulativeFullScreenViewDurationMs = data.cumulativeFullScreenViewDurationMs

		TelemetryService:LogEvent(v8, { standardizedFields = v5, customFields = v10 })
	end
}
