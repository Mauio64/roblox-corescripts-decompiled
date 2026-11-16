local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/AppCommonLib")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/Foundation").Hooks.useTokens

local VideoUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/VideoUtils")
local videoPlaybackDetectionMethod = VideoUtils.VideoPlaybackDetectionMethod
local videoPlaybackCoordinator = VideoUtils.VideoPlaybackCoordinator
local videoPlaybackDetector = VideoUtils.VideoPlaybackDetector
local videoPlayer = VideoUtils.VideoPlayer

local fFlagLuaAppMediaGalleryGamepadSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/SharedFlags").FFlagLuaAppMediaGalleryGamepadSupport

local fFlagLuaAppGameTileSelectionVideoPlayback = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/SharedFlags").FFlagLuaAppGameTileSelectionVideoPlayback
local fFlagMediaGalleryVideoVisiblePercent = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/SharedFlags").FFlagMediaGalleryVideoVisiblePercent
local fFlagLuaAppEdpMomentVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/SharedFlags").FFlagLuaAppEdpMomentVideo
local fFlagLuaAppVideoPlayerTrimAndMusic = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/SharedFlags").FFlagLuaAppVideoPlayerTrimAndMusic

local getImageUri = require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/getImageUri")
local MediaGalleryConstants = require("@game/CorePackages/Workspace/Packages/_Index/MediaGallery/MediaGallery/MediaGalleryConstants")

local fFlagLuaAppVideoLoadFailureFallback = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/SharedFlags").FFlagLuaAppVideoLoadFailureFallback
local fFlagFixNonVisibleEdpVideoPlayback = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/SharedFlags").FFlagFixNonVisibleEdpVideoPlayback

