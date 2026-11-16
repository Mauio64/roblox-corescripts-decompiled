local GameTile = script:FindFirstAncestor("GameTile")
local parent = GameTile.Parent

local React = require(parent.React)
local Http = require(parent.Http)
local RetrievalStatus = Http.Enum.RetrievalStatus
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local useIsVideoEligible = require(GameTile.Video.useIsVideoEligible)
local Responsive = require(parent.Responsive)
local usePreferredInput = Responsive.usePreferredInput

local VideoUtils = require(parent.VideoUtils)
local getPlaybackDetectionMethod = VideoUtils.getPlaybackDetectionMethod
local VideoPlaybackDetectionMethod = VideoUtils.VideoPlaybackDetectionMethod
local VideoPlaybackDetector = VideoUtils.VideoPlaybackDetector
local VideoEndReason = VideoUtils.AnalyticsEnums.VideoEndReason
local useCanDevicePlayVideoPreview = VideoUtils.useCanDevicePlayVideoPreview
local TileVideoBlockingConfig = require(GameTile.Video.TileVideoBlockingConfig)

local GameDetailRodux = require(parent.GameDetailRodux)
local FetchGamePlayabilityAndProductInfo = GameDetailRodux.FetchGamePlayabilityAndProductInfo

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEdpMediaGalleryVideoPreview = SharedFlags.FFlagLuaAppEdpMediaGalleryVideoPreview

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppUsePrevalidatedVideoGamePlayability = SharedFlags2.FFlagLuaAppUsePrevalidatedVideoGamePlayability

local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppGameTileSelectionVideoPlayback = SharedFlags3.FFlagLuaAppGameTileSelectionVideoPlayback
local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppOneByTwoHoverIdleAutoplay = SharedFlags4.FFlagLuaAppOneByTwoHoverIdleAutoplay

local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppSuppressVideoDetectorDuringScroll = SharedFlags5.FFlagLuaAppSuppressVideoDetectorDuringScroll

local function GameVideoPlaybackDetector(props)
	local v = useDispatch()
	local v2 = useRoactService(RoactNetworking)

	local v3 = useSelector(function(p)
		return FetchGamePlayabilityAndProductInfo.GetFetchingStatus(p, props.universeId)
	end)

	local universeId = props.universeId
	local v4

	if FFlagLuaAppUsePrevalidatedVideoGamePlayability then
		v4 = props.hasPrevalidatedVideoGamePlayability
	end

	local v5 = useIsVideoEligible(universeId, v4)

	local state, setState = React.useState(false)
	local ref

	if FFlagLuaAppSuppressVideoDetectorDuringScroll then
		ref = React.useRef(false)
	else
		ref = nil
	end

	local v6 = useCanDevicePlayVideoPreview(TileVideoBlockingConfig, props.universeId, props.pageContext)

	local useCallback = React.useCallback
	local function fn(p)
		if FFlagLuaAppSuppressVideoDetectorDuringScroll and v5 and ref.current then
			return
		end

		if props.videoAnalytics and v3 == RetrievalStatus.Done then
			props.videoAnalytics.reportVideoEnd(props.itemIndex, VideoEndReason.PlayabilityCheckFailed, p, -1)
		end
	end

	local videoAnalytics = props.videoAnalytics
	local v7

	if FFlagLuaAppSuppressVideoDetectorDuringScroll then
		v7 = v5
	end

	local onVideoIneligible = useCallback(fn, { videoAnalytics, v3, v7 })

	local useCallback2 = React.useCallback
	local function fn2()
		if
			(v3 == RetrievalStatus.NotStarted or v3 == RetrievalStatus.Failed)
			and not (FFlagLuaAppUsePrevalidatedVideoGamePlayability and props.hasPrevalidatedVideoGamePlayability)
		then
			v(FetchGamePlayabilityAndProductInfo.Fetch(v2, props.universeId))
		end

		local current = v6()

		if FFlagLuaAppSuppressVideoDetectorDuringScroll then
			ref.current = current
		end

		setState(current)
	end

	local universeId2 = props.universeId
	local v8

	if FFlagLuaAppUsePrevalidatedVideoGamePlayability then
		v8 = props.hasPrevalidatedVideoGamePlayability
	end

	local onPlaybackCandidate = useCallback2(fn2, { universeId2, v3, v, v2, v6, v8 })
	local v9

	if FFlagLuaAppGameTileSelectionVideoPlayback or FFlagLuaAppOneByTwoHoverIdleAutoplay then
		v9 = getPlaybackDetectionMethod(usePreferredInput(), props.isHoverSupported)
	end

	local createElement = React.createElement
	local v10 = {
		videoKey = props.videoKey,
		itemIndex = props.itemIndex,
		itemFrameRef = props.tileRef,
		playbackDetectionMethod = 0,
		isHoverSupported = 0,
		isHovered = 0,
		isSelected = 0,
		hasVideoPlaybackUserIntent = 0,
		autoplay = 0,
		videoPlaybackCoordinator = 0,
		onPlaybackChange = 0,
		videoAnalytics = 0,
		videoDwellTimeInSec = 0,
		videoVisiblePercent = 0,
		isVideoEligible = 0,
		onVideoIneligible = 0,
		onPlaybackCandidate = 0,
		viewportVideoAutoplayController = 0
	}
	local playbackDetectionMethod

	if FFlagLuaAppGameTileSelectionVideoPlayback or FFlagLuaAppOneByTwoHoverIdleAutoplay then
		playbackDetectionMethod = v9
	end

	v10.playbackDetectionMethod = playbackDetectionMethod
	local isHoverSupported

	if not FFlagLuaAppGameTileSelectionVideoPlayback then
		isHoverSupported = props.isHoverSupported
	end

	v10.isHoverSupported = isHoverSupported
	v10.isHovered = props.isHovered
	local isSelected

	if FFlagLuaAppGameTileSelectionVideoPlayback then
		isSelected = props.isSelected
	end

	v10.isSelected = isSelected
	local hasVideoPlaybackUserIntent

	if FFlagLuaAppOneByTwoHoverIdleAutoplay and v9 == VideoPlaybackDetectionMethod.Hover then
		hasVideoPlaybackUserIntent = props.isHovered
	end

	v10.hasVideoPlaybackUserIntent = hasVideoPlaybackUserIntent
	local autoplay

	if not (FFlagLuaAppGameTileSelectionVideoPlayback or not FFlagLuaAppEdpMediaGalleryVideoPreview) then
		autoplay = props.autoplay
	end

	v10.autoplay = autoplay
	local videoPlaybackCoordinator

	if props.videoPlaybackContext then
		videoPlaybackCoordinator = props.videoPlaybackContext.videoPlaybackCoordinator
	end

	v10.videoPlaybackCoordinator = videoPlaybackCoordinator

	v10.onPlaybackChange = props.onPlaybackChange
	v10.videoAnalytics = props.videoAnalytics
	v10.videoDwellTimeInSec = props.videoDwellTimeInSec
	v10.videoVisiblePercent = props.videoVisiblePercent
	v10.isVideoEligible = v5 and state
	v10.onVideoIneligible = onVideoIneligible
	v10.onPlaybackCandidate = onPlaybackCandidate
	local viewportVideoAutoplayController

	if props.videoPlaybackContext then
		viewportVideoAutoplayController = props.videoPlaybackContext.viewportVideoAutoplayController
	end

	v10.viewportVideoAutoplayController = viewportVideoAutoplayController
	return createElement(VideoPlaybackDetector, v10)
end

return GameVideoPlaybackDetector
