local GameTile = script:FindFirstAncestor("GameTile")

local parent = GameTile.Parent
local React = require(parent.React)
local VideoUtils = require(parent.VideoUtils)
local VideoPlayer = VideoUtils.VideoPlayer
local VideoPlaybackCoordinator = VideoUtils.VideoPlaybackCoordinator

require(GameTile.GameTileTypes)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEdpMediaGalleryFullScreen = SharedFlags.FFlagLuaAppEdpMediaGalleryFullScreen
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppVideoTileDisableActivation = SharedFlags2.FFlagLuaAppVideoTileDisableActivation
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppVideoTileHideCenterPlayButton = SharedFlags3.FFlagLuaAppVideoTileHideCenterPlayButton
local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppHomeMomentVideoFallback = SharedFlags4.FFlagLuaAppHomeMomentVideoFallback

local function GameTileVideoThumbnail(props)
	local onVideoLoaded = React.useCallback(function(p: number, p2: number)
		if props.videoAnalytics then
			local reportVideoLoad = props.videoAnalytics.reportVideoLoad
			local itemIndex = props.itemIndex
			local v

			if props.videoPlaybackCoordinator then
				v = props.videoPlaybackCoordinator.currentPlaybackSessionId
			else
				v = VideoPlaybackCoordinator.default.currentPlaybackSessionId
			end

			reportVideoLoad(itemIndex, v, p, p2)
		end
	end, { props.itemIndex, props.videoAnalytics, props.videoPlaybackCoordinator })

	local onVideoLooped = React.useCallback(function()
		if props.videoAnalytics then
			local reportVideoLoop = props.videoAnalytics.reportVideoLoop
			local itemIndex = props.itemIndex
			local v

			if props.videoPlaybackCoordinator then
				v = props.videoPlaybackCoordinator.currentPlaybackSessionId
			else
				v = VideoPlaybackCoordinator.default.currentPlaybackSessionId
			end

			reportVideoLoop(itemIndex, v)
		end
	end, { props.itemIndex, props.videoAnalytics, props.videoPlaybackCoordinator })

	local videoAnalyticsContext = React.useMemo(function()
		return {
			videoAnalyticsData = { source = "universe", sourceId = props.universeId },
			getPlaybackSessionId = function()
				if props.videoPlaybackCoordinator then
					return props.videoPlaybackCoordinator.currentPlaybackSessionId
				end

				return VideoPlaybackCoordinator.default.currentPlaybackSessionId
			end
		}
	end, { props.universeId, props.videoPlaybackCoordinator })

	local createElement = React.createElement
	local v = {
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
	local accessContext

	if FFlagLuaAppHomeMomentVideoFallback then
		accessContext = props.accessContext
	end

	v.accessContext = accessContext
	v.thumbnail = props.image
	v.shouldStartPlayback = props.playing

	v.looped = props.looped
	v.Size = props.Size
	local scaleType

	if props.isTileContained then
		scaleType = Enum.ScaleType.Tile
	end

	v.ScaleType = scaleType
	v.ZIndex = props.ZIndex
	v.cornerRadius = props.cornerRadius
	v.hideCenterPlayButton = FFlagLuaAppVideoTileHideCenterPlayButton and true or nil
	v.disableActivation = FFlagLuaAppVideoTileDisableActivation and true or nil
	v.onVideoLoaded = onVideoLoaded
	v.onVideoLooped = onVideoLooped
	local onVideoPlayerActivated

	if not (FFlagLuaAppVideoTileDisableActivation or not FFlagLuaAppEdpMediaGalleryFullScreen) then
		onVideoPlayerActivated = props.onActivated
	end

	v.onVideoPlayerActivated = onVideoPlayerActivated

	v.videoAnalyticsContext = videoAnalyticsContext
	return createElement(VideoPlayer, v)
end

return GameTileVideoThumbnail
