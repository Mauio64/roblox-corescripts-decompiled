local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/React")

local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/LoggingProtocol")

local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/DiscoveryAnalytics")
local discoveryVideoPlayEvent = DiscoveryAnalytics.Events.discoveryVideoPlayEvent
local discoveryVideoEndEvent = DiscoveryAnalytics.Events.discoveryVideoEndEvent

local VideoUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/VideoUtils")
local videoActions = VideoUtils.AnalyticsEnums.VideoActions
local videoLogger = VideoUtils.VideoLogger

local reportWarning = DiscoveryAnalytics.Points.reportWarning

local fFlagLuaAppDiscoveryMomentVideoTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/SharedFlags").FFlagLuaAppDiscoveryMomentVideoTelemetry

local function useMediaGalleryVideoAnalytics(p2, p3, p4)
	local v5 = React.useCallback(function(p5, value)
		if not (p5 and p4) then
			return
		end

		local v6 = p4[p5]

		if not v6 then
			reportWarning(LoggingProtocol.default, "EventLogging", "reportVideoPlay requires a valid entry")
			return
		end

		if not v6.videoId then
			reportWarning(LoggingProtocol.default, "EventLogging", "reportVideoPlay requires a valid videoAssetId")
		end

		local v9 = {
			videoAssetId = v6.videoId,
			videoPlaybackSessionId = value or "INVALID_SESSION_ID",
			universeId = p2,
			rootPlaceId = p3,
			isMoment = 0
		}

		local v10 = if fFlagLuaAppDiscoveryMomentVideoTelemetry then v6.isMoment == true else nil
		v9.isMoment = v10
		discoveryVideoPlayEvent("GameDetails", v9)
	end, { p2, p3, p4 })

	local v6 = React.useCallback(function(p5, value, p6, p7)
		if not (p5 and p4) then
			return
		end

		local v7 = p4[p5]

		if not v7 then
			reportWarning(LoggingProtocol.default, "EventLogging", "reportVideoLoad requires a valid entry")
			return
		end

		if not v7.videoId then
			reportWarning(LoggingProtocol.default, "EventLogging", "reportVideoLoad requires a valid videoAssetId")
		end

		videoLogger.reportVideoAction(videoActions.load, "GameDetails", {
			videoAssetId = v7.videoId,
			source = "MediaGallery",
			sourceId = p2,
			playbackSessionId = value or "INVALID_SESSION_ID"
		}, { loadTime = p7 })
	end, { p2, p4 })

	local v7 = React.useCallback(function(p5, value, p6)
		if not (p5 and p4) then
			return
		end

		local v8 = p4[p5]

		if v8 and v8.videoId then
			videoLogger.reportVideoAction(videoActions.volume, "GameDetails", {
				videoAssetId = v8.videoId,
				source = "MediaGallery",
				sourceId = p2,
				playbackSessionId = value or "INVALID_SESSION_ID",
				volumeLevel = p6 and 0 or 1
			})
		end
	end, { p2, p4 })

	local v8 = React.useCallback(function(p5, p6, value, p7, p8)
		if not (p5 and p4) then
			return
		end

		local v9 = p4[p5]

		if not v9 then
			reportWarning(LoggingProtocol.default, "EventLogging", "reportVideoEnd requires a valid entry")
			return
		end

		if not v9.videoId then
			reportWarning(LoggingProtocol.default, "EventLogging", "reportVideoEnd requires a valid videoAssetId")
		end

		local v12 = {
			videoAssetId = v9.videoId,
			videoPlaybackSessionId = value or "INVALID_SESSION_ID",
			endReason = p6,
			playbackTime = p7,
			universeId = p2,
			rootPlaceId = p3,
			targetUniverseId = p8,
			isMoment = 0
		}

		local v13 = if fFlagLuaAppDiscoveryMomentVideoTelemetry then v9.isMoment == true else nil
		v12.isMoment = v13
		discoveryVideoEndEvent("GameDetails", v12)
	end, { p2, p3, p4 })

	return (React.useMemo(function()
		return {
			reportVideoPlay = v5,
			reportVideoLoad = v6,
			reportVideoMute = v7,
			reportVideoEnd = v8
		}
	end, { v5, v6, v7, v8 }))
end

return useMediaGalleryVideoAnalytics