local function MediaGalleryVideoItem(props)
	local v5 = useTokens()

	local formatted = `rbxassetid://{props.videoId}`
	local v6 = getImageUri(props.thumbnail or "")
	local videoPlaybackCoordinator2 = props.videoPlaybackCoordinator or videoPlaybackCoordinator.default
	local videoAnalytics = props.videoAnalytics
	local v7 = props.currentIndex == nil or props.itemIndex == props.currentIndex
	local setIsVideoActive = props.setIsVideoActive
	local cornerRadius = props.cornerRadius or v5.Radius.Medium
	local v8 = props.isFullscreen

	local v9 = (props.videoDwellTimeHundredthsSec or MediaGalleryConstants.VIDEO_DWELL_TIME_HUNDREDTHS_SEC) / 100

	local v10 = props.videoVisiblePercent

	if not v10 then
		if fFlagMediaGalleryVideoVisiblePercent then
			v10 = MediaGalleryConstants.VIDEO_PLAYBACK_VISIBLE_PERCENT
		else
			v10 = MediaGalleryConstants.VIDEO_VISIBLE_PERCENT
		end
	end

	local formatted2 = `media_gallery_item_{props.itemIndex or "0"}_video_{props.videoId or "0"}{v8 and "_fullscreen" or ""}`

	local toggleVideoPlaybackSignal = if v7 then props.toggleVideoPlaybackSignal else nil
	local toggleMuteSignal = if v7 then props.toggleMuteSignal else nil
	local onVideoEnded = if v7 then props.onVideoEnded else nil
	local onVideoProgressChanged = if v7 then props.onVideoProgressChanged else nil
	local onMutedChanged = if v7 then props.onMutedChanged else nil

	local onPlayingChanged = if fFlagLuaAppMediaGalleryGamepadSupport and v7 then props.onPlayingChanged else nil

	local onVideoReadyChanged = if fFlagLuaAppMediaGalleryGamepadSupport and v7 then props.onVideoReadyChanged else nil

	local state, setState = React.useState(false)
	local ref = React.useRef(nil)

	React.useEffect(function()
		if v7 and setIsVideoActive then
			setIsVideoActive(true)
			return function()
				setIsVideoActive(false)
			end
		end

		return nil
	end, { v7, setIsVideoActive })

	local v11 = React.useCallback(function(p2, p3)
		if videoAnalytics then
			videoAnalytics.reportVideoLoad(
				props.itemIndex,
				videoPlaybackCoordinator2.currentPlaybackSessionId,
				p2,
				p3
			)
		end

		if props.onMediaResolved then
			props.onMediaResolved(true)
		end
	end, {
		props.itemIndex,
		props.onMediaResolved,
		videoAnalytics,
		videoPlaybackCoordinator2.currentPlaybackSessionId
	})

	local v12 = React.useCallback(function(p2)
		if videoAnalytics and videoAnalytics.reportVideoMute then
			videoAnalytics.reportVideoMute(
				props.itemIndex,
				videoPlaybackCoordinator2.currentPlaybackSessionId,
				p2
			)
		end
	end, { props.itemIndex, videoAnalytics, videoPlaybackCoordinator2.currentPlaybackSessionId })

	local createElement = React.createElement
	local v14 = {
		Size = props.Size,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = props.ZIndex,
		ref = ref
	}

	local createElement2 = React.createElement

	local v17 = if fFlagLuaAppEdpMomentVideo then props.videoAccessContext else nil
	local v18 = if fFlagLuaAppVideoPlayerTrimAndMusic then props.trimStartTime else nil
	local v19 = if fFlagLuaAppVideoPlayerTrimAndMusic then props.trimEndTime else nil
	local v20 = if fFlagLuaAppVideoPlayerTrimAndMusic then props.musicAssetId else nil
	local v21 = if fFlagLuaAppVideoPlayerTrimAndMusic then props.musicStartTime else nil

	if fFlagFixNonVisibleEdpVideoPlayback and state then
		state = v7 and not props.isMediaGalleryOccluded
	end

	local v16 = {
		video = formatted,
		accessContext = v17,
		trimStartTime = v18,
		trimEndTime = v19,
		musicAssetId = v20,
		musicStartTime = v21,
		thumbnail = v6,
		shouldStartPlayback = state,
		muted = props.muted == nil or props.muted,
		looped = props.looped ~= nil and props.looped,
		Size = UDim2.fromScale(1, 1),
		cornerRadius = cornerRadius,
		showMuteButton = true,
		onMuteButtonActivated = v12,
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

	local v23 = if props.showPlayButton == nil then v8 else props.showPlayButton
	v16.showPlayButton = v23

	if props.showProgressBar ~= nil then
		v8 = props.showProgressBar
	end

	v16.showProgressBar = v8
	v16.videoAnalyticsContext = props.videoAnalyticsContext
	v16.onVideoLoaded = v11
	v16.onVideoProgressChanged = onVideoProgressChanged
	v16.onVideoEnded = onVideoEnded

	local v24 = if fFlagLuaAppVideoLoadFailureFallback and v7 and not props.isMediaGalleryOccluded then props.onVideoLoadFailed else nil
	v16.onVideoLoadFailed = v24

	v16.toggleVideoPlaybackSignal = toggleVideoPlaybackSignal
	v16.toggleMuteSignal = toggleMuteSignal
	v16.onMutedChanged = onMutedChanged
	v16.onPlayingChanged = onPlayingChanged
	v16.onVideoLoadedChanged = onVideoReadyChanged
	local children = {
		VideoPlayer = createElement2(videoPlayer, v16),
		VideoPlaybackDetector = 0,
		ItemOverlay = 0,
		Attribution = 0
	}

	local createElement3 = React.createElement
	local v26 = {
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

	local v27 = if fFlagLuaAppGameTileSelectionVideoPlayback and (props.autoplay == nil or props.autoplay) then videoPlaybackDetectionMethod.Viewport else nil
	v26.playbackDetectionMethod = v27

	local v28 = if not fFlagLuaAppGameTileSelectionVideoPlayback then props.autoplay == nil or props.autoplay else nil
	v26.autoplay = v28

	v26.videoPlaybackCoordinator = videoPlaybackCoordinator2
	v26.onPlaybackChange = setState
	v26.videoDwellTimeInSec = v9
	v26.videoVisiblePercent = v10

	v26.videoAnalytics = videoAnalytics
	children.VideoPlaybackDetector = createElement3(videoPlaybackDetector, v26)

	local v29 = if props.overlay then React.createElement(
		"Frame",
		{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 5 },
		{ Overlay = props.overlay }
	) else nil
	children.ItemOverlay = v29

	local v30 = if fFlagLuaAppEdpMomentVideo and props.attributionComponent then React.createElement(
		"Frame",
		{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 6 },
		{ AttributionContent = props.attributionComponent }
	) else nil
	children.Attribution = v30
	return createElement("Frame", v14, children)
end

return React.memo(MediaGalleryVideoItem)
