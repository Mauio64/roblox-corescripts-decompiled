local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Foundation")
local MediaPlayback = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/MediaPlayback")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/React")
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/ReactUtils")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/SignalsReact")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Localization").Hooks.useLocalization

local RoundIconButton = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Components/RoundIconButton")
local AudioPlaybackTimeline = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Components/AudioPlaybackTimeline")
require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/types")
local AnalyticActions = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Analytics/AnalyticActions")
local sendAudioPlayerAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Analytics/sendAudioPlayerAnalytics")
local useStopSongOnPageNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Hooks/useStopSongOnPageNavigation")

local getFFlagAudioPlayerCanSkipTracks = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/SharedFlags").GetFFlagAudioPlayerCanSkipTracks
local getFFlagAudioPreviewLua = MediaPlayback.getFFlagAudioPreviewLua

local getAudioPlaybackStore = MediaPlayback.getAudioPlaybackStore
local useAudioStore = MediaPlayback.useAudioStore
local useCallback = React.useCallback
local useRef = React.useRef
local useEffect = React.useEffect
local createNextOrder = ReactUtils.createNextOrder
local usePrevious = ReactUtils.usePrevious
local useSignalState = SignalsReact.useSignalState
local useSignalBinding = SignalsReact.useSignalBinding

local v5 = { isNavigationFocus = true }

local vector2 = Vector2.new(320, 320)

