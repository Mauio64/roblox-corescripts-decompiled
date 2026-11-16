local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Http").Enum.RetrievalStatus
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactServiceTags").RoactNetworking
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RobloxAppHooks").useRoactService
local useIsVideoEligible = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Video/useIsVideoEligible")
local usePreferredInput = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Responsive").usePreferredInput

local VideoUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/VideoUtils")
local getPlaybackDetectionMethod = VideoUtils.getPlaybackDetectionMethod
local videoPlaybackDetectionMethod = VideoUtils.VideoPlaybackDetectionMethod
local videoPlaybackDetector = VideoUtils.VideoPlaybackDetector
local videoEndReason = VideoUtils.AnalyticsEnums.VideoEndReason
local useCanDevicePlayVideoPreview = VideoUtils.useCanDevicePlayVideoPreview
local TileVideoBlockingConfig = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Video/TileVideoBlockingConfig")

local fetchGamePlayabilityAndProductInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/GameDetailRodux").FetchGamePlayabilityAndProductInfo

local fFlagLuaAppEdpMediaGalleryVideoPreview = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppEdpMediaGalleryVideoPreview

local fFlagLuaAppUsePrevalidatedVideoGamePlayability = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppUsePrevalidatedVideoGamePlayability

local fFlagLuaAppGameTileSelectionVideoPlayback = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppGameTileSelectionVideoPlayback
local fFlagLuaAppOneByTwoHoverIdleAutoplay = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppOneByTwoHoverIdleAutoplay

local fFlagLuaAppSuppressVideoDetectorDuringScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppSuppressVideoDetectorDuringScroll

local function GameVideoPlaybackDetector(props)
	local v5 = useDispatch()
	local v6 = useRoactService(roactNetworking)

	local v7 = useSelector(function(p2)
		return fetchGamePlayabilityAndProductInfo.GetFetchingStatus(p2, props.universeId)
	end)

	local universeId = props.universeId
	local v9

	if fFlagLuaAppUsePrevalidatedVideoGamePlayability then
		v9 = props.hasPrevalidatedVideoGamePlayability
	end

	local v10 = useIsVideoEligible(universeId, v9)

	local state, setState = React.useState(false)

	local ref = if fFlagLuaAppSuppressVideoDetectorDuringScroll then React.useRef(false) else nil

	local v11 = useCanDevicePlayVideoPreview(TileVideoBlockingConfig, props.universeId, props.pageContext)

	local function fn(p2)
		if fFlagLuaAppSuppressVideoDetectorDuringScroll and v10 and ref.current then
			return
		end

		if props.videoAnalytics and v7 == retrievalStatus.Done then
			props.videoAnalytics.reportVideoEnd(
				props.itemIndex,
				videoEndReason.PlayabilityCheckFailed,
				p2,
				-1
			)
		end
	end

	local v15 = React.useCallback(fn, {
		props.videoAnalytics,
		v7,
		if fFlagLuaAppSuppressVideoDetectorDuringScroll then v10 else nil
	})

	local useCallback2 = React.useCallback
	local function fn2()
		if
			(v7 == retrievalStatus.NotStarted or v7 == retrievalStatus.Failed)
			and not (fFlagLuaAppUsePrevalidatedVideoGamePlayability and props.hasPrevalidatedVideoGamePlayability)
		then
			v5(fetchGamePlayabilityAndProductInfo.Fetch(v6, props.universeId))
		end

		local v16 = v11()

		if fFlagLuaAppSuppressVideoDetectorDuringScroll then
			ref.current = v16
		end

		setState(v16)
	end

	local universeId2 = props.universeId

	local v17 = if fFlagLuaAppUsePrevalidatedVideoGamePlayability then props.hasPrevalidatedVideoGamePlayability else nil
	local v18 = useCallback2(fn2, { universeId2, v7, v5, v6, v11, v17 })
	local v19

	if fFlagLuaAppGameTileSelectionVideoPlayback or fFlagLuaAppOneByTwoHoverIdleAutoplay then
		v19 = getPlaybackDetectionMethod(usePreferredInput(), props.isHoverSupported)
	end

	local createElement = React.createElement
	local v21 = {
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
	local v22 = if fFlagLuaAppGameTileSelectionVideoPlayback or fFlagLuaAppOneByTwoHoverIdleAutoplay then v19 else nil
	v21.playbackDetectionMethod = v22

	local v23 = if not fFlagLuaAppGameTileSelectionVideoPlayback then props.isHoverSupported else nil
	v21.isHoverSupported = v23
	v21.isHovered = props.isHovered
	local v24 = if fFlagLuaAppGameTileSelectionVideoPlayback then props.isSelected else nil
	v21.isSelected = v24

	local v25 = if fFlagLuaAppOneByTwoHoverIdleAutoplay and v19 == videoPlaybackDetectionMethod.Hover then props.isHovered else nil
	v21.hasVideoPlaybackUserIntent = v25

	local v26 = if not (fFlagLuaAppGameTileSelectionVideoPlayback or not fFlagLuaAppEdpMediaGalleryVideoPreview) then props.autoplay else nil
	v21.autoplay = v26

	local v27 = if props.videoPlaybackContext then props.videoPlaybackContext.videoPlaybackCoordinator else nil
	v21.videoPlaybackCoordinator = v27

	v21.onPlaybackChange = props.onPlaybackChange
	v21.videoAnalytics = props.videoAnalytics
	v21.videoDwellTimeInSec = props.videoDwellTimeInSec
	v21.videoVisiblePercent = props.videoVisiblePercent
	v21.isVideoEligible = v10 and state
	v21.onVideoIneligible = v15
	v21.onPlaybackCandidate = v18
	local v28 = if props.videoPlaybackContext then props.videoPlaybackContext.viewportVideoAutoplayController else nil
	v21.viewportVideoAutoplayController = v28
	return createElement(videoPlaybackDetector, v21)
end

return GameVideoPlaybackDetector
