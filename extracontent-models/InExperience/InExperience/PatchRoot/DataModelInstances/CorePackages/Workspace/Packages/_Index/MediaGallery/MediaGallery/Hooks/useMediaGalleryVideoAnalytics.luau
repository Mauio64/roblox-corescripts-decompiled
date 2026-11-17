local parent = script:FindFirstAncestor("MediaGallery").Parent

local React = require(parent.React)

local LoggingProtocol = require(parent.LoggingProtocol)

local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local discoveryVideoPlayEvent = DiscoveryAnalytics.Events.discoveryVideoPlayEvent
local discoveryVideoEndEvent = DiscoveryAnalytics.Events.discoveryVideoEndEvent

local VideoUtils = require(parent.VideoUtils)
local VideoActions = VideoUtils.AnalyticsEnums.VideoActions
local VideoLogger = VideoUtils.VideoLogger

local reportWarning = DiscoveryAnalytics.Points.reportWarning

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDiscoveryMomentVideoTelemetry = SharedFlags.FFlagLuaAppDiscoveryMomentVideoTelemetry

local function useMediaGalleryVideoAnalytics(p: string, rootPlaceId: string?, p2)
	local reportVideoPlay = React.useCallback(function(p3: number?, value: string?)
		if not (p3 and p2) then
			return
		end

		local v = p2[p3]

		if not v then
			reportWarning(LoggingProtocol.default, "EventLogging", "reportVideoPlay requires a valid entry")
			return
		end

		if not v.videoId then
			reportWarning(LoggingProtocol.default, "EventLogging", "reportVideoPlay requires a valid videoAssetId")
		end

		local v2 = {
			videoAssetId = v.videoId,
			videoPlaybackSessionId = value or "INVALID_SESSION_ID",
			universeId = p,
			rootPlaceId = rootPlaceId,
			isMoment = 0
		}
		local isMoment

		if FFlagLuaAppDiscoveryMomentVideoTelemetry then
			isMoment = v.isMoment == true
		end

		v2.isMoment = isMoment
		discoveryVideoPlayEvent("GameDetails", v2)
	end, { p, rootPlaceId, p2 })

	local reportVideoLoad = React.useCallback(function(p3: number?, value: string?, _: number, loadTime: number)
		if not (p3 and p2) then
			return
		end

		local v = p2[p3]

		if not v then
			reportWarning(LoggingProtocol.default, "EventLogging", "reportVideoLoad requires a valid entry")
			return
		end

		if not v.videoId then
			reportWarning(LoggingProtocol.default, "EventLogging", "reportVideoLoad requires a valid videoAssetId")
		end

		VideoLogger.reportVideoAction(VideoActions.load, "GameDetails", {
			videoAssetId = v.videoId,
			source = "MediaGallery",
			sourceId = p,
			playbackSessionId = value or "INVALID_SESSION_ID"
		}, { loadTime = loadTime })
	end, { p, p2 })

	local reportVideoMute = React.useCallback(function(p3: number?, value: string?, flag: boolean)
		if not (p3 and p2) then
			return
		end

		local v = p2[p3]

		if v and v.videoId then
			VideoLogger.reportVideoAction(VideoActions.volume, "GameDetails", {
				videoAssetId = v.videoId,
				source = "MediaGallery",
				sourceId = p,
				playbackSessionId = value or "INVALID_SESSION_ID",
				volumeLevel = flag and 0 or 1
			})
		end
	end, { p, p2 })

	local reportVideoEnd = React.useCallback(
		function(p3: number?, endReason: string, value: string?, playbackTime: number, targetUniverseId: string?)
			if not (p3 and p2) then
				return
			end

			local v = p2[p3]

			if not v then
				reportWarning(LoggingProtocol.default, "EventLogging", "reportVideoEnd requires a valid entry")
				return
			end

			if not v.videoId then
				reportWarning(LoggingProtocol.default, "EventLogging", "reportVideoEnd requires a valid videoAssetId")
			end

			local v2 = {
				videoAssetId = v.videoId,
				videoPlaybackSessionId = value or "INVALID_SESSION_ID",
				endReason = endReason,
				playbackTime = playbackTime,
				universeId = p,
				rootPlaceId = rootPlaceId,
				targetUniverseId = targetUniverseId,
				isMoment = 0
			}
			local isMoment

			if FFlagLuaAppDiscoveryMomentVideoTelemetry then
				isMoment = v.isMoment == true
			end

			v2.isMoment = isMoment
			discoveryVideoEndEvent("GameDetails", v2)
		end,
		{ p, rootPlaceId, p2 }
	)

	return (React.useMemo(function()
		return {
			reportVideoPlay = reportVideoPlay,
			reportVideoLoad = reportVideoLoad,
			reportVideoMute = reportVideoMute,
			reportVideoEnd = reportVideoEnd
		}
	end, { reportVideoPlay, reportVideoLoad, reportVideoMute, reportVideoEnd }))
end

return useMediaGalleryVideoAnalytics
