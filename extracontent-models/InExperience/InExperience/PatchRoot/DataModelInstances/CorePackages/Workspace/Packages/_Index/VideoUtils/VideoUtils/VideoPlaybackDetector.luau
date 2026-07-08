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
local VideoViewportPlaybackDetector = require(VideoUtils.VideoViewportPlaybackDetector)

require(VideoUtils.ViewportVideoAutoplayController)

local FFlagLuaAppEdpMediaGalleryVideoPreview = require(VideoUtilsParent.SharedFlags).FFlagLuaAppEdpMediaGalleryVideoPreview
local FFlagLuaAppHomeTouchAutoplay = require(VideoUtilsParent.SharedFlags).FFlagLuaAppHomeTouchAutoplay

local function VideoPlaybackDetector(t1: {[any]: any}) -- line: 46
	-- upvalues: VideoPlaybackCoordinator (copy), React (copy), FFlagLuaAppEdpMediaGalleryVideoPreview (copy), useLastInput (copy), FFlagLuaAppHomeTouchAutoplay (copy), AppLifecycleObserverService (copy), VideoEndReason (copy), ExperienceService (copy), VideoHoverPlaybackDetector (copy), Responsive (copy), VideoViewportPlaybackDetector (copy)
	local v16 = t1.videoPlaybackCoordinator or VideoPlaybackCoordinator.default
	local v17, v18 = React.useState(false)
	local v19 = if not FFlagLuaAppEdpMediaGalleryVideoPreview then useLastInput() else nil
	local v20 = React.useCallback(function(b1: boolean) -- line: 55
		-- upvalues: t1 (copy), v16 (copy)
		if t1.onPlaybackCandidate then
			t1.onPlaybackCandidate()
		end

		if t1.isVideoEligible then
			v16:requestPlayback(t1.videoKey, b1, t1.videoDwellTimeInSec, t1.itemIndex, t1.videoAnalytics)

			return
		end

		if t1.onVideoIneligible then
			t1.onVideoIneligible(v16.currentPlaybackSessionId)
		end
	end, {
		t1.videoKey,
		t1.itemIndex,
		t1.videoAnalytics,
		t1.isVideoEligible,
		t1.onVideoIneligible,
		t1.onPlaybackCandidate,
		t1.videoDwellTimeInSec,
		v16
	})
	local v21 = React.useCallback(function(s1: string) -- line: 85
		-- upvalues: v16 (copy), t1 (copy)
		v16:cancelPlayback(t1.videoKey, s1, t1.itemIndex, t1.videoAnalytics)
	end, {
		t1.videoKey,
		t1.itemIndex,
		t1.videoAnalytics,
		v16
	})

	React.useEffect(function() -- line: 97
		-- upvalues: t1 (copy), v17 (copy), v18 (copy), v16 (copy)
		local function checkAndUpdateState(s2: string?) -- line: 98
			-- upvalues: t1 (copy), v17 (copy), v18 (copy)
			local v32 = s2 == t1.videoKey

			if v32 ~= v17 then
				t1.onPlaybackChange(v32)
				v18(v32)
			end
		end

		local v25 = v16.playingVideoKey == t1.videoKey

		if v25 ~= v17 then
			t1.onPlaybackChange(v25)
			v18(v25)
		end

		local u26 = v16.changed:connect(function(p1) -- line: 109
			-- upvalues: t1 (copy), v17 (copy), v18 (copy)
			local v34 = p1 == t1.videoKey

			if v34 ~= v17 then
				t1.onPlaybackChange(v34)
				v18(v34)
			end
		end)

		return function() -- line: 113
			-- upvalues: u26 (ref)
			if u26 ~= nil then
				u26:disconnect()
				u26 = nil
			end
		end
	end, {
		t1.videoKey,
		t1.onPlaybackChange,
		v16,
		v17
	})
	React.useEffect(function() -- line: 123
		-- upvalues: FFlagLuaAppHomeTouchAutoplay (copy), t1 (copy), AppLifecycleObserverService (copy), VideoEndReason (copy), v21 (copy), ExperienceService (copy)
		local viewportVideoAutoplayController = nil
		local current = nil

		if FFlagLuaAppHomeTouchAutoplay then
			viewportVideoAutoplayController = t1.viewportVideoAutoplayController
			current = t1.itemFrameRef.current
		end

		local connection = AppLifecycleObserverService.OnHide:Connect(function() -- line: 132
			-- upvalues: FFlagLuaAppHomeTouchAutoplay (copy), viewportVideoAutoplayController (ref), VideoEndReason (copy), v21 (copy)
			if FFlagLuaAppHomeTouchAutoplay and viewportVideoAutoplayController then
				viewportVideoAutoplayController:reset(VideoEndReason.AppBackgrounded)

				return
			end

			v21(VideoEndReason.AppBackgrounded)
		end)
		local u30 = ExperienceService:RegisterForExperienceJoin(function() -- line: 142
			-- upvalues: FFlagLuaAppHomeTouchAutoplay (copy), viewportVideoAutoplayController (ref), VideoEndReason (copy), v21 (copy)
			if FFlagLuaAppHomeTouchAutoplay and viewportVideoAutoplayController then
				viewportVideoAutoplayController:reset(VideoEndReason.ExperienceLaunched)

				return
			end

			v21(VideoEndReason.ExperienceLaunched)
		end)

		return function() -- line: 151
			-- upvalues: FFlagLuaAppHomeTouchAutoplay (copy), viewportVideoAutoplayController (ref), current (ref), VideoEndReason (copy), v21 (copy), u30 (ref), connection (ref)
			if FFlagLuaAppHomeTouchAutoplay and (viewportVideoAutoplayController and current) then
				viewportVideoAutoplayController:resetIfActiveInstance(current, VideoEndReason.Unmounted)
			else
				v21(VideoEndReason.Unmounted)
			end

			if u30 then
				u30:Disconnect()
				u30 = nil
			end

			if connection then
				connection:Disconnect()
				connection = nil
			end
		end
	end, {
		v21,
		if not FFlagLuaAppHomeTouchAutoplay then nil else t1.viewportVideoAutoplayController,
		if not FFlagLuaAppHomeTouchAutoplay then nil else t1.itemFrameRef
	})

	if t1.isHoverSupported then
		return React.createElement(VideoHoverPlaybackDetector, {
			videoPlaybackCoordinator = v16,
			requestVideoPlayback = v20,
			cancelVideoPlayback = v21,
			isHovered = t1.isHovered
		})
	end

	if FFlagLuaAppEdpMediaGalleryVideoPreview and t1.autoplay or v19 == Responsive.Input.Touch then
		return React.createElement(VideoViewportPlaybackDetector, {
			videoPlaybackCoordinator = v16,
			requestVideoPlayback = v20,
			cancelVideoPlayback = v21,
			itemFrameRef = t1.itemFrameRef,
			isItemOccluded = t1.isItemOccluded,
			videoVisiblePercent = t1.videoVisiblePercent,
			viewportVideoAutoplayController = if not FFlagLuaAppHomeTouchAutoplay then nil else t1.viewportVideoAutoplayController
		})
	end

	return nil
end

return VideoPlaybackDetector
