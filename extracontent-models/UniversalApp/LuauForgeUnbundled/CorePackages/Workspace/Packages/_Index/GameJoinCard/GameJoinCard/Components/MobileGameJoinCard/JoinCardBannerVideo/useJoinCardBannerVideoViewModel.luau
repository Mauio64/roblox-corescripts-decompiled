local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")
local useNavigationFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Navigation").useNavigationFocus
local VideoUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/VideoUtils")
local videoLogger = VideoUtils.VideoLogger
local videoPlaybackCoordinator = VideoUtils.VideoPlaybackCoordinator
local videoActions = VideoUtils.AnalyticsEnums.VideoActions
local videoEndReason = VideoUtils.AnalyticsEnums.VideoEndReason

local useAppLifecycleCallbacks = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Hooks/useAppLifecycleCallbacks")
require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/MobileGameJoinCard/JoinCardBannerVideo/JoinCardBannerVideoView")

local function useJoinCardBannerVideoViewModel(data)
	local v5 = useNavigationFocus()
	local state, setState = React.useState(false)
	local v6

	if data.videoPlaybackContext then
		v6 = data.videoPlaybackContext.videoPlaybackCoordinator
	else
		v6 = videoPlaybackCoordinator.default
	end

	local viewportVideoAutoplayController

	if data.videoPlaybackContext then
		viewportVideoAutoplayController = data.videoPlaybackContext.viewportVideoAutoplayController
	else
		viewportVideoAutoplayController = nil
	end

	local v7 = "game_join_card_banner_video_" .. data.videoId
	local state2, setState2 = React.useState(function(): boolean
		return v6.playingVideoKey == v7
	end)

	local v8 = v5 and state2

	React.useEffect(function()
		local function onPlayingVideoChanged(p2)
			setState2(p2 == v7)
		end

		local changedConnection = v6.changed:connect(onPlayingVideoChanged)
		setState2(v6.playingVideoKey == v7)

		return function()
			changedConnection:disconnect()
		end
	end, { v6, v7 })

	local v9 = React.useCallback(function()
		if v6.playingVideoKey == v7 then
			return
		end

		v6:reset(videoEndReason.OverlayTakeover)
		v6:requestPlayback(v7, false, 0)
	end, { v6, v7 })

	local v10 = React.useCallback(function()
		v6:cancelPlayback(v7, videoEndReason.AppBackgrounded)
	end, { v6, v7 })

	React.useEffect(function()
		if not v5 then
			return nil
		end

		v9()

		local thread = nil
		local changedConnection = v6.changed:connect(function(p2)
			if p2 == nil or p2 == v7 or thread ~= nil then
				return
			end

			thread = task.defer(function()
				thread = nil
				local playingVideoKey = v6.playingVideoKey

				if playingVideoKey ~= nil and playingVideoKey ~= v7 then
					v9()
				end
			end)
		end)

		return function()
			changedConnection:disconnect()

			if thread ~= nil then
				task.cancel(thread)
			end

			v6:cancelPlayback(v7, videoEndReason.OverlayTakeover)
		end
	end, { v6, v7, v5, v9 })

	if not v5 then
		v10 = nil
	end

	useAppLifecycleCallbacks(v10, if v5 then v9 else nil)

	React.useEffect(function()
		if viewportVideoAutoplayController == nil then
			return nil
		end

		return function()
			viewportVideoAutoplayController:reset("gameJoinCardClosed")
			viewportVideoAutoplayController:forceScheduleInitialWinnerUpdate()
		end
	end, { viewportVideoAutoplayController })

	local playbackSessionId = React.useMemo(function()
		return HttpService:GenerateGUID(false)
	end, { data.videoId, v8 })

	React.useEffect(function()
		setState(false)
	end, { data.videoId, v8 })

	local v13 = React.useMemo(function()
		return {
			videoAnalyticsData = { source = "GameJoinCard", sourceId = data.universeId },
			getPlaybackSessionId = function()
				return playbackSessionId
			end
		}
	end, { data.universeId, playbackSessionId })

	local v14 = React.useCallback(function(p2, p3)
		setState(true)
		videoLogger.reportVideoAction(videoActions.load, "GameJoinCard", {
			videoAssetId = data.videoId,
			source = "GameJoinCard",
			sourceId = data.universeId,
			playbackSessionId = playbackSessionId,
			videoAssetDuration = p2,
			isVisible = true,
			isAudible = false,
			volumeLevel = 0
		}, { loadTime = p3 })
	end, { data.videoId, data.universeId, playbackSessionId })

	return {
		video = `rbxassetid://{data.videoId}`,
		shouldStartPlayback = v8,
		isVisible = v8 and state,
		Size = data.Size,
		cornerRadius = data.cornerRadius,
		ZIndex = data.ZIndex,
		onActivated = data.onActivated,
		videoAnalyticsContext = v13,
		onVideoLoaded = v14
	}
end

return useJoinCardBannerVideoViewModel
