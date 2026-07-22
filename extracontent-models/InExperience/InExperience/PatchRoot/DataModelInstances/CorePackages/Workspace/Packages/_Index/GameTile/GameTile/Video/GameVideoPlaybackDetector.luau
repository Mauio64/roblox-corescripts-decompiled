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

local function GameVideoPlaybackDetector(t2: {[any]: any}) -- line: 78
	-- upvalues: useDispatch (copy), useRoactService (copy), RoactNetworking (copy), useSelector (copy), FetchGamePlayabilityAndProductInfo (copy), useIsVideoEligible (copy), FFlagLuaAppUsePrevalidatedVideoGamePlayability (copy), FFlagLuaAppTileVideoDeviceMemoryBlocking (copy), React (copy), useCanDevicePlayVideoPreview (copy), t1 (ref), RetrievalStatus (copy), VideoEndReason (copy), FFlagLuaAppGameTileSelectionVideoPlayback (copy), usePreferredInput (copy), getPlaybackDetectionMethod (copy), VideoPlaybackDetector (copy), FFlagLuaAppEdpMediaGalleryVideoPreview (copy)
	local v33 = useDispatch()
	local v34 = useRoactService(RoactNetworking)
	local v35 = useSelector(function(p1) -- line: 82
		-- upvalues: FetchGamePlayabilityAndProductInfo (copy), t2 (copy)
		return FetchGamePlayabilityAndProductInfo.GetFetchingStatus(p1, t2.universeId)
	end)
	local v36 = useIsVideoEligible(t2.universeId, if not FFlagLuaAppUsePrevalidatedVideoGamePlayability then nil else t2.hasPrevalidatedVideoGamePlayability)
	local u37 = nil
	local u38 = nil
	local v39 = nil

	if FFlagLuaAppTileVideoDeviceMemoryBlocking then
		local v40, v41 = React.useState(false)

		u37 = v41
		u38 = useCanDevicePlayVideoPreview(t1, t2.universeId, t2.pageContext)
		v39 = v36 and v40
	end

	local v42 = React.useCallback(function(p2) -- line: 103
		-- upvalues: t2 (copy), v35 (copy), RetrievalStatus (copy), VideoEndReason (copy)
		if t2.videoAnalytics and v35 == RetrievalStatus.Done then
			t2.videoAnalytics.reportVideoEnd(t2.itemIndex, VideoEndReason.PlayabilityCheckFailed, p2, -1)
		end
	end, {
		t2.videoAnalytics,
		v35
	})
	local v43 = React.useCallback(function() -- line: 110
		-- upvalues: v35 (copy), RetrievalStatus (copy), FFlagLuaAppUsePrevalidatedVideoGamePlayability (copy), t2 (copy), v33 (copy), FetchGamePlayabilityAndProductInfo (copy), v34 (copy), FFlagLuaAppTileVideoDeviceMemoryBlocking (copy), u37 (ref), u38 (ref)
		if (v35 == RetrievalStatus.NotStarted or v35 == RetrievalStatus.Failed) and (not FFlagLuaAppUsePrevalidatedVideoGamePlayability or not t2.hasPrevalidatedVideoGamePlayability) then
			v33(FetchGamePlayabilityAndProductInfo.Fetch(v34, t2.universeId))
		end

		if FFlagLuaAppTileVideoDeviceMemoryBlocking then
			u37(u38())
		end
	end, {
		t2.universeId,
		v35,
		v33,
		v34,
		u38,
		if not FFlagLuaAppUsePrevalidatedVideoGamePlayability then nil else t2.hasPrevalidatedVideoGamePlayability
	})
	local v44 = nil

	if FFlagLuaAppGameTileSelectionVideoPlayback then
		local v45 = usePreferredInput()

		v44 = getPlaybackDetectionMethod(v45, t2.isHoverSupported)
	end

	return React.createElement(VideoPlaybackDetector, {
		videoKey = t2.videoKey,
		itemIndex = t2.itemIndex,
		itemFrameRef = t2.tileRef,
		playbackDetectionMethod = if not FFlagLuaAppGameTileSelectionVideoPlayback then nil else v44,
		isHoverSupported = if not FFlagLuaAppGameTileSelectionVideoPlayback then t2.isHoverSupported else nil,
		isHovered = t2.isHovered,
		isSelected = if not FFlagLuaAppGameTileSelectionVideoPlayback then nil else t2.isSelected,
		autoplay = if not FFlagLuaAppGameTileSelectionVideoPlayback then if not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else t2.autoplay else nil,
		videoPlaybackCoordinator = if not t2.videoPlaybackContext then nil else t2.videoPlaybackContext.videoPlaybackCoordinator,
		onPlaybackChange = t2.onPlaybackChange,
		videoAnalytics = t2.videoAnalytics,
		videoDwellTimeInSec = t2.videoDwellTimeInSec,
		videoVisiblePercent = t2.videoVisiblePercent,
		isVideoEligible = if not FFlagLuaAppTileVideoDeviceMemoryBlocking then v36 else v39,
		onVideoIneligible = v42,
		onPlaybackCandidate = v43,
		viewportVideoAutoplayController = if not t2.videoPlaybackContext then nil else t2.videoPlaybackContext.viewportVideoAutoplayController
	})
end

return GameVideoPlaybackDetector
