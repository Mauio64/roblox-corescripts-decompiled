local ExperienceService = game:GetService("ExperienceService")
local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
local VideoUtils = script:FindFirstAncestor("VideoUtils")
local VideoUtilsParent = VideoUtils.Parent

require(VideoUtilsParent.AppCommonLib)

local React = require(VideoUtilsParent.React)
local Responsive = require(VideoUtilsParent.Responsive)
local useLastInput = Responsive.useLastInput

require(VideoUtils.Analytics.VideoAnalyticsTypes)

local VideoEndReason = require(VideoUtils.Analytics.Enums).VideoEndReason
local VideoPlaybackCoordinator = require(VideoUtils.VideoPlaybackCoordinator)
local VideoHoverPlaybackDetector = require(VideoUtils.VideoHoverPlaybackDetector)
local VideoPlaybackDetectionMethod = require(VideoUtils.VideoPlaybackDetectionMethod)
local VideoSelectionPlaybackDetector = require(VideoUtils.VideoSelectionPlaybackDetector)
local VideoViewportPlaybackDetector = require(VideoUtils.VideoViewportPlaybackDetector)

require(VideoUtils.ViewportVideoAutoplayController)

local FFlagLuaAppEdpMediaGalleryVideoPreview = require(VideoUtilsParent.SharedFlags).FFlagLuaAppEdpMediaGalleryVideoPreview
local FFlagLuaAppGameTileSelectionVideoPlayback = require(VideoUtilsParent.SharedFlags).FFlagLuaAppGameTileSelectionVideoPlayback

