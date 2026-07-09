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
local VideoUtils = require(GameTileParent.VideoUtils)
local VideoPlaybackDetector = VideoUtils.VideoPlaybackDetector
local VideoEndReason = VideoUtils.AnalyticsEnums.VideoEndReason
local useCanDevicePlayVideoPreview = VideoUtils.useCanDevicePlayVideoPreview
local FetchGamePlayabilityAndProductInfo = require(GameTileParent.GameDetailRodux).FetchGamePlayabilityAndProductInfo
local FFlagLuaAppEdpMediaGalleryVideoPreview = require(GameTileParent.SharedFlags).FFlagLuaAppEdpMediaGalleryVideoPreview
local FFlagLuaAppTileVideoDeviceMemoryBlocking = require(GameTileParent.SharedFlags).FFlagLuaAppTileVideoDeviceMemoryBlocking
local v18 = game:DefineFastFlag("LuaAppGameTileVideoManufacturerDeny", false)
local v19 = game:DefineFastFlag("LuaAppGameTileVideoDeviceDeny", false)
local v20 = game:DefineFastFlag("LuaAppGameTileVideoMaxMemoryDeny", false)
local v21 = game:DefineFastFlag("LuaAppGameTileVideoAvailableRamDeny", false)
local v22 = game:DefineFastInt("LuaAppGameTileVideoMaxMemoryThresholdMb", -1)
local v23 = game:DefineFastInt("LuaAppGameTileVideoAvailableRamThresholdMb", -1)
local v24 = game:DefineFastString("LuaAppGameTileVideoManufacturerPipeDenyList", "")
local v25 = game:DefineFastString("LuaAppGameTileVideoDevicePipeDenyList", "")
local FFlagLuaAppHomeTouchAutoplay = require(GameTileParent.SharedFlags).FFlagLuaAppHomeTouchAutoplay
local FFlagLuaAppUsePrevalidatedVideoGamePlayability = require(GameTileParent.SharedFlags).FFlagLuaAppUsePrevalidatedVideoGamePlayability
local t1 = nil

if FFlagLuaAppTileVideoDeviceMemoryBlocking then
	t1 = {
		enableManufacturerDeny = v18,
		enableDeviceDeny = v19,
		enableMaxMemoryDeny = v20,
		enableAvailableRamDeny = v21,
		maxMemoryThresholdMb = v22,
		availableRamThresholdMb = v23,
		manufacturerDenyList = v24,
		deviceDenyList = v25
	}
end

local function GameVideoPlaybackDetector(t2: {[any]: any}) -- line: 73
	-- upvalues: useDispatch (copy), useRoactService (copy), RoactNetworking (copy), useSelector (copy), FetchGamePlayabilityAndProductInfo (copy), useIsVideoEligible (copy), FFlagLuaAppUsePrevalidatedVideoGamePlayability (copy), FFlagLuaAppTileVideoDeviceMemoryBlocking (copy), React (copy), useCanDevicePlayVideoPreview (copy), t1 (ref), RetrievalStatus (copy), VideoEndReason (copy), VideoPlaybackDetector (copy), FFlagLuaAppEdpMediaGalleryVideoPreview (copy), FFlagLuaAppHomeTouchAutoplay (copy)
	local v31 = useDispatch()
	local v32 = useRoactService(RoactNetworking)
	local v33 = useSelector(function(p1) -- line: 77
		-- upvalues: FetchGamePlayabilityAndProductInfo (copy), t2 (copy)
		return FetchGamePlayabilityAndProductInfo.GetFetchingStatus(p1, t2.universeId)
	end)
	local v34 = useIsVideoEligible(t2.universeId, if not FFlagLuaAppUsePrevalidatedVideoGamePlayability then nil else t2.hasPrevalidatedVideoGamePlayability)
	local u35 = nil
	local u36 = nil
	local v37 = nil

	if FFlagLuaAppTileVideoDeviceMemoryBlocking then
		local v38, v39 = React.useState(false)

		u35 = v39
		u36 = useCanDevicePlayVideoPreview(t1, t2.universeId, t2.pageContext)
		v37 = v34 and v38
	end

	local v40 = React.useCallback(function(p2) -- line: 98
		-- upvalues: t2 (copy), v33 (copy), RetrievalStatus (copy), VideoEndReason (copy)
		if t2.videoAnalytics and v33 == RetrievalStatus.Done then
			t2.videoAnalytics.reportVideoEnd(t2.itemIndex, VideoEndReason.PlayabilityCheckFailed, p2, -1)
		end
	end, {
		t2.videoAnalytics,
		v33
	})
	local v41 = React.useCallback(function() -- line: 105
		-- upvalues: v33 (copy), RetrievalStatus (copy), FFlagLuaAppUsePrevalidatedVideoGamePlayability (copy), t2 (copy), v31 (copy), FetchGamePlayabilityAndProductInfo (copy), v32 (copy), FFlagLuaAppTileVideoDeviceMemoryBlocking (copy), u35 (ref), u36 (ref)
		if (v33 == RetrievalStatus.NotStarted or v33 == RetrievalStatus.Failed) and (not FFlagLuaAppUsePrevalidatedVideoGamePlayability or not t2.hasPrevalidatedVideoGamePlayability) then
			v31(FetchGamePlayabilityAndProductInfo.Fetch(v32, t2.universeId))
		end

		if FFlagLuaAppTileVideoDeviceMemoryBlocking then
			u35(u36())
		end
	end, {
		t2.universeId,
		v33,
		v31,
		v32,
		u36,
		if not FFlagLuaAppUsePrevalidatedVideoGamePlayability then nil else t2.hasPrevalidatedVideoGamePlayability
	})

	return React.createElement(VideoPlaybackDetector, {
		videoKey = t2.videoKey,
		itemIndex = t2.itemIndex,
		itemFrameRef = t2.tileRef,
		isHoverSupported = t2.isHoverSupported,
		isHovered = t2.isHovered,
		autoplay = if not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else t2.autoplay,
		videoPlaybackCoordinator = if not FFlagLuaAppHomeTouchAutoplay or not t2.videoPlaybackContext then nil else t2.videoPlaybackContext.videoPlaybackCoordinator,
		onPlaybackChange = t2.onPlaybackChange,
		videoAnalytics = t2.videoAnalytics,
		videoDwellTimeInSec = t2.videoDwellTimeInSec,
		videoVisiblePercent = t2.videoVisiblePercent,
		isVideoEligible = if not FFlagLuaAppTileVideoDeviceMemoryBlocking then v34 else v37,
		onVideoIneligible = v40,
		onPlaybackCandidate = v41,
		viewportVideoAutoplayController = if not FFlagLuaAppHomeTouchAutoplay or not t2.videoPlaybackContext then nil else t2.videoPlaybackContext.viewportVideoAutoplayController
	})
end

return GameVideoPlaybackDetector
