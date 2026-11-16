local MediaGallery = script:FindFirstAncestor("MediaGallery")
local parent = MediaGallery.Parent

local React = require(parent.React)
require(parent.AppCommonLib)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local VideoUtils = require(parent.VideoUtils)
local VideoPlaybackDetectionMethod = VideoUtils.VideoPlaybackDetectionMethod
local VideoPlaybackCoordinator = VideoUtils.VideoPlaybackCoordinator
local VideoPlaybackDetector = VideoUtils.VideoPlaybackDetector
local VideoPlayer = VideoUtils.VideoPlayer

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppGameTileSelectionVideoPlayback = SharedFlags2.FFlagLuaAppGameTileSelectionVideoPlayback
local SharedFlags3 = require(parent.SharedFlags)
local FFlagMediaGalleryVideoVisiblePercent = SharedFlags3.FFlagMediaGalleryVideoVisiblePercent
local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppEdpMomentVideo = SharedFlags4.FFlagLuaAppEdpMomentVideo
local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppVideoPlayerTrimAndMusic = SharedFlags5.FFlagLuaAppVideoPlayerTrimAndMusic

local getImageUri = require(MediaGallery.getImageUri)
local MediaGalleryConstants = require(MediaGallery.MediaGalleryConstants)

local SharedFlags6 = require(parent.SharedFlags)
local FFlagLuaAppVideoLoadFailureFallback = SharedFlags6.FFlagLuaAppVideoLoadFailureFallback
local SharedFlags7 = require(parent.SharedFlags)
local FFlagFixNonVisibleEdpVideoPlayback = SharedFlags7.FFlagFixNonVisibleEdpVideoPlayback

