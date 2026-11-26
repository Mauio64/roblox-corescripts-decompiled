local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DataHydration")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SignalsReact")
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")

local tileVideoBlockingConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GameTile").TileVideoBlockingConfig

local VideoUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/VideoUtils")
local videoEndReason = VideoUtils.AnalyticsEnums.VideoEndReason
local isVideoEligibleForPlayability = VideoUtils.isVideoEligibleForPlayability
local useCanDevicePlayVideoPreview = VideoUtils.useCanDevicePlayVideoPreview

local SduiVideoThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiVideoThumbnail")
local useSduiVideoAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").useSduiVideoAnalytics

local fIntLuaAppGameTileVideoDwellTimeInSec = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FIntLuaAppGameTileVideoDwellTimeInSec
local fIntLuaAppGameTileVideoVisiblePercent = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FIntLuaAppGameTileVideoVisiblePercent

local function SduiGameVideoThumbnail(props)
	local playabilityStore = DataHydration.Game.getPlayabilityStore(false)
	local playability = playabilityStore.getPlayability(props.universeId)
	local v5 = SignalsReact.useSignalState(playability.data)
	local v6 = SignalsReact.useSignalState(playability.status) == DataHydration.DataStatus.Ready

	local v7 = useSduiVideoAnalytics(props.analyticsContext, props.sduiContext.appPage, {
		source = "universe",
		sourceId = props.universeId,
		universeId = props.universeId,
		placeId = props.placeId
	})

	local v8 = React.useCallback(function(p2)
		if v6 then
			v7.reportVideoEnd(nil, videoEndReason.PlayabilityCheckFailed, p2, -1)
		end
	end, { v7, v6 })

	local state, setState = React.useState(false)

	local v9 = useCanDevicePlayVideoPreview(
		tileVideoBlockingConfig,
		props.universeId,
		props.sduiContext.appPage
	)

	local v10 = React.useCallback(function()
		if not v6 then
			playabilityStore.fetchPlayability(props.universeId)
		end

		setState(v9())
	end, { props.universeId, v6, playabilityStore, v9 })

	return React.createElement(SduiVideoThumbnail, {
		sduiContext = props.sduiContext,
		videoPlayer = props.videoPlayer,
		imageComponent = props.imageComponent,
		videoPlaybackContext = props.sduiContext.videoPlaybackContext,
		isVideoEligible = isVideoEligibleForPlayability(v6, v5, nil) and state,
		onVideoIneligible = v8,
		onPlaybackCandidate = v10,
		videoAnalytics = v7,
		videoDwellTimeInSec = fIntLuaAppGameTileVideoDwellTimeInSec,
		videoVisiblePercent = fIntLuaAppGameTileVideoVisiblePercent,
		isHovered = props.isHovered,
		isSelected = props.isSelected,
		cornerRadius = props.cornerRadius,
		playbackCandidateRef = props.playbackCandidateRef
	})
end

return SduiGameVideoThumbnail
