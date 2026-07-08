local MediaGallery = script:FindFirstAncestor("MediaGallery")
local MediaGalleryParent = MediaGallery.Parent
local React = require(MediaGalleryParent.React)

require(MediaGalleryParent.AppCommonLib)

local useTokens = require(MediaGalleryParent.Foundation).Hooks.useTokens
local VideoUtils = require(MediaGalleryParent.VideoUtils)
local VideoPlaybackCoordinator = VideoUtils.VideoPlaybackCoordinator
local VideoPlaybackDetector = VideoUtils.VideoPlaybackDetector
local VideoPlayer = VideoUtils.VideoPlayer
local FFlagSduiExperienceDetailsSupport = require(MediaGalleryParent.SharedFlags).FFlagSduiExperienceDetailsSupport
local getImageUri = require(MediaGallery.getImageUri)
local MediaGalleryConstants = require(MediaGallery.MediaGalleryConstants)

local function MediaGalleryVideoItem(t1: {[any]: any}) -- line: 61
	-- upvalues: useTokens (copy), getImageUri (copy), VideoPlaybackCoordinator (copy), MediaGalleryConstants (copy), React (copy), FFlagSduiExperienceDetailsSupport (copy), VideoPlayer (copy), VideoPlaybackDetector (copy)
	local v14 = useTokens()
	local v15 = `rbxassetid://{ t1.videoId }`
	local v16 = getImageUri(t1.thumbnail or "")
	local v17 = t1.videoPlaybackCoordinator or VideoPlaybackCoordinator.default
	local videoAnalytics = t1.videoAnalytics
	local v19 = t1.currentIndex == nil or t1.itemIndex == t1.currentIndex
	local setIsVideoActive = t1.setIsVideoActive
	local v21 = t1.cornerRadius or v14.Radius.Medium
	local isFullscreen = t1.isFullscreen
	local v23 = (t1.videoDwellTimeHundredthsSec or MediaGalleryConstants.VIDEO_DWELL_TIME_HUNDREDTHS_SEC) / 100
	local v24 = t1.videoVisiblePercent or MediaGalleryConstants.VIDEO_VISIBLE_PERCENT
	local v25 = `media_gallery_item_{ t1.itemIndex or "0" }_video_{ t1.videoId or "0" }{ not isFullscreen and "" or "_fullscreen" }`
	local v26 = if not v19 then nil else t1.toggleVideoPlaybackSignal
	local v27 = if not v19 then nil else t1.toggleMuteSignal
	local v28 = if not v19 then nil else t1.onVideoEnded
	local v29 = if not v19 then nil else t1.onVideoProgressChanged
	local v30 = if not v19 then nil else t1.onMutedChanged
	local v31, v32 = React.useState(false)
	local v33 = React.useRef(nil)

	React.useEffect(function() -- line: 90
		-- upvalues: v19 (copy), setIsVideoActive (copy)
		if v19 and setIsVideoActive then
			setIsVideoActive(true)

			return function() -- line: 93
				-- upvalues: setIsVideoActive (copy)
				setIsVideoActive(false)
			end
		end

		return nil
	end, {
		v19,
		setIsVideoActive
	})

	local v34 = React.useCallback(function(n1: number, n2: number) -- line: 101
		-- upvalues: videoAnalytics (copy), t1 (copy), v17 (copy), FFlagSduiExperienceDetailsSupport (copy)
		if videoAnalytics then
			videoAnalytics.reportVideoLoad(t1.itemIndex, v17.currentPlaybackSessionId, n1, n2)
		end

		if FFlagSduiExperienceDetailsSupport and t1.onMediaResolved then
			t1.onMediaResolved(true)
		end
	end, {
		t1.itemIndex,
		if not FFlagSduiExperienceDetailsSupport then nil else t1.onMediaResolved,
		videoAnalytics,
		v17.currentPlaybackSessionId
	})
	local v35 = React.useCallback(function(b1: boolean) -- line: 123
		-- upvalues: videoAnalytics (copy), t1 (copy), v17 (copy)
		if videoAnalytics and videoAnalytics.reportVideoMute then
			videoAnalytics.reportVideoMute(t1.itemIndex, v17.currentPlaybackSessionId, b1)
		end
	end, {
		t1.itemIndex,
		videoAnalytics,
		v17.currentPlaybackSessionId
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = t1.Size,
		ZIndex = t1.ZIndex,
		ref = v33
	}, {
		VideoPlayer = React.createElement(VideoPlayer, {
			showMuteButton = true,
			video = v15,
			thumbnail = v16,
			shouldStartPlayback = v31,
			muted = t1.muted == nil or t1.muted,
			looped = t1.looped ~= nil and t1.looped,
			Size = UDim2.fromScale(1, 1),
			cornerRadius = v21,
			onMuteButtonActivated = v35,
			showPlayButton = if t1.showPlayButton == nil then isFullscreen else t1.showPlayButton,
			showProgressBar = if t1.showProgressBar == nil then isFullscreen else t1.showProgressBar,
			videoAnalyticsContext = t1.videoAnalyticsContext,
			onVideoLoaded = v34,
			onVideoProgressChanged = v29,
			onVideoEnded = v28,
			toggleVideoPlaybackSignal = v26,
			toggleMuteSignal = v27,
			onMutedChanged = v30
		}),
		VideoPlaybackDetector = React.createElement(VideoPlaybackDetector, {
			isVideoEligible = true,
			videoKey = v25,
			itemIndex = t1.itemIndex,
			itemFrameRef = v33,
			isItemOccluded = t1.isMediaGalleryOccluded,
			autoplay = t1.autoplay == nil or t1.autoplay,
			videoPlaybackCoordinator = v17,
			onPlaybackChange = v32,
			videoDwellTimeInSec = v23,
			videoVisiblePercent = v24,
			videoAnalytics = videoAnalytics
		}),
		ItemOverlay = if not t1.overlay then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 5,
			Size = UDim2.fromScale(1, 1)
		}, {
			Overlay = t1.overlay
		})
	})
end

return React.memo(MediaGalleryVideoItem)
