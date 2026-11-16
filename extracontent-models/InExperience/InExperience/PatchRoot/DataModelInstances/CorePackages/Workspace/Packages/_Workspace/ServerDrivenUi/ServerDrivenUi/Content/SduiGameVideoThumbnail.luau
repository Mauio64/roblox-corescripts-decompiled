local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local DataHydration = require(parent.DataHydration)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
require(parent.SduiCoreSystem)

local GameTile = require(parent.GameTile)
local TileVideoBlockingConfig = GameTile.TileVideoBlockingConfig

local VideoUtils = require(parent.VideoUtils)
local VideoEndReason = VideoUtils.AnalyticsEnums.VideoEndReason
local isVideoEligibleForPlayability = VideoUtils.isVideoEligibleForPlayability
local useCanDevicePlayVideoPreview = VideoUtils.useCanDevicePlayVideoPreview

local SduiVideoThumbnail = require(script.Parent.SduiVideoThumbnail)
local SduiSharedContent = require(parent.SduiSharedContent)
local useSduiVideoAnalytics = SduiSharedContent.useSduiVideoAnalytics

local SharedFlags = require(parent.SharedFlags)
local FIntLuaAppGameTileVideoDwellTimeInSec = SharedFlags.FIntLuaAppGameTileVideoDwellTimeInSec
local SharedFlags2 = require(parent.SharedFlags)
local FIntLuaAppGameTileVideoVisiblePercent = SharedFlags2.FIntLuaAppGameTileVideoVisiblePercent

local function SduiGameVideoThumbnail(props)
	local playabilityStore = DataHydration.Game.getPlayabilityStore(false)
	local playability = playabilityStore.getPlayability(props.universeId)
	local v = SignalsReact.useSignalState(playability.data)
	local v2 = SignalsReact.useSignalState(playability.status) == DataHydration.DataStatus.Ready

	local videoAnalytics = useSduiVideoAnalytics(props.analyticsContext, props.sduiContext.appPage, {
		source = "universe",
		sourceId = props.universeId,
		universeId = props.universeId,
		placeId = props.placeId
	})

	local onVideoIneligible = React.useCallback(function(p: string?)
		if v2 then
			videoAnalytics.reportVideoEnd(nil, VideoEndReason.PlayabilityCheckFailed, p, -1)
		end
	end, { videoAnalytics, v2 })

	local state, setState = React.useState(false)

	local v3 = useCanDevicePlayVideoPreview(TileVideoBlockingConfig, props.universeId, props.sduiContext.appPage)

	local onPlaybackCandidate = React.useCallback(function()
		if not v2 then
			playabilityStore.fetchPlayability(props.universeId)
		end

		setState(v3())
	end, { props.universeId, v2, playabilityStore, v3 })

	return React.createElement(SduiVideoThumbnail, {
		sduiContext = props.sduiContext,
		videoPlayer = props.videoPlayer,
		imageComponent = props.imageComponent,
		videoPlaybackContext = props.sduiContext.videoPlaybackContext,
		isVideoEligible = isVideoEligibleForPlayability(v2, v, nil) and state,
		onVideoIneligible = onVideoIneligible,
		onPlaybackCandidate = onPlaybackCandidate,
		videoAnalytics = videoAnalytics,
		videoDwellTimeInSec = FIntLuaAppGameTileVideoDwellTimeInSec,
		videoVisiblePercent = FIntLuaAppGameTileVideoVisiblePercent,
		isHovered = props.isHovered,
		isSelected = props.isSelected,
		cornerRadius = props.cornerRadius,
		playbackCandidateRef = props.playbackCandidateRef
	})
end

return SduiGameVideoThumbnail
