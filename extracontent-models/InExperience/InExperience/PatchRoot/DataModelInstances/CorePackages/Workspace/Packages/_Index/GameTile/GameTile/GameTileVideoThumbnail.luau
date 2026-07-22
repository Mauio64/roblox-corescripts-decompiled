local GameTile = script:FindFirstAncestor("GameTile")
local GameTileParent = GameTile.Parent
local React = require(GameTileParent.React)
local VideoUtils = require(GameTileParent.VideoUtils)
local VideoPlayer = VideoUtils.VideoPlayer
local VideoPlaybackCoordinator = VideoUtils.VideoPlaybackCoordinator

require(GameTile.GameTileTypes)

local FFlagLuaAppEdpMediaGalleryFullScreen = require(GameTileParent.SharedFlags).FFlagLuaAppEdpMediaGalleryFullScreen
local FFlagLuaAppVideoTileDisableActivation = require(GameTileParent.SharedFlags).FFlagLuaAppVideoTileDisableActivation
local FFlagLuaAppVideoTileHideCenterPlayButton = require(GameTileParent.SharedFlags).FFlagLuaAppVideoTileHideCenterPlayButton

local function GameTileVideoThumbnail(t1: {[any]: any}) -- line: 37
	-- upvalues: React (copy), VideoPlaybackCoordinator (copy), VideoPlayer (copy), FFlagLuaAppVideoTileHideCenterPlayButton (copy), FFlagLuaAppVideoTileDisableActivation (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy)
	local v12 = React.useCallback(function(n1: number, n2: number) -- line: 39
		-- upvalues: t1 (copy), VideoPlaybackCoordinator (copy)
		if t1.videoAnalytics then
			t1.videoAnalytics.reportVideoLoad(t1.itemIndex, if not t1.videoPlaybackCoordinator then VideoPlaybackCoordinator.default.currentPlaybackSessionId else t1.videoPlaybackCoordinator.currentPlaybackSessionId, n1, n2)
		end
	end, {
		t1.itemIndex,
		t1.videoAnalytics,
		t1.videoPlaybackCoordinator
	})
	local v13 = React.useCallback(function() -- line: 59
		-- upvalues: t1 (copy), VideoPlaybackCoordinator (copy)
		if t1.videoAnalytics then
			t1.videoAnalytics.reportVideoLoop(t1.itemIndex, if not t1.videoPlaybackCoordinator then VideoPlaybackCoordinator.default.currentPlaybackSessionId else t1.videoPlaybackCoordinator.currentPlaybackSessionId)
		end
	end, {
		t1.itemIndex,
		t1.videoAnalytics,
		t1.videoPlaybackCoordinator
	})
	local v14 = React.useMemo(function() -- line: 76
		-- upvalues: t1 (copy), VideoPlaybackCoordinator (copy)
		return {
			videoAnalyticsData = {
				source = "universe",
				sourceId = t1.universeId
			},
			getPlaybackSessionId = function() -- line: 82
				-- upvalues: t1 (copy), VideoPlaybackCoordinator (copy)
				if t1.videoPlaybackCoordinator then
					return t1.videoPlaybackCoordinator.currentPlaybackSessionId
				end

				return VideoPlaybackCoordinator.default.currentPlaybackSessionId
			end
		}
	end, {
		t1.universeId,
		t1.videoPlaybackCoordinator
	})

	return React.createElement(VideoPlayer, {
		muted = true,
		video = t1.video,
		thumbnail = t1.image,
		shouldStartPlayback = t1.playing,
		looped = t1.looped,
		Size = t1.Size,
		ScaleType = if not t1.isTileContained then nil else Enum.ScaleType.Tile,
		ZIndex = t1.ZIndex,
		cornerRadius = t1.cornerRadius,
		hideCenterPlayButton = not not FFlagLuaAppVideoTileHideCenterPlayButton or nil,
		disableActivation = not not FFlagLuaAppVideoTileDisableActivation or nil,
		onVideoLoaded = v12,
		onVideoLooped = v13,
		onVideoPlayerActivated = if not FFlagLuaAppVideoTileDisableActivation then if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else t1.onActivated else nil,
		videoAnalyticsContext = v14
	})
end

return GameTileVideoThumbnail
