local GameJoinCard = script:FindFirstAncestor("GameJoinCard")
local parent = GameJoinCard.Parent

local HttpService = game:GetService("HttpService")

local React = require(parent.React)
local Navigation = require(parent.Navigation)
local useNavigationFocus = Navigation.useNavigationFocus
local VideoUtils = require(parent.VideoUtils)
local VideoLogger = VideoUtils.VideoLogger
local VideoPlaybackCoordinator = VideoUtils.VideoPlaybackCoordinator
local VideoActions = VideoUtils.AnalyticsEnums.VideoActions
local VideoEndReason = VideoUtils.AnalyticsEnums.VideoEndReason

local useAppLifecycleCallbacks = require(GameJoinCard.Hooks.useAppLifecycleCallbacks)
require(script.Parent.JoinCardBannerVideoView)

local function useJoinCardBannerVideoViewModel(data)
	local v = useNavigationFocus()
	local state, setState = React.useState(false)
	local v2

	if data.videoPlaybackContext then
		v2 = data.videoPlaybackContext.videoPlaybackCoordinator
	else
		v2 = VideoPlaybackCoordinator.default
	end

	local viewportVideoAutoplayController

	if data.videoPlaybackContext then
		viewportVideoAutoplayController = data.videoPlaybackContext.viewportVideoAutoplayController
	else
		viewportVideoAutoplayController = nil
	end

	local v3 = "game_join_card_banner_video_" .. data.videoId
	local state2, setState2 = React.useState(function(): boolean
		return v2.playingVideoKey == v3
	end)

	local shouldStartPlayback = v and state2

	React.useEffect(function()
		local function onPlayingVideoChanged(playingVideoKey: string?) -- 1 equivalent call inferred from this helper
			setState2(playingVideoKey == v3)
		end

		local changedConnection = v2.changed:connect(onPlayingVideoChanged)
		onPlayingVideoChanged(v2.playingVideoKey) -- inferred equivalent call

		return function()
			changedConnection:disconnect()
		end
	end, { v2, v3 })

	local v4 = React.useCallback(function()
		if v2.playingVideoKey == v3 then
			return
		end

		v2:reset(VideoEndReason.OverlayTakeover)
		v2:requestPlayback(v3, false, 0)
	end, { v2, v3 })

	local v5 = React.useCallback(function()
		v2:cancelPlayback(v3, VideoEndReason.AppBackgrounded)
	end, { v2, v3 })

	React.useEffect(function()
		if not v then
			return nil
		end

		v4()

		local thread = nil
		local changedConnection = v2.changed:connect(function(p: string?)
			if p == nil or p == v3 or thread ~= nil then
				return
			end

			thread = task.defer(function()
				thread = nil
				local playingVideoKey = v2.playingVideoKey

				if playingVideoKey ~= nil and playingVideoKey ~= v3 then
					v4()
				end
			end)
		end)

		return function()
			changedConnection:disconnect()

			if thread ~= nil then
				task.cancel(thread)
			end

			v2:cancelPlayback(v3, VideoEndReason.OverlayTakeover)
		end
	end, { v2, v3, v, v4 })

	if not v then
		v5 = nil
	end

	local v6

	if v then
		v6 = v4
	end

	useAppLifecycleCallbacks(v5, v6)

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
	end, { data.videoId, shouldStartPlayback })

	React.useEffect(function()
		setState(false)
	end, { data.videoId, shouldStartPlayback })

	local videoAnalyticsContext = React.useMemo(function()
		return {
			videoAnalyticsData = { source = "GameJoinCard", sourceId = data.universeId },
			getPlaybackSessionId = function()
				return playbackSessionId
			end
		}
	end, { data.universeId, playbackSessionId })

	local onVideoLoaded = React.useCallback(function(videoAssetDuration: number, loadTime: number)
		setState(true)
		VideoLogger.reportVideoAction(VideoActions.load, "GameJoinCard", {
			videoAssetId = data.videoId,
			source = "GameJoinCard",
			sourceId = data.universeId,
			playbackSessionId = playbackSessionId,
			videoAssetDuration = videoAssetDuration,
			isVisible = true,
			isAudible = false,
			volumeLevel = 0
		}, { loadTime = loadTime })
	end, { data.videoId, data.universeId, playbackSessionId })

	return {
		video = `rbxassetid://{data.videoId}`,
		shouldStartPlayback = shouldStartPlayback,
		isVisible = shouldStartPlayback and state,
		Size = data.Size,
		cornerRadius = data.cornerRadius,
		ZIndex = data.ZIndex,
		onActivated = data.onActivated,
		videoAnalyticsContext = videoAnalyticsContext,
		onVideoLoaded = onVideoLoaded
	}
end

return useJoinCardBannerVideoViewModel
