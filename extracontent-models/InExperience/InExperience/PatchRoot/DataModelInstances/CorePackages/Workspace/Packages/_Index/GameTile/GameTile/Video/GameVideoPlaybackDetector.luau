local GameTile = script:FindFirstAncestor("GameTile")
local GameTileParent = GameTile.Parent
local React = require(GameTileParent.React)
local RetrievalStatus = require(GameTileParent.Http).Enum.RetrievalStatus
local RoactNetworking = require(GameTileParent.RoactServiceTags).RoactNetworking
local RoactUtils = require(GameTileParent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useRoactService = require(GameTileParent.RobloxAppHooks).useRoactService
local useIsVideoEligible = require(GameTile.Video.useIsVideoEligible)
local usePreferredInput = require(GameTileParent.Responsive).usePreferredInput
local VideoUtils = require(GameTileParent.VideoUtils)
local getPlaybackDetectionMethod = VideoUtils.getPlaybackDetectionMethod
local VideoPlaybackDetector = VideoUtils.VideoPlaybackDetector
local VideoEndReason = VideoUtils.AnalyticsEnums.VideoEndReason
local useCanDevicePlayVideoPreview = VideoUtils.useCanDevicePlayVideoPreview
local FetchGamePlayabilityAndProductInfo = require(GameTileParent.GameDetailRodux).FetchGamePlayabilityAndProductInfo
local FFlagLuaAppEdpMediaGalleryVideoPreview = require(GameTileParent.SharedFlags).FFlagLuaAppEdpMediaGalleryVideoPreview
local FFlagLuaAppTileVideoDeviceMemoryBlocking = require(GameTileParent.SharedFlags).FFlagLuaAppTileVideoDeviceMemoryBlocking
local v20 = game:DefineFastFlag("LuaAppGameTileVideoManufacturerDeny", false)
local v21 = game:DefineFastFlag("LuaAppGameTileVideoDeviceDeny", false)
local v22 = game:DefineFastFlag("LuaAppGameTileVideoMaxMemoryDeny", false)
local v23 = game:DefineFastFlag("LuaAppGameTileVideoAvailableRamDeny", false)
local v24 = game:DefineFastInt("LuaAppGameTileVideoMaxMemoryThresholdMb", -1)
local v25 = game:DefineFastInt("LuaAppGameTileVideoAvailableRamThresholdMb", -1)
local v26 = game:DefineFastString("LuaAppGameTileVideoManufacturerPipeDenyList", "")
local v27 = game:DefineFastString("LuaAppGameTileVideoDevicePipeDenyList", "")
local FFlagLuaAppHomeTouchAutoplay = require(GameTileParent.SharedFlags).FFlagLuaAppHomeTouchAutoplay
local FFlagLuaAppUsePrevalidatedVideoGamePlayability = require(GameTileParent.SharedFlags).FFlagLuaAppUsePrevalidatedVideoGamePlayability
local FFlagLuaAppGameTileSelectionVideoPlayback = require(GameTileParent.SharedFlags).FFlagLuaAppGameTileSelectionVideoPlayback
local t1 = nil

if FFlagLuaAppTileVideoDeviceMemoryBlocking then
	t1 = {
		enableManufacturerDeny = v20,
		enableDeviceDeny = v21,
		enableMaxMemoryDeny = v22,
		enableAvailableRamDeny = v23,
		maxMemoryThresholdMb = v24,
		availableRamThresholdMb = v25,
		manufacturerDenyList = v26,
		deviceDenyList = v27
	}
end

local function GameVideoPlaybackDetector(t2: {[any]: any}) -- line: 80
	-- upvalues: useDispatch (copy), useRoactService (copy), RoactNetworking (copy), useSelector (copy), FetchGamePlayabilityAndProductInfo (copy), useIsVideoEligible (copy), FFlagLuaAppUsePrevalidatedVideoGamePlayability (copy), FFlagLuaAppTileVideoDeviceMemoryBlocking (copy), React (copy), useCanDevicePlayVideoPreview (copy), t1 (ref), RetrievalStatus (copy), VideoEndReason (copy), FFlagLuaAppGameTileSelectionVideoPlayback (copy), usePreferredInput (copy), getPlaybackDetectionMethod (copy), VideoPlaybackDetector (copy), FFlagLuaAppEdpMediaGalleryVideoPreview (copy), FFlagLuaAppHomeTouchAutoplay (copy)
	local v34 = useDispatch()
	local v35 = useRoactService(RoactNetworking)
	local v36 = useSelector(function(p1) -- line: 84
		-- upvalues: FetchGamePlayabilityAndProductInfo (copy), t2 (copy)
		return FetchGamePlayabilityAndProductInfo.GetFetchingStatus(p1, t2.universeId)
	end)
	local v37 = useIsVideoEligible(t2.universeId, if not FFlagLuaAppUsePrevalidatedVideoGamePlayability then nil else t2.hasPrevalidatedVideoGamePlayability)
	local u38 = nil
	local u39 = nil
	local v40 = nil

	if FFlagLuaAppTileVideoDeviceMemoryBlocking then
		local v41, v42 = React.useState(false)

		u38 = v42
		u39 = useCanDevicePlayVideoPreview(t1, t2.universeId, t2.pageContext)
		v40 = v37 and v41
	end

	local v43 = React.useCallback(function(p2) -- line: 105
		-- upvalues: t2 (copy), v36 (copy), RetrievalStatus (copy), VideoEndReason (copy)
		if t2.videoAnalytics and v36 == RetrievalStatus.Done then
			t2.videoAnalytics.reportVideoEnd(t2.itemIndex, VideoEndReason.PlayabilityCheckFailed, p2, -1)
		end
	end, {
		t2.videoAnalytics,
		v36
	})
	local v44 = React.useCallback(function() -- line: 112
		-- upvalues: v36 (copy), RetrievalStatus (copy), FFlagLuaAppUsePrevalidatedVideoGamePlayability (copy), t2 (copy), v34 (copy), FetchGamePlayabilityAndProductInfo (copy), v35 (copy), FFlagLuaAppTileVideoDeviceMemoryBlocking (copy), u38 (ref), u39 (ref)
		if (v36 == RetrievalStatus.NotStarted or v36 == RetrievalStatus.Failed) and (not FFlagLuaAppUsePrevalidatedVideoGamePlayability or not t2.hasPrevalidatedVideoGamePlayability) then
			v34(FetchGamePlayabilityAndProductInfo.Fetch(v35, t2.universeId))
		end

		if FFlagLuaAppTileVideoDeviceMemoryBlocking then
			u38(u39())
		end
	end, {
		t2.universeId,
		v36,
		v34,
		v35,
		u39,
		if not FFlagLuaAppUsePrevalidatedVideoGamePlayability then nil else t2.hasPrevalidatedVideoGamePlayability
	})
	local v45 = nil

	if FFlagLuaAppGameTileSelectionVideoPlayback then
		local v46 = usePreferredInput()

		v45 = getPlaybackDetectionMethod(v46, t2.isHoverSupported)
	end

	return React.createElement(VideoPlaybackDetector, {
		videoKey = t2.videoKey,
		itemIndex = t2.itemIndex,
		itemFrameRef = t2.tileRef,
		playbackDetectionMethod = if not FFlagLuaAppGameTileSelectionVideoPlayback then nil else v45,
		isHoverSupported = if not FFlagLuaAppGameTileSelectionVideoPlayback then t2.isHoverSupported else nil,
		isHovered = t2.isHovered,
		isSelected = if not FFlagLuaAppGameTileSelectionVideoPlayback then nil else t2.isSelected,
		autoplay = if not FFlagLuaAppGameTileSelectionVideoPlayback then if not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else t2.autoplay else nil,
		videoPlaybackCoordinator = if not FFlagLuaAppHomeTouchAutoplay or not t2.videoPlaybackContext then nil else t2.videoPlaybackContext.videoPlaybackCoordinator,
		onPlaybackChange = t2.onPlaybackChange,
		videoAnalytics = t2.videoAnalytics,
		videoDwellTimeInSec = t2.videoDwellTimeInSec,
		videoVisiblePercent = t2.videoVisiblePercent,
		isVideoEligible = if not FFlagLuaAppTileVideoDeviceMemoryBlocking then v37 else v40,
		onVideoIneligible = v43,
		onPlaybackCandidate = v44,
		viewportVideoAutoplayController = if not FFlagLuaAppHomeTouchAutoplay or not t2.videoPlaybackContext then nil else t2.videoPlaybackContext.viewportVideoAutoplayController
	})
end

return GameVideoPlaybackDetector