local function MediaGalleryVideoItem(props)
	local v = useTokens()

	local formatted = `rbxassetid://{props.videoId}`
	local imageUri = getImageUri(props.thumbnail or "")
	local videoPlaybackCoordinator = props.videoPlaybackCoordinator or VideoPlaybackCoordinator.default
	local videoAnalytics = props.videoAnalytics
	local v2 = props.currentIndex == nil or props.itemIndex == props.currentIndex
	local setIsVideoActive = props.setIsVideoActive
	local cornerRadius = props.cornerRadius or v.Radius.Medium
	local showProgressBar = props.isFullscreen

	local videoDwellTimeInSec = (props.videoDwellTimeHundredthsSec or MediaGalleryConstants.VIDEO_DWELL_TIME_HUNDREDTHS_SEC) / 100

	local videoVisiblePercent = props.videoVisiblePercent

	if not videoVisiblePercent then
		if FFlagMediaGalleryVideoVisiblePercent then
			videoVisiblePercent = MediaGalleryConstants.VIDEO_PLAYBACK_VISIBLE_PERCENT
		else
			videoVisiblePercent = MediaGalleryConstants.VIDEO_VISIBLE_PERCENT
		end
	end

	local formatted2 = `media_gallery_item_{props.itemIndex or "0"}_video_{props.videoId or "0"}{showProgressBar and "_fullscreen" or ""}`
	local toggleVideoPlaybackSignal

	if v2 then
		toggleVideoPlaybackSignal = props.toggleVideoPlaybackSignal
	end

	local toggleMuteSignal

	if v2 then
		toggleMuteSignal = props.toggleMuteSignal
	end

	local onVideoEnded

	if v2 then
		onVideoEnded = props.onVideoEnded
	end

	local onVideoProgressChanged

	if v2 then
		onVideoProgressChanged = props.onVideoProgressChanged
	end

	local onMutedChanged

	if v2 then
		onMutedChanged = props.onMutedChanged
	end

	local onPlayingChanged

	if FFlagLuaAppMediaGalleryGamepadSupport and v2 then
		onPlayingChanged = props.onPlayingChanged
	end

	local onVideoReadyChanged

	if FFlagLuaAppMediaGalleryGamepadSupport and v2 then
		onVideoReadyChanged = props.onVideoReadyChanged
	end

	local state, setState = React.useState(false)
	local ref = React.useRef(nil)

	React.useEffect(function()
		if v2 and setIsVideoActive then
			setIsVideoActive(true)
			return function()
				setIsVideoActive(false)
			end
		end

		return nil
	end, { v2, setIsVideoActive })

	local onVideoLoaded = React.useCallback(function(p: number, p2: number)
		if videoAnalytics then
			videoAnalytics.reportVideoLoad(props.itemIndex, videoPlaybackCoordinator.currentPlaybackSessionId, p, p2)
		end

		if props.onMediaResolved then
			props.onMediaResolved(true)
		end
	end, {
		props.itemIndex,
		props.onMediaResolved,
		videoAnalytics,
		videoPlaybackCoordinator.currentPlaybackSessionId
	})

	local onMuteButtonActivated = React.useCallback(function(flag: boolean)
		if videoAnalytics and videoAnalytics.reportVideoMute then
			videoAnalytics.reportVideoMute(props.itemIndex, videoPlaybackCoordinator.currentPlaybackSessionId, flag)
		end
	end, { props.itemIndex, videoAnalytics, videoPlaybackCoordinator.currentPlaybackSessionId })

	local createElement = React.createElement
	local v3 = {
		Size = props.Size,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = props.ZIndex,
		ref = ref
	}

	local createElement2 = React.createElement
	local accessContext

	if FFlagLuaAppEdpMomentVideo then
		accessContext = props.videoAccessContext
	end

	local trimStartTime

	if FFlagLuaAppVideoPlayerTrimAndMusic then
		trimStartTime = props.trimStartTime
	end

	local trimEndTime

	if FFlagLuaAppVideoPlayerTrimAndMusic then
		trimEndTime = props.trimEndTime
	end

	local musicAssetId

	if FFlagLuaAppVideoPlayerTrimAndMusic then
		musicAssetId = props.musicAssetId
	end

	local musicStartTime

	if FFlagLuaAppVideoPlayerTrimAndMusic then
		musicStartTime = props.musicStartTime
	end

	if FFlagFixNonVisibleEdpVideoPlayback and state then
		state = v2 and not props.isMediaGalleryOccluded
	end

	local v4 = {
		video = formatted,
		accessContext = accessContext,
		trimStartTime = trimStartTime,
		trimEndTime = trimEndTime,
		musicAssetId = musicAssetId,
		musicStartTime = musicStartTime,
		thumbnail = imageUri,
		shouldStartPlayback = state,
		muted = props.muted == nil or props.muted,
		looped = props.looped ~= nil and props.looped,
		Size = UDim2.fromScale(1, 1),
		cornerRadius = cornerRadius,
		showMuteButton = true,
		onMuteButtonActivated = onMuteButtonActivated,
		showPlayButton = 0,
		showProgressBar = 0,
		videoAnalyticsContext = 0,
		onVideoLoaded = 0,
		onVideoProgressChanged = 0,
		onVideoEnded = 0,
		onVideoLoadFailed = 0,
		toggleVideoPlaybackSignal = 0,
		toggleMuteSignal = 0,
		onMutedChanged = 0,
		onPlayingChanged = 0,
		onVideoLoadedChanged = 0
	}
	local showPlayButton

	if props.showPlayButton == nil then
		showPlayButton = showProgressBar
	else
		showPlayButton = props.showPlayButton
	end

	v4.showPlayButton = showPlayButton

	if props.showProgressBar ~= nil then
		showProgressBar = props.showProgressBar
	end

	v4.showProgressBar = showProgressBar
	v4.videoAnalyticsContext = props.videoAnalyticsContext
	v4.onVideoLoaded = onVideoLoaded
	v4.onVideoProgressChanged = onVideoProgressChanged
	v4.onVideoEnded = onVideoEnded
	local onVideoLoadFailed

	if FFlagLuaAppVideoLoadFailureFallback and v2 and not props.isMediaGalleryOccluded then
		onVideoLoadFailed = props.onVideoLoadFailed
	end

	v4.onVideoLoadFailed = onVideoLoadFailed

	v4.toggleVideoPlaybackSignal = toggleVideoPlaybackSignal
	v4.toggleMuteSignal = toggleMuteSignal
	v4.onMutedChanged = onMutedChanged
	v4.onPlayingChanged = onPlayingChanged
	v4.onVideoLoadedChanged = onVideoReadyChanged
	local children = {
		VideoPlayer = createElement2(VideoPlayer, v4),
		VideoPlaybackDetector = 0,
		ItemOverlay = 0,
		Attribution = 0
	}

	local createElement3 = React.createElement
	local v5 = {
		videoKey = formatted2,
		itemIndex = props.itemIndex,
		itemFrameRef = ref,
		isItemOccluded = props.isMediaGalleryOccluded,
		playbackDetectionMethod = 0,
		autoplay = 0,
		videoPlaybackCoordinator = 0,
		onPlaybackChange = 0,
		videoDwellTimeInSec = 0,
		videoVisiblePercent = 0,
		isVideoEligible = true,
		videoAnalytics = 0
	}
	local playbackDetectionMethod

	if FFlagLuaAppGameTileSelectionVideoPlayback and (props.autoplay == nil or props.autoplay) then
		playbackDetectionMethod = VideoPlaybackDetectionMethod.Viewport
	end

	v5.playbackDetectionMethod = playbackDetectionMethod
	local autoplay

	if not FFlagLuaAppGameTileSelectionVideoPlayback then
		autoplay = props.autoplay == nil or props.autoplay
	end

	v5.autoplay = autoplay

	v5.videoPlaybackCoordinator = videoPlaybackCoordinator
	v5.onPlaybackChange = setState
	v5.videoDwellTimeInSec = videoDwellTimeInSec
	v5.videoVisiblePercent = videoVisiblePercent

	v5.videoAnalytics = videoAnalytics
	children.VideoPlaybackDetector = createElement3(VideoPlaybackDetector, v5)
	local itemOverlay

	if props.overlay then
		itemOverlay = React.createElement(
			"Frame",
			{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 5 },
			{ Overlay = props.overlay }
		)
	end

	children.ItemOverlay = itemOverlay
	local attribution

	if FFlagLuaAppEdpMomentVideo and props.attributionComponent then
		attribution = React.createElement(
			"Frame",
			{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 6 },
			{ AttributionContent = props.attributionComponent }
		)
	end

	children.Attribution = attribution
	return createElement("Frame", v3, children)
end

return React.memo(MediaGalleryVideoItem)