local function AudioPlayer(p2)
	local joined = Cryo.Dictionary.join(v5, p2)

	local nextOrder = createNextOrder()

	local v6 = useLocalization({ songPreview = "Feature.SongDetails.Label.SongPreview" })

	local assetId = joined.audio.assetId
	local v8 = if getFFlagAudioPreviewLua() then joined.audio.isPrivate else nil
	local v9 = useAudioStore(assetId, v8)
	local v10 = useSignalState(v9.getIsPlaying)
	local v11 = useSignalState(v9.getIsElapsed)
	local v12 = useSignalState(v9.getDuration)
	local v13 = useSignalBinding(v9.getElapsed)

	local v14 = if getFFlagAudioPlayerCanSkipTracks() then useSignalState(getAudioPlaybackStore) else nil

	local v15 = if getFFlagAudioPlayerCanSkipTracks() then useSignalState(v14.hasNextSong) else nil

	local v16 = if getFFlagAudioPlayerCanSkipTracks() then useSignalState(v14.hasPrevSong) else nil

	local v17 = v15 or v16

	local v18 = useCallback(function(p3)
		local v19 = joined.audio.assetId:gsub("rbxassetid://", "")
		local v20 = if joined.audio.thumbnailAssetId then joined.audio.thumbnailAssetId:gsub("rbxassetid://", "") else nil

		sendAudioPlayerAnalytics({
			action = p3,
			songId = v19,
			thumbnailId = v20 or "-1",
			source = joined.analyticsSource,
			listenDurationSeconds = v13:getValue()
		})
	end, { joined.audio.assetId, joined.audio.thumbnail, joined.analyticsSource, v13 })

	local v19 = useCallback(function()
		v18(AnalyticActions.AudioElapsed)
		v18(AnalyticActions.AudioStopped)
	end, { v18 })

	local v20 = useRef(false)

	local v21 = useCallback(function()
		v20.current = v10
		v9.pause()
	end, { v9.pause, v10 })

	local v22 = useCallback(function(p3)
		v9.seek(v12 * p3)
	end, { v9.seek, v12 })

	local v23 = useCallback(function()
		if v20.current then
			v9.play()
		end
	end, { v9.play })

	local function fn()
		if v10 then
			v18(AnalyticActions.AudioPause)
			v18(AnalyticActions.AudioStopped)
			v9.pause()
		else
			v18(AnalyticActions.AudioPlay)

			if getFFlagAudioPlayerCanSkipTracks() then
				v14.pauseAll()
			else
				getAudioPlaybackStore(false).pauseAll()
			end

			v9.play()
		end
	end

	local play = v9.play
	local pause = v9.pause

	local v26 = if getFFlagAudioPlayerCanSkipTracks() then v14 else nil
	local v27 = useCallback(fn, { play, pause, v10, v26 })

	local v28 = useCallback(function()
		v18(AnalyticActions.AudioStopped)
	end, { v18 })
	useStopSongOnPageNavigation(joined.isNavigationFocus, v28)

	local v29 = usePrevious(v11)
	useEffect(function()
		if v11 and not v29 then
			v19()
		end
	end, { v11 })

	local createElement = React.createElement
	local view = Foundation.View
	local v30 = {
		tag = "auto-xy col align-x-center gap-large",
		LayoutOrder = joined.LayoutOrder
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local v32 = {
		AlbumArt = React.createElement(Foundation.Image, {
			tag = "size-full shrink bg-surface-100 radius-medium",
			sizeConstraint = { MaxSize = vector2 },
			aspectRatio = 1,
			Image = joined.audio.thumbnail,
			LayoutOrder = nextOrder()
		}),
		Info = 0
	}

	local createElement3 = React.createElement
	local view3 = Foundation.View
	local v33 = {
		tag = "size-full-0 auto-y grow col align-x-center gap-medium",
		LayoutOrder = nextOrder()
	}
	local v34 = {
		Title = React.createElement(Foundation.Text, {
			tag = "auto-xy text-heading-small content-emphasis text-truncate-end",
			Text = joined.audio.title,
			LayoutOrder = nextOrder()
		}),
		Artist = 0,
		ArtistRow = 0
	}

	local v35 = if not getFFlagAudioPreviewLua() then React.createElement(Foundation.Text, {
		tag = "auto-xy text-body-large content-default text-truncate-end",
		Text = joined.audio.artist,
		LayoutOrder = nextOrder()
	}) else nil
	v34.Artist = v35
	local v36

	if getFFlagAudioPreviewLua() then
		local createElement4 = React.createElement
		local view4 = Foundation.View
		local v37 = {
			tag = "row align-x-center align-y-center gap-xsmall auto-xy",
			LayoutOrder = nextOrder()
		}
		local v38 = {
			Artist = React.createElement(Foundation.Text, {
				tag = "auto-xy text-body-large text-truncate-end content-default",
				Text = joined.audio.artist,
				LayoutOrder = 1
			}),
			SongPreviewSeparator = 0,
			SongPreviewLabel = 0
		}

		local v39 = if joined.audio.isPrivate then React.createElement(Foundation.Text, {
			tag = "auto-xy text-body-large content-default",
			Text = "·",
			LayoutOrder = 2
		}) else nil
		v38.SongPreviewSeparator = v39

		local v40 = if joined.audio.isPrivate then React.createElement(Foundation.Text, {
			tag = "auto-xy text-body-large content-default",
			Text = v6.songPreview,
			LayoutOrder = 3
		}) else nil
		v38.SongPreviewLabel = v40
		v36 = createElement4(view4, v37, v38)
	end

	v34.ArtistRow = v36
	v32.Info = createElement3(view3, v33, v34)
	local children = {
		AudioDetails = createElement2(
			view2,
			{ tag = "size-full-0 auto-y col align-x-center gap-xlarge" },
			v32
		),
		PlaybackProgress = React.createElement(AudioPlaybackTimeline, {
			LayoutOrder = nextOrder(),
			duration = v12,
			elapsed = v13,
			onDragTimeline = v22,
			onDragTimelineStart = v21,
			onDragTimelineEnd = v23
		}),
		PlaybackControls = 0
	}

	local createElement4 = React.createElement
	local view4 = Foundation.View
	local v37 = {
		tag = "auto-xy row gap-medium align-y-center",
		LayoutOrder = nextOrder()
	}

	local v39 = if getFFlagAudioPlayerCanSkipTracks() and v17 then React.createElement(Foundation.IconButton, {
		icon = Foundation.Enums.IconName.SkipStartLarge,
		isDisabled = not v16,
		onActivated = v14.playPrevSong,
		LayoutOrder = nextOrder()
	}) else nil
	local v40

	if getFFlagAudioPlayerCanSkipTracks() then
		local createElement5 = React.createElement
		local iconButton = Foundation.IconButton

		local v42 = if v10 then Foundation.Enums.IconName.PauseLarge else Foundation.Enums.IconName.PlayLarge
		v40 = createElement5(iconButton, {
			icon = v42,
			isCircular = true,
			variant = Foundation.Enums.ButtonVariant.Emphasis,
			onActivated = v27,
			LayoutOrder = nextOrder()
		})
	else
		v40 = React.createElement(RoundIconButton, {
			icon = v10 and "icons/controls/media-pause-medium" or "icons/controls/media-play-medium",
			onActivated = v27,
			LayoutOrder = nextOrder()
		})
	end

	local v41 = if getFFlagAudioPlayerCanSkipTracks() and v17 then React.createElement(Foundation.IconButton, {
		icon = Foundation.Enums.IconName.SkipEndLarge,
		isDisabled = not v15,
		onActivated = v14.playNextSong,
		LayoutOrder = nextOrder()
	}) else nil
	children.PlaybackControls = createElement4(view4, v37, {
		PrevButton = v39,
		PlaybackToggleButton = v40,
		NextButton = v41
	})
	return createElement(view, v30, children)
end

return AudioPlayer
