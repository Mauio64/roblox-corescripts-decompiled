local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local VideoUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/VideoUtils")
local videoPlayer = VideoUtils.VideoPlayer
local videoPlaybackCoordinator = VideoUtils.VideoPlaybackCoordinator

require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileTypes")

local fFlagLuaAppEdpMediaGalleryFullScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppEdpMediaGalleryFullScreen
local fFlagLuaAppVideoTileDisableActivation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppVideoTileDisableActivation
local fFlagLuaAppVideoTileHideCenterPlayButton = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppVideoTileHideCenterPlayButton
local fFlagLuaAppHomeMomentVideoFallback = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppHomeMomentVideoFallback

local function GameTileVideoThumbnail(props)
	local v5 = React.useCallback(function(p2, p3)
		if props.videoAnalytics then
			local reportVideoLoad = props.videoAnalytics.reportVideoLoad
			local itemIndex = props.itemIndex
			local v6 = if props.videoPlaybackCoordinator then props.videoPlaybackCoordinator.currentPlaybackSessionId else videoPlaybackCoordinator.default.currentPlaybackSessionId
			reportVideoLoad(itemIndex, v6, p2, p3)
		end
	end, { props.itemIndex, props.videoAnalytics, props.videoPlaybackCoordinator })

	local v6 = React.useCallback(function()
		if props.videoAnalytics then
			local reportVideoLoop = props.videoAnalytics.reportVideoLoop
			local itemIndex = props.itemIndex
			local v7 = if props.videoPlaybackCoordinator then props.videoPlaybackCoordinator.currentPlaybackSessionId else videoPlaybackCoordinator.default.currentPlaybackSessionId
			reportVideoLoop(itemIndex, v7)
		end
	end, { props.itemIndex, props.videoAnalytics, props.videoPlaybackCoordinator })

	local v7 = React.useMemo(function()
		return {
			videoAnalyticsData = { source = "universe", sourceId = props.universeId },
			getPlaybackSessionId = function()
				if props.videoPlaybackCoordinator then
					return props.videoPlaybackCoordinator.currentPlaybackSessionId
				end

				return videoPlaybackCoordinator.default.currentPlaybackSessionId
			end
		}
	end, { props.universeId, props.videoPlaybackCoordinator })

	local createElement = React.createElement
	local v9 = {
		video = props.video,
		accessContext = 0,
		thumbnail = 0,
		shouldStartPlayback = 0,
		muted = true,
		looped = 0,
		Size = 0,
		ScaleType = 0,
		ZIndex = 0,
		cornerRadius = 0,
		hideCenterPlayButton = 0,
		disableActivation = 0,
		onVideoLoaded = 0,
		onVideoLooped = 0,
		onVideoPlayerActivated = 0,
		videoAnalyticsContext = 0
	}
	local v10 = if fFlagLuaAppHomeMomentVideoFallback then props.accessContext else nil
	v9.accessContext = v10
	v9.thumbnail = props.image
	v9.shouldStartPlayback = props.playing

	v9.looped = props.looped
	v9.Size = props.Size
	local v11 = if props.isTileContained then Enum.ScaleType.Tile else nil
	v9.ScaleType = v11
	v9.ZIndex = props.ZIndex
	v9.cornerRadius = props.cornerRadius
	v9.hideCenterPlayButton = fFlagLuaAppVideoTileHideCenterPlayButton and true or nil
	v9.disableActivation = fFlagLuaAppVideoTileDisableActivation and true or nil
	v9.onVideoLoaded = v5
	v9.onVideoLooped = v6

	local v12 = if not (fFlagLuaAppVideoTileDisableActivation or not fFlagLuaAppEdpMediaGalleryFullScreen) then props.onActivated else nil
	v9.onVideoPlayerActivated = v12

	v9.videoAnalyticsContext = v7
	return createElement(videoPlayer, v9)
end

return GameTileVideoThumbnail
