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
local FFlagLuaAppHomeTouchAutoplay = require(VideoUtilsParent.SharedFlags).FFlagLuaAppHomeTouchAutoplay
local FFlagLuaAppGameTileSelectionVideoPlayback = require(VideoUtilsParent.SharedFlags).FFlagLuaAppGameTileSelectionVideoPlayback

local function VideoPlaybackDetector(t1: {[any]: any}) -- line: 53
	-- upvalues: VideoPlaybackCoordinator (copy), React (copy), FFlagLuaAppEdpMediaGalleryVideoPreview (copy), FFlagLuaAppGameTileSelectionVideoPlayback (copy), useLastInput (copy), FFlagLuaAppHomeTouchAutoplay (copy), AppLifecycleObserverService (copy), VideoEndReason (copy), ExperienceService (copy), VideoPlaybackDetectionMethod (copy), VideoHoverPlaybackDetector (copy), VideoViewportPlaybackDetector (copy), VideoSelectionPlaybackDetector (copy), Responsive (copy)
	local v19 = t1.videoPlaybackCoordinator or VideoPlaybackCoordinator.default
	local v20, v21 = React.useState(false)
	local v22 = if not FFlagLuaAppEdpMediaGalleryVideoPreview and not FFlagLuaAppGameTileSelectionVideoPlayback then useLastInput() else nil
	local v23 = React.useCallback(function(b1: boolean) -- line: 64
		-- upvalues: t1 (copy), v19 (copy)
		if t1.onPlaybackCandidate then
			t1.onPlaybackCandidate()
		end

		if t1.isVideoEligible then
			v19:requestPlayback(t1.videoKey, b1, t1.videoDwellTimeInSec, t1.itemIndex, t1.videoAnalytics)

			return
		end

		if t1.onVideoIneligible then
			t1.onVideoIneligible(v19.currentPlaybackSessionId)
		end
	end, {
		t1.videoKey,
		t1.itemIndex,
		t1.videoAnalytics,
		t1.isVideoEligible,
		t1.onVideoIneligible,
		t1.onPlaybackCandidate,
		t1.videoDwellTimeInSec,
		v19
	})
	local v24 = React.useCallback(function(s1: string) -- line: 94
		-- upvalues: v19 (copy), t1 (copy)
		v19:cancelPlayback(t1.videoKey, s1, t1.itemIndex, t1.videoAnalytics)
	end, {
		t1.videoKey,
		t1.itemIndex,
		t1.videoAnalytics,
		v19
	})

	React.useEffect(function() -- line: 106
		-- upvalues: t1 (copy), v20 (copy), v21 (copy), v19 (copy)
		local function checkAndUpdateState(s2: string?) -- line: 107
			-- upvalues: t1 (copy), v20 (copy), v21 (copy)
			local v35 = s2 == t1.videoKey

			if v35 ~= v20 then
				t1.onPlaybackChange(v35)
				v21(v35)
			end
		end

		local v28 = v19.playingVideoKey == t1.videoKey

		if v28 ~= v20 then
			t1.onPlaybackChange(v28)
			v21(v28)
		end

		local u29 = v19.changed:connect(function(p1) -- line: 118
			-- upvalues: t1 (copy), v20 (copy), v21 (copy)
			local v37 = p1 == t1.videoKey

			if v37 ~= v20 then
				t1.onPlaybackChange(v37)
				v21(v37)
			end
		end)

		return function() -- line: 122
			-- upvalues: u29 (ref)
			if u29 ~= nil then
				u29:disconnect()
				u29 = nil
			end
		end
	end, {
		t1.videoKey,
		t1.onPlaybackChange,
		v19,
		v20
	})
	React.useEffect(function() -- line: 132
		-- upvalues: FFlagLuaAppHomeTouchAutoplay (copy), t1 (copy), AppLifecycleObserverService (copy), VideoEndReason (copy), v24 (copy), ExperienceService (copy)
		local viewportVideoAutoplayController = nil
		local current = nil

		if FFlagLuaAppHomeTouchAutoplay then
			viewportVideoAutoplayController = t1.viewportVideoAutoplayController
			current = t1.itemFrameRef.current
		end

		local connection = AppLifecycleObserverService.OnHide:Connect(function() -- line: 141
			-- upvalues: FFlagLuaAppHomeTouchAutoplay (copy), viewportVideoAutoplayController (ref), VideoEndReason (copy), v24 (copy)
			if FFlagLuaAppHomeTouchAutoplay and viewportVideoAutoplayController then
				viewportVideoAutoplayController:reset(VideoEndReason.AppBackgrounded)

				return
			end

			v24(VideoEndReason.AppBackgrounded)
		end)
		local u33 = ExperienceService:RegisterForExperienceJoin(function() -- line: 151
			-- upvalues: FFlagLuaAppHomeTouchAutoplay (copy), viewportVideoAutoplayController (ref), VideoEndReason (copy), v24 (copy)
			if FFlagLuaAppHomeTouchAutoplay and viewportVideoAutoplayController then
				viewportVideoAutoplayController:reset(VideoEndReason.ExperienceLaunched)

				return
			end

			v24(VideoEndReason.ExperienceLaunched)
		end)

		return function() -- line: 160
			-- upvalues: FFlagLuaAppHomeTouchAutoplay (copy), viewportVideoAutoplayController (ref), current (ref), VideoEndReason (copy), v24 (copy), u33 (ref), connection (ref)
			if FFlagLuaAppHomeTouchAutoplay and (viewportVideoAutoplayController and current) then
				viewportVideoAutoplayController:resetIfActiveInstance(current, VideoEndReason.Unmounted)
			else
				v24(VideoEndReason.Unmounted)
			end

			if u33 then
				u33:Disconnect()
				u33 = nil
			end

			if connection then
				connection:Disconnect()
				connection = nil
			end
		end
	end, {
		v24,
		if not FFlagLuaAppHomeTouchAutoplay then nil else t1.viewportVideoAutoplayController,
		if not FFlagLuaAppHomeTouchAutoplay then nil else t1.itemFrameRef
	})

	if FFlagLuaAppGameTileSelectionVideoPlayback then
		if t1.playbackDetectionMethod == VideoPlaybackDetectionMethod.Hover then
			return React.createElement(VideoHoverPlaybackDetector, {
				videoPlaybackCoordinator = v19,
				requestVideoPlayback = v23,
				cancelVideoPlayback = v24,
				isHovered = t1.isHovered
			})
		end

		if t1.playbackDetectionMethod == VideoPlaybackDetectionMethod.Viewport then
			return React.createElement(VideoViewportPlaybackDetector, {
				videoPlaybackCoordinator = v19,
				requestVideoPlayback = v23,
				cancelVideoPlayback = v24,
				itemFrameRef = t1.itemFrameRef,
				isItemOccluded = t1.isItemOccluded,
				videoVisiblePercent = t1.videoVisiblePercent,
				viewportVideoAutoplayController = if not FFlagLuaAppHomeTouchAutoplay then nil else t1.viewportVideoAutoplayController
			})
		end

		if t1.playbackDetectionMethod == VideoPlaybackDetectionMethod.Selection then
			return React.createElement(VideoSelectionPlaybackDetector, {
				requestVideoPlayback = v23,
				cancelVideoPlayback = v24,
				isSelected = t1.isSelected
			})
		end
	else
		if t1.isHoverSupported then
			return React.createElement(VideoHoverPlaybackDetector, {
				videoPlaybackCoordinator = v19,
				requestVideoPlayback = v23,
				cancelVideoPlayback = v24,
				isHovered = t1.isHovered
			})
		end

		if FFlagLuaAppEdpMediaGalleryVideoPreview and t1.autoplay or v22 == Responsive.Input.Touch then
			return React.createElement(VideoViewportPlaybackDetector, {
				videoPlaybackCoordinator = v19,
				requestVideoPlayback = v23,
				cancelVideoPlayback = v24,
				itemFrameRef = t1.itemFrameRef,
				isItemOccluded = t1.isItemOccluded,
				videoVisiblePercent = t1.videoVisiblePercent,
				viewportVideoAutoplayController = if not FFlagLuaAppHomeTouchAutoplay then nil else t1.viewportVideoAutoplayController
			})
		end
	end

	return nil
end

return VideoPlaybackDetector