local function VideoPlaybackDetector(t1: {[any]: any}) -- line: 52
	-- upvalues: VideoPlaybackCoordinator (copy), React (copy), FFlagLuaAppEdpMediaGalleryVideoPreview (copy), FFlagLuaAppGameTileSelectionVideoPlayback (copy), useLastInput (copy), AppLifecycleObserverService (copy), VideoEndReason (copy), ExperienceService (copy), VideoPlaybackDetectionMethod (copy), VideoHoverPlaybackDetector (copy), VideoViewportPlaybackDetector (copy), VideoSelectionPlaybackDetector (copy), Responsive (copy)
	local v18 = t1.videoPlaybackCoordinator or VideoPlaybackCoordinator.default
	local v19, v20 = React.useState(false)
	local v21 = if not FFlagLuaAppEdpMediaGalleryVideoPreview and not FFlagLuaAppGameTileSelectionVideoPlayback then useLastInput() else nil
	local v22 = React.useCallback(function(b1: boolean) -- line: 63
		-- upvalues: t1 (copy), v18 (copy)
		if t1.onPlaybackCandidate then
			t1.onPlaybackCandidate()
		end

		if t1.isVideoEligible then
			v18:requestPlayback(t1.videoKey, b1, t1.videoDwellTimeInSec, t1.itemIndex, t1.videoAnalytics)

			return
		end

		if t1.onVideoIneligible then
			t1.onVideoIneligible(v18.currentPlaybackSessionId)
		end
	end, {
		t1.videoKey,
		t1.itemIndex,
		t1.videoAnalytics,
		t1.isVideoEligible,
		t1.onVideoIneligible,
		t1.onPlaybackCandidate,
		t1.videoDwellTimeInSec,
		v18
	})
	local v23 = React.useCallback(function(s1: string) -- line: 93
		-- upvalues: v18 (copy), t1 (copy)
		v18:cancelPlayback(t1.videoKey, s1, t1.itemIndex, t1.videoAnalytics)
	end, {
		t1.videoKey,
		t1.itemIndex,
		t1.videoAnalytics,
		v18
	})

	React.useEffect(function() -- line: 105
		-- upvalues: t1 (copy), v19 (copy), v20 (copy), v18 (copy)
		local function checkAndUpdateState(s2: string?) -- line: 106
			-- upvalues: t1 (copy), v19 (copy), v20 (copy)
			local v34 = s2 == t1.videoKey

			if v34 ~= v19 then
				t1.onPlaybackChange(v34)
				v20(v34)
			end
		end

		local v27 = v18.playingVideoKey == t1.videoKey

		if v27 ~= v19 then
			t1.onPlaybackChange(v27)
			v20(v27)
		end

		local u28 = v18.changed:connect(function(p1) -- line: 117
			-- upvalues: t1 (copy), v19 (copy), v20 (copy)
			local v36 = p1 == t1.videoKey

			if v36 ~= v19 then
				t1.onPlaybackChange(v36)
				v20(v36)
			end
		end)

		return function() -- line: 121
			-- upvalues: u28 (ref)
			if u28 ~= nil then
				u28:disconnect()
				u28 = nil
			end
		end
	end, {
		t1.videoKey,
		t1.onPlaybackChange,
		v18,
		v19
	})
	React.useEffect(function() -- line: 131
		-- upvalues: t1 (copy), AppLifecycleObserverService (copy), VideoEndReason (copy), v23 (copy), ExperienceService (copy)
		local viewportVideoAutoplayController = t1.viewportVideoAutoplayController
		local current = t1.itemFrameRef.current
		local connection = AppLifecycleObserverService.OnHide:Connect(function() -- line: 136
			-- upvalues: viewportVideoAutoplayController (copy), VideoEndReason (copy), v23 (copy)
			if viewportVideoAutoplayController then
				viewportVideoAutoplayController:reset(VideoEndReason.AppBackgrounded)

				return
			end

			v23(VideoEndReason.AppBackgrounded)
		end)
		local u32 = ExperienceService:RegisterForExperienceJoin(function() -- line: 146
			-- upvalues: viewportVideoAutoplayController (copy), VideoEndReason (copy), v23 (copy)
			if viewportVideoAutoplayController then
				viewportVideoAutoplayController:reset(VideoEndReason.ExperienceLaunched)

				return
			end

			v23(VideoEndReason.ExperienceLaunched)
		end)

		return function() -- line: 155
			-- upvalues: viewportVideoAutoplayController (copy), current (copy), VideoEndReason (copy), v23 (copy), u32 (ref), connection (ref)
			if viewportVideoAutoplayController and current then
				viewportVideoAutoplayController:resetIfActiveInstance(current, VideoEndReason.Unmounted)
			else
				v23(VideoEndReason.Unmounted)
			end

			if u32 then
				u32:Disconnect()
				u32 = nil
			end

			if connection then
				connection:Disconnect()
				connection = nil
			end
		end
	end, {
		v23,
		t1.viewportVideoAutoplayController,
		t1.itemFrameRef
	})

	if FFlagLuaAppGameTileSelectionVideoPlayback then
		if t1.playbackDetectionMethod == VideoPlaybackDetectionMethod.Hover then
			return React.createElement(VideoHoverPlaybackDetector, {
				videoPlaybackCoordinator = v18,
				requestVideoPlayback = v22,
				cancelVideoPlayback = v23,
				isHovered = t1.isHovered
			})
		end

		if t1.playbackDetectionMethod == VideoPlaybackDetectionMethod.Viewport then
			return React.createElement(VideoViewportPlaybackDetector, {
				videoPlaybackCoordinator = v18,
				requestVideoPlayback = v22,
				cancelVideoPlayback = v23,
				itemFrameRef = t1.itemFrameRef,
				isItemOccluded = t1.isItemOccluded,
				videoVisiblePercent = t1.videoVisiblePercent,
				viewportVideoAutoplayController = t1.viewportVideoAutoplayController
			})
		end

		if t1.playbackDetectionMethod == VideoPlaybackDetectionMethod.Selection then
			return React.createElement(VideoSelectionPlaybackDetector, {
				requestVideoPlayback = v22,
				cancelVideoPlayback = v23,
				isSelected = t1.isSelected
			})
		end
	else
		if t1.isHoverSupported then
			return React.createElement(VideoHoverPlaybackDetector, {
				videoPlaybackCoordinator = v18,
				requestVideoPlayback = v22,
				cancelVideoPlayback = v23,
				isHovered = t1.isHovered
			})
		end

		if FFlagLuaAppEdpMediaGalleryVideoPreview and t1.autoplay or v21 == Responsive.Input.Touch then
			return React.createElement(VideoViewportPlaybackDetector, {
				videoPlaybackCoordinator = v18,
				requestVideoPlayback = v22,
				cancelVideoPlayback = v23,
				itemFrameRef = t1.itemFrameRef,
				isItemOccluded = t1.isItemOccluded,
				videoVisiblePercent = t1.videoVisiblePercent,
				viewportVideoAutoplayController = t1.viewportVideoAutoplayController
			})
		end
	end

	return nil
end

return VideoPlaybackDetector
