local Parent = script:FindFirstAncestor("MediaGallery").Parent
local React = require(Parent.React)
local LoggingProtocol = require(Parent.LoggingProtocol)
local DiscoveryAnalytics = require(Parent.DiscoveryAnalytics)
local discoveryVideoPlayEvent = DiscoveryAnalytics.Events.discoveryVideoPlayEvent
local discoveryVideoEndEvent = DiscoveryAnalytics.Events.discoveryVideoEndEvent
local VideoUtils = require(Parent.VideoUtils)
local VideoActions = VideoUtils.AnalyticsEnums.VideoActions
local VideoLogger = VideoUtils.VideoLogger
local reportWarning = DiscoveryAnalytics.Points.reportWarning

local function useMediaGalleryVideoAnalytics(s1: string, s2: string, t1: {[any]: any}?) -- line: 27
	-- upvalues: React (copy), reportWarning (copy), LoggingProtocol (copy), discoveryVideoPlayEvent (copy), VideoLogger (copy), VideoActions (copy), discoveryVideoEndEvent (copy)
	local v15 = React.useCallback(function(n1: number?, s3: string?) -- line: 28
		-- upvalues: t1 (copy), reportWarning (copy), LoggingProtocol (copy), discoveryVideoPlayEvent (copy), s1 (copy), s2 (copy)
		if not n1 or not t1 then
			return
		end

		local v21 = t1[n1]

		if not v21 then
			reportWarning(LoggingProtocol.default, "EventLogging", "reportVideoPlay requires a valid entry")

			return
		end

		if not v21.videoId then
			reportWarning(LoggingProtocol.default, "EventLogging", "reportVideoPlay requires a valid videoAssetId")
		end

		discoveryVideoPlayEvent("GameDetails", {
			videoAssetId = v21.videoId,
			videoPlaybackSessionId = s3 or "INVALID_SESSION_ID",
			universeId = s1,
			rootPlaceId = s2
		})
	end, {
		s1,
		s2,
		t1
	})
	local v16 = React.useCallback(function(n2: number?, s4: string?, _: number, n4: number) -- line: 52
		-- upvalues: t1 (copy), reportWarning (copy), LoggingProtocol (copy), VideoLogger (copy), VideoActions (copy), s1 (copy)
		if not n2 or not t1 then
			return
		end

		local v26 = t1[n2]

		if not v26 then
			reportWarning(LoggingProtocol.default, "EventLogging", "reportVideoLoad requires a valid entry")

			return
		end

		if not v26.videoId then
			reportWarning(LoggingProtocol.default, "EventLogging", "reportVideoLoad requires a valid videoAssetId")
		end

		VideoLogger.reportVideoAction(VideoActions.load, "GameDetails", {
			source = "MediaGallery",
			videoAssetId = v26.videoId,
			sourceId = s1,
			playbackSessionId = s4 or "INVALID_SESSION_ID"
		}, {
			loadTime = n4
		})
	end, {
		s1,
		t1
	})
	local v17 = React.useCallback(function(n5: number?, s5: string?, b1: boolean) -- line: 79
		-- upvalues: t1 (copy), VideoLogger (copy), VideoActions (copy), s1 (copy)
		if not n5 or not t1 then
			return
		end

		local v30 = t1[n5]

		if not v30 or not v30.videoId then
			return
		end

		VideoLogger.reportVideoAction(VideoActions.volume, "GameDetails", {
			source = "MediaGallery",
			videoAssetId = v30.videoId,
			sourceId = s1,
			playbackSessionId = s5 or "INVALID_SESSION_ID",
			volumeLevel = not b1 and 1 or 0
		})
	end, {
		s1,
		t1
	})
	local v18 = React.useCallback(function(n6: number?, s6: string, s7: string?, n7: number, s8: string?) -- line: 99
		-- upvalues: t1 (copy), reportWarning (copy), LoggingProtocol (copy), discoveryVideoEndEvent (copy), s1 (copy), s2 (copy)
		if not n6 or not t1 then
			return
		end

		local v36 = t1[n6]

		if not v36 then
			reportWarning(LoggingProtocol.default, "EventLogging", "reportVideoEnd requires a valid entry")

			return
		end

		if not v36.videoId then
			reportWarning(LoggingProtocol.default, "EventLogging", "reportVideoEnd requires a valid videoAssetId")
		end

		discoveryVideoEndEvent("GameDetails", {
			videoAssetId = v36.videoId,
			videoPlaybackSessionId = s7 or "INVALID_SESSION_ID",
			endReason = s6,
			playbackTime = n7,
			universeId = s1,
			rootPlaceId = s2,
			targetUniverseId = s8
		})
	end, {
		s1,
		s2,
		t1
	})

	return (React.useMemo(function() -- line: 133
		-- upvalues: v15 (copy), v16 (copy), v17 (copy), v18 (copy)
		return {
			reportVideoPlay = v15,
			reportVideoLoad = v16,
			reportVideoMute = v17,
			reportVideoEnd = v18
		}
	end, {
		v15,
		v16,
		v17,
		v18
	}))
end

return useMediaGalleryVideoAnalytics
