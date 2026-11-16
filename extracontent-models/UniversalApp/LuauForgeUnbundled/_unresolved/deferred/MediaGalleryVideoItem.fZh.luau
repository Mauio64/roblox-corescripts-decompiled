local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/dwM")

local module2 = require("@luauforge/bundled/fZd")
local videoActions = module2.AnalyticsEnums.VideoActions
local videoLogger = module2.VideoLogger
local videoPlaybackDetectionMethod = module2.VideoPlaybackDetectionMethod
local videoPlaybackCoordinator = module2.VideoPlaybackCoordinator
local videoPlaybackDetector = module2.VideoPlaybackDetector
local videoPlayer = module2.VideoPlayer
require("@game/CorePackages/Workspace/Packages/AppCommonLib")

local fFlagLuaAppEdpMediaGalleryAutoAdvance = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryAutoAdvance

local fFlagLuaAppEdpMediaGalleryFullScreen = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryFullScreen

local fIntLuaAppEdpMediaGalleryItemVisiblePercent = require("@game/CorePackages/Workspace/Packages/SharedFlags").FIntLuaAppEdpMediaGalleryItemVisiblePercent

local fFlagLuaAppGameTileSelectionVideoPlayback = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppGameTileSelectionVideoPlayback

local fFlagLuaAppEdpConsoleMediaGalleryVideo = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpConsoleMediaGalleryVideo

local defineFastInt = game:DefineFastInt("LuaAppEdpMediaGalleryVideoDwellTimeInHundredthsSec", 0)

local function MediaGalleryVideoItem(props)
	local videoPlaybackCoordinator2 = props.videoPlaybackCoordinator or videoPlaybackCoordinator.default
	local v5

	if fFlagLuaAppEdpMediaGalleryFullScreen then
		v5 = `media_gallery_item_{props.itemIndex or "0"}_video_{props.video or "0"}{props.isFullscreen and "_fullscreen" or ""}`
	else
		v5 = `media_gallery_item_{props.itemIndex or "0"}_video_{props.video or "0"}`
	end

	local state, setState = React.useState(false)

	local ref = React.useRef(nil)

	local v6 = React.useCallback(function(p2, p3)
		if props.videoAnalytics then
			props.videoAnalytics.reportVideoLoad(
				props.itemIndex,
				videoPlaybackCoordinator2.currentPlaybackSessionId,
				p2,
				p3
			)
		end
	end, { props.itemIndex, props.videoAnalytics, videoPlaybackCoordinator2.currentPlaybackSessionId })

	local v7 = React.useCallback(function(p2)
		module.assert(props.universeId)

		videoLogger.reportVideoAction(videoActions.volume, "GameDetails", {
			videoAssetId = props.video,
			source = "MediaGallery",
			sourceId = props.universeId or "",
			playbackSessionId = videoPlaybackCoordinator2.currentPlaybackSessionId,
			volumeLevel = p2 and 0 or 1
		})
	end, { props.video, props.universeId, videoPlaybackCoordinator2.currentPlaybackSessionId })
	local v8

	if fFlagLuaAppEdpMediaGalleryFullScreen then
		v8 = React.useMemo(function()
			return {
				videoAnalyticsData = {
					source = "MediaGallery",
					sourceId = props.universeId or nil
				},
				getPlaybackSessionId = function()
					return videoPlaybackCoordinator2.currentPlaybackSessionId
				end
			}
		end, { props.universeId, videoPlaybackCoordinator2 })
	end

	local createElement = React.createElement
	local v10 = {
		Size = props.Size,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = props.ZIndex,
		ref = ref
	}

	local createElement2 = React.createElement
	local v12 = {
		video = props.video,
		thumbnail = props.thumbnail,
		shouldStartPlayback = state,
		muted = true,
		looped = false,
		Size = UDim2.fromScale(1, 1),
		cornerRadius = props.cornerRadius,
		showMuteButton = not fFlagLuaAppEdpConsoleMediaGalleryVideo or not props.hideMuteButton,
		onMuteButtonActivated = v7,
		showPlayButton = 0,
		showProgressBar = 0,
		videoAnalyticsContext = 0,
		onVideoLoaded = 0,
		onVideoProgressChanged = 0,
		onVideoEnded = 0,
		toggleVideoPlaybackSignal = 0,
		toggleMuteSignal = 0,
		onMutedChanged = 0
	}

	local v13 = if fFlagLuaAppEdpMediaGalleryFullScreen then props.isFullscreen else nil
	v12.showPlayButton = v13
	local v14 = if fFlagLuaAppEdpMediaGalleryFullScreen then props.isFullscreen else nil
	v12.showProgressBar = v14

	if not fFlagLuaAppEdpMediaGalleryFullScreen then
		v8 = nil
	end

	v12.videoAnalyticsContext = v8
	v12.onVideoLoaded = v6

	local v15 = if fFlagLuaAppEdpMediaGalleryAutoAdvance then props.onVideoProgressChanged else nil
	v12.onVideoProgressChanged = v15

	local v16 = if fFlagLuaAppEdpMediaGalleryAutoAdvance then props.onVideoEnded else nil
	v12.onVideoEnded = v16
	v12.toggleVideoPlaybackSignal = props.toggleVideoPlaybackSignal
	v12.toggleMuteSignal = props.toggleMuteSignal
	v12.onMutedChanged = props.onMutedChanged
	local children = {
		VideoPlayer = createElement2(videoPlayer, v12),
		VideoPlaybackDetector = 0
	}

	local createElement3 = React.createElement
	local v18 = {
		videoKey = v5,
		itemIndex = props.itemIndex,
		itemFrameRef = ref,
		isItemOccluded = 0,
		playbackDetectionMethod = 0,
		autoplay = 0,
		videoPlaybackCoordinator = 0,
		onPlaybackChange = 0,
		videoDwellTimeInSec = 0,
		videoVisiblePercent = 0,
		isVideoEligible = true,
		videoAnalytics = 0
	}

	local v19 = if fFlagLuaAppEdpMediaGalleryFullScreen then props.isMediaGalleryOccluded else nil
	v18.isItemOccluded = v19

	local v20 = if fFlagLuaAppGameTileSelectionVideoPlayback then videoPlaybackDetectionMethod.Viewport else nil
	v18.playbackDetectionMethod = v20

	v18.autoplay = not fFlagLuaAppGameTileSelectionVideoPlayback or nil
	v18.videoPlaybackCoordinator = videoPlaybackCoordinator2
	v18.onPlaybackChange = setState
	v18.videoDwellTimeInSec = defineFastInt / 100
	v18.videoVisiblePercent = fIntLuaAppEdpMediaGalleryItemVisiblePercent

	v18.videoAnalytics = props.videoAnalytics
	children.VideoPlaybackDetector = createElement3(videoPlaybackDetector, v18)
	return createElement("Frame", v10, children)
end

return MediaGalleryVideoItem
