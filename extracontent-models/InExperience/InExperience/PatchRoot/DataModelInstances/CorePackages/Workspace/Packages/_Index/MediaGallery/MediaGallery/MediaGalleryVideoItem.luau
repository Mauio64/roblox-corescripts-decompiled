local MediaGallery = script:FindFirstAncestor("MediaGallery")
local MediaGalleryParent = MediaGallery.Parent
local React = require(MediaGalleryParent.React)

require(MediaGalleryParent.AppCommonLib)

local useTokens = require(MediaGalleryParent.Foundation).Hooks.useTokens
local VideoUtils = require(MediaGalleryParent.VideoUtils)
local VideoPlaybackDetectionMethod = VideoUtils.VideoPlaybackDetectionMethod
local VideoPlaybackCoordinator = VideoUtils.VideoPlaybackCoordinator
local VideoPlaybackDetector = VideoUtils.VideoPlaybackDetector
local VideoPlayer = VideoUtils.VideoPlayer
local FFlagSduiExperienceDetailsSupport = require(MediaGalleryParent.SharedFlags).FFlagSduiExperienceDetailsSupport
local FFlagLuaAppGameTileSelectionVideoPlayback = require(MediaGalleryParent.SharedFlags).FFlagLuaAppGameTileSelectionVideoPlayback
local getImageUri = require(MediaGallery.getImageUri)
local MediaGalleryConstants = require(MediaGallery.MediaGalleryConstants)

local function MediaGalleryVideoItem(t1: {[any]: any}) -- line: 64
	-- upvalues: useTokens (copy), getImageUri (copy), VideoPlaybackCoordinator (copy), MediaGalleryConstants (copy), React (copy), FFlagSduiExperienceDetailsSupport (copy), VideoPlayer (copy), VideoPlaybackDetector (copy), FFlagLuaAppGameTileSelectionVideoPlayback (copy), VideoPlaybackDetectionMethod (copy)
	local v16 = useTokens()
	local v17 = `rbxassetid://{ t1.videoId }`
	local v18 = getImageUri(t1.thumbnail or "")
	local v19 = t1.videoPlaybackCoordinator or VideoPlaybackCoordinator.default
	local videoAnalytics = t1.videoAnalytics
	local v21 = t1.currentIndex == nil or t1.itemIndex == t1.currentIndex
	local setIsVideoActive = t1.setIsVideoActive
	local v23 = t1.cornerRadius or v16.Radius.Medium
	local isFullscreen = t1.isFullscreen
	local v25 = (t1.videoDwellTimeHundredthsSec or MediaGalleryConstants.VIDEO_DWELL_TIME_HUNDREDTHS_SEC) / 100
	local v26 = t1.videoVisiblePercent or MediaGalleryConstants.VIDEO_VISIBLE_PERCENT
	local v27 = `media_gallery_item_{ t1.itemIndex or "0" }_video_{ t1.videoId or "0" }{ not isFullscreen and "" or "_fullscreen" }`
	local v28 = if not v21 then nil else t1.toggleVideoPlaybackSignal
	local v29 = if not v21 then nil else t1.toggleMuteSignal
	local v30 = if not v21 then nil else t1.onVideoEnded
	local v31 = if not v21 then nil else t1.onVideoProgressChanged
	local v32 = if not v21 then nil else t1.onMutedChanged
	local v33, v34 = React.useState(false)
	local v35 = React.useRef(nil)

	React.useEffect(function() -- line: 93
		-- upvalues: v21 (copy), setIsVideoActive (copy)
		if v21 and setIsVideoActive then
			setIsVideoActive(true)

			return function() -- line: 96
				-- upvalues: setIsVideoActive (copy)
				setIsVideoActive(false)
			end
		end

		return nil
	end, {
		v21,
		setIsVideoActive
	})

	local v36 = React.useCallback(function(n1: number, n2: number) -- line: 104
		-- upvalues: videoAnalytics (copy), t1 (copy), v19 (copy), FFlagSduiExperienceDetailsSupport (copy)
		if videoAnalytics then
			videoAnalytics.reportVideoLoad(t1.itemIndex, v19.currentPlaybackSessionId, n1, n2)
		end

		if FFlagSduiExperienceDetailsSupport and t1.onMediaResolved then
			t1.onMediaResolved(true)
		end
	end, {
		t1.itemIndex,
		if not FFlagSduiExperienceDetailsSupport then nil else t1.onMediaResolved,
		videoAnalytics,
		v19.currentPlaybackSessionId
	})
	local v37 = React.useCallback(function(b1: boolean) -- line: 126
		-- upvalues: videoAnalytics (copy), t1 (copy), v19 (copy)
		if videoAnalytics and videoAnalytics.reportVideoMute then
			videoAnalytics.reportVideoMute(t1.itemIndex, v19.currentPlaybackSessionId, b1)
		end
	end, {
		t1.itemIndex,
		videoAnalytics,
		v19.currentPlaybackSessionId
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = t1.Size,
		ZIndex = t1.ZIndex,
		ref = v35
	}, {
		VideoPlayer = React.createElement(VideoPlayer, {
			showMuteButton = true,
			video = v17,
			thumbnail = v18,
			shouldStartPlayback = v33,
			muted = t1.muted == nil or t1.muted,
			looped = t1.looped ~= nil and t1.looped,
			Size = UDim2.fromScale(1, 1),
			cornerRadius = v23,
			onMuteButtonActivated = v37,
			showPlayButton = if t1.showPlayButton == nil then isFullscreen else t1.showPlayButton,
			showProgressBar = if t1.showProgressBar == nil then isFullscreen else t1.showProgressBar,
			videoAnalyticsContext = t1.videoAnalyticsContext,
			onVideoLoaded = v36,
			onVideoProgressChanged = v31,
			onVideoEnded = v30,
			toggleVideoPlaybackSignal = v28,
			toggleMuteSignal = v29,
			onMutedChanged = v32
		}),
		VideoPlaybackDetector = React.createElement(VideoPlaybackDetector, {
			isVideoEligible = true,
			videoKey = v27,
			itemIndex = t1.itemIndex,
			itemFrameRef = v35,
			isItemOccluded = t1.isMediaGalleryOccluded,
			playbackDetectionMethod = if not FFlagLuaAppGameTileSelectionVideoPlayback or not (t1.autoplay == nil or t1.autoplay) then nil else VideoPlaybackDetectionMethod.Viewport,
			autoplay = if not FFlagLuaAppGameTileSelectionVideoPlayback then t1.autoplay == nil or t1.autoplay else nil,
			videoPlaybackCoordinator = v19,
			onPlaybackChange = v34,
			videoDwellTimeInSec = v25,
			videoVisiblePercent = v26,
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
