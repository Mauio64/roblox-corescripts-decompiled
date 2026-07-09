local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local VideoUtils = require(CorePackages.Workspace.Packages.VideoUtils)
local VideoActions = VideoUtils.AnalyticsEnums.VideoActions
local VideoLogger = VideoUtils.VideoLogger
local VideoPlaybackCoordinator = VideoUtils.VideoPlaybackCoordinator
local VideoPlaybackDetector = VideoUtils.VideoPlaybackDetector
local VideoPlayer = VideoUtils.VideoPlayer

require(CorePackages.Workspace.Packages.AppCommonLib)

local FFlagLuaAppEdpMediaGalleryAutoAdvance = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryAutoAdvance
local FFlagLuaAppEdpMediaGalleryFullScreen = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryFullScreen
local FIntLuaAppEdpMediaGalleryItemVisiblePercent = require(CorePackages.Workspace.Packages.SharedFlags).FIntLuaAppEdpMediaGalleryItemVisiblePercent
local v13 = game:DefineFastInt("LuaAppEdpMediaGalleryVideoDwellTimeInHundredthsSec", 0)

local function MediaGalleryVideoItem(t1: {[any]: any}) -- line: 54
	-- upvalues: VideoPlaybackCoordinator (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), React (copy), ArgCheck (copy), VideoLogger (copy), VideoActions (copy), VideoPlayer (copy), FFlagLuaAppEdpMediaGalleryAutoAdvance (copy), VideoPlaybackDetector (copy), v13 (copy), FIntLuaAppEdpMediaGalleryItemVisiblePercent (copy)
	local v16 = t1.videoPlaybackCoordinator or VideoPlaybackCoordinator.default
	local v17 = if not FFlagLuaAppEdpMediaGalleryFullScreen then `media_gallery_item_{ t1.itemIndex or "0" }_video_{ t1.video or "0" }` else `media_gallery_item_{ t1.itemIndex or "0" }_video_{ t1.video or "0" }{ not t1.isFullscreen and "" or "_fullscreen" }`
	local v18, v19 = React.useState(false)
	local v20 = React.useRef(nil)
	local v21 = React.useCallback(function(n1: number, n2: number) -- line: 68
		-- upvalues: t1 (copy), v16 (copy)
		if t1.videoAnalytics then
			t1.videoAnalytics.reportVideoLoad(t1.itemIndex, v16.currentPlaybackSessionId, n1, n2)
		end
	end, {
		t1.itemIndex,
		t1.videoAnalytics,
		v16.currentPlaybackSessionId
	})
	local v22 = React.useCallback(function(b1: boolean) -- line: 79
		-- upvalues: ArgCheck (copy), t1 (copy), VideoLogger (copy), VideoActions (copy), v16 (copy)
		ArgCheck.assert(t1.universeId)
		VideoLogger.reportVideoAction(VideoActions.volume, "GameDetails", {
			source = "MediaGallery",
			videoAssetId = t1.video,
			sourceId = t1.universeId or "",
			playbackSessionId = v16.currentPlaybackSessionId,
			volumeLevel = not b1 and 1 or 0
		})
	end, {
		t1.video,
		t1.universeId,
		v16.currentPlaybackSessionId
	})
	local v23 = nil

	if FFlagLuaAppEdpMediaGalleryFullScreen then
		v23 = React.useMemo(function() -- line: 94
			-- upvalues: t1 (copy), v16 (copy)
			return {
				videoAnalyticsData = {
					source = "MediaGallery",
					sourceId = t1.universeId or nil
				},
				getPlaybackSessionId = function() -- line: 102
					-- upvalues: v16 (copy)
					return v16.currentPlaybackSessionId
				end
			}
		end, {
			t1.universeId,
			v16
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = t1.Size,
		ZIndex = t1.ZIndex,
		ref = v20
	}, {
		VideoPlayer = React.createElement(VideoPlayer, {
			muted = true,
			looped = false,
			showMuteButton = true,
			video = t1.video,
			thumbnail = t1.thumbnail,
			shouldStartPlayback = v18,
			Size = UDim2.fromScale(1, 1),
			cornerRadius = t1.cornerRadius,
			onMuteButtonActivated = v22,
			showPlayButton = if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else t1.isFullscreen,
			showProgressBar = if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else t1.isFullscreen,
			videoAnalyticsContext = if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else v23,
			onVideoLoaded = v21,
			onVideoProgressChanged = if not FFlagLuaAppEdpMediaGalleryAutoAdvance then nil else t1.onVideoProgressChanged,
			onVideoEnded = if not FFlagLuaAppEdpMediaGalleryAutoAdvance then nil else t1.onVideoEnded,
			toggleVideoPlaybackSignal = t1.toggleVideoPlaybackSignal,
			toggleMuteSignal = t1.toggleMuteSignal,
			onMutedChanged = t1.onMutedChanged
		}),
		VideoPlaybackDetector = React.createElement(VideoPlaybackDetector, {
			autoplay = true,
			isVideoEligible = true,
			videoKey = v17,
			itemIndex = t1.itemIndex,
			itemFrameRef = v20,
			isItemOccluded = if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else t1.isMediaGalleryOccluded,
			videoPlaybackCoordinator = v16,
			onPlaybackChange = v19,
			videoDwellTimeInSec = v13 / 100,
			videoVisiblePercent = FIntLuaAppEdpMediaGalleryItemVisiblePercent,
			videoAnalytics = t1.videoAnalytics
		})
	})
end

return MediaGalleryVideoItem
