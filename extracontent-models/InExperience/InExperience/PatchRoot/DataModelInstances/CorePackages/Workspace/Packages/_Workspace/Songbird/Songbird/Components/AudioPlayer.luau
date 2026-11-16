local Songbird = script:FindFirstAncestor("Songbird")

local Cryo = require(Songbird.Parent.Cryo)
local Foundation = require(Songbird.Parent.Foundation)
local MediaPlayback = require(Songbird.Parent.MediaPlayback)
local React = require(Songbird.Parent.React)
local ReactUtils = require(Songbird.Parent.ReactUtils)
local SignalsReact = require(Songbird.Parent.SignalsReact)

local Localization = require(Songbird.Parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local RoundIconButton = require(Songbird.Components.RoundIconButton)
local AudioPlaybackTimeline = require(Songbird.Components.AudioPlaybackTimeline)
require(Songbird.types)
local AnalyticActions = require(Songbird.Analytics.AnalyticActions)
local sendAudioPlayerAnalytics = require(Songbird.Analytics.sendAudioPlayerAnalytics)
local useStopSongOnPageNavigation = require(Songbird.Hooks.useStopSongOnPageNavigation)

local SharedFlags = require(Songbird.Parent.SharedFlags)
local GetFFlagAudioPlayerCanSkipTracks = SharedFlags.GetFFlagAudioPlayerCanSkipTracks
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

local v = { isNavigationFocus = true }

local vector2 = Vector2.new(320, 320)

local function AudioPlayer(p)
	local joined = Cryo.Dictionary.join(v, p)

	local nextOrder = createNextOrder()

	local v2 = useLocalization({ songPreview = "Feature.SongDetails.Label.SongPreview" })

	local assetId = joined.audio.assetId
	local v3

	if getFFlagAudioPreviewLua() then
		v3 = joined.audio.isPrivate
	end

	local v4 = useAudioStore(assetId, v3)
	local current = useSignalState(v4.getIsPlaying)
	local v5 = useSignalState(v4.getIsElapsed)
	local duration = useSignalState(v4.getDuration)
	local elapsed = useSignalBinding(v4.getElapsed)
	local v6

	if GetFFlagAudioPlayerCanSkipTracks() then
		v6 = useSignalState(getAudioPlaybackStore)
	else
		v6 = nil
	end

	local v7

	if GetFFlagAudioPlayerCanSkipTracks() then
		v7 = useSignalState(v6.hasNextSong)
	end

	local v8

	if GetFFlagAudioPlayerCanSkipTracks() then
		v8 = useSignalState(v6.hasPrevSong)
	end

	local v9 = v7 or v8

	local v10 = useCallback(function(action)
		local songId = joined.audio.assetId:gsub("rbxassetid://", "")
		local v10

		if joined.audio.thumbnailAssetId then
			v10 = joined.audio.thumbnailAssetId:gsub("rbxassetid://", "")
		end

		sendAudioPlayerAnalytics({
			action = action,
			songId = songId,
			thumbnailId = v10 or "-1",
			source = joined.analyticsSource,
			listenDurationSeconds = elapsed:getValue()
		})
	end, { joined.audio.assetId, joined.audio.thumbnail, joined.analyticsSource, elapsed })

	local v11 = useCallback(function()
		v10(AnalyticActions.AudioElapsed)
		v10(AnalyticActions.AudioStopped)
	end, { v10 })

	local v12 = useRef(false)

	local onDragTimelineStart = useCallback(function()
		v12.current = current
		v4.pause()
	end, { v4.pause, current })

	local onDragTimeline = useCallback(function(p2: number)
		v4.seek(duration * p2)
	end, { v4.seek, duration })

	local onDragTimelineEnd = useCallback(function()
		if v12.current then
			v4.play()
		end
	end, { v4.play })

	local function fn()
		if current then
			v10(AnalyticActions.AudioPause)
			v10(AnalyticActions.AudioStopped)
			v4.pause()
		else
			v10(AnalyticActions.AudioPlay)

			if GetFFlagAudioPlayerCanSkipTracks() then
				v6.pauseAll()
			else
				getAudioPlaybackStore(false).pauseAll()
			end

			v4.play()
		end
	end

	local play = v4.play
	local pause = v4.pause
	local v13

	if GetFFlagAudioPlayerCanSkipTracks() then
		v13 = v6
	end

	local onActivated = useCallback(fn, { play, pause, current, v13 })

	local v14 = useCallback(function()
		v10(AnalyticActions.AudioStopped)
	end, { v10 })
	useStopSongOnPageNavigation(joined.isNavigationFocus, v14)

	local v15 = usePrevious(v5)
	useEffect(function()
		if v5 and not v15 then
			v11()
		end
	end, { v5 })

	local createElement = React.createElement
	local view = Foundation.View
	local v16 = { tag = "auto-xy col align-x-center gap-large", LayoutOrder = joined.LayoutOrder }

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local v17 = {
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
	local v18 = {
		tag = "size-full-0 auto-y grow col align-x-center gap-medium",
		LayoutOrder = nextOrder()
	}
	local v19 = {
		Title = React.createElement(Foundation.Text, {
			tag = "auto-xy text-heading-small content-emphasis text-truncate-end",
			Text = joined.audio.title,
			LayoutOrder = nextOrder()
		}),
		Artist = 0,
		ArtistRow = 0
	}
	local artist

	if not getFFlagAudioPreviewLua() then
		artist = React.createElement(Foundation.Text, {
			tag = "auto-xy text-body-large content-default text-truncate-end",
			Text = joined.audio.artist,
			LayoutOrder = nextOrder()
		})
	end

	v19.Artist = artist
	local artistRow

	if getFFlagAudioPreviewLua() then
		local createElement4 = React.createElement
		local view4 = Foundation.View
		local v20 = {
			tag = "row align-x-center align-y-center gap-xsmall auto-xy",
			LayoutOrder = nextOrder()
		}
		local v21 = {
			Artist = React.createElement(Foundation.Text, {
				tag = "auto-xy text-body-large text-truncate-end content-default",
				Text = joined.audio.artist,
				LayoutOrder = 1
			}),
			SongPreviewSeparator = 0,
			SongPreviewLabel = 0
		}
		local songPreviewSeparator

		if joined.audio.isPrivate then
			songPreviewSeparator = React.createElement(Foundation.Text, {
				tag = "auto-xy text-body-large content-default",
				Text = "·",
				LayoutOrder = 2
			})
		end

		v21.SongPreviewSeparator = songPreviewSeparator
		local songPreviewLabel

		if joined.audio.isPrivate then
			songPreviewLabel = React.createElement(Foundation.Text, {
				tag = "auto-xy text-body-large content-default",
				Text = v2.songPreview,
				LayoutOrder = 3
			})
		end

		v21.SongPreviewLabel = songPreviewLabel
		artistRow = createElement4(view4, v20, v21)
	end

	v19.ArtistRow = artistRow
	v17.Info = createElement3(view3, v18, v19)
	local children = {
		AudioDetails = createElement2(view2, {
			tag = "size-full-0 auto-y col align-x-center gap-xlarge"
		}, v17),
		PlaybackProgress = React.createElement(AudioPlaybackTimeline, {
			LayoutOrder = nextOrder(),
			duration = duration,
			elapsed = elapsed,
			onDragTimeline = onDragTimeline,
			onDragTimelineStart = onDragTimelineStart,
			onDragTimelineEnd = onDragTimelineEnd
		}),
		PlaybackControls = 0
	}

	local createElement4 = React.createElement
	local view4 = Foundation.View
	local v20 = { tag = "auto-xy row gap-medium align-y-center", LayoutOrder = nextOrder() }
	local prevButton

	if GetFFlagAudioPlayerCanSkipTracks() and v9 then
		prevButton = React.createElement(Foundation.IconButton, {
			icon = Foundation.Enums.IconName.SkipStartLarge,
			isDisabled = not v8,
			onActivated = v6.playPrevSong,
			LayoutOrder = nextOrder()
		})
	end

	local playbackToggleButton

	if GetFFlagAudioPlayerCanSkipTracks() then
		local createElement5 = React.createElement
		local iconButton = Foundation.IconButton
		local icon

		if current then
			icon = Foundation.Enums.IconName.PauseLarge
		else
			icon = Foundation.Enums.IconName.PlayLarge
		end

		playbackToggleButton = createElement5(iconButton, {
			icon = icon,
			isCircular = true,
			variant = Foundation.Enums.ButtonVariant.Emphasis,
			onActivated = onActivated,
			LayoutOrder = nextOrder()
		})
	else
		playbackToggleButton = React.createElement(RoundIconButton, {
			icon = current and "icons/controls/media-pause-medium" or "icons/controls/media-play-medium",
			onActivated = onActivated,
			LayoutOrder = nextOrder()
		})
	end

	local nextButton

	if GetFFlagAudioPlayerCanSkipTracks() and v9 then
		nextButton = React.createElement(Foundation.IconButton, {
			icon = Foundation.Enums.IconName.SkipEndLarge,
			isDisabled = not v7,
			onActivated = v6.playNextSong,
			LayoutOrder = nextOrder()
		})
	end

	children.PlaybackControls = createElement4(view4, v20, {
		PrevButton = prevButton,
		PlaybackToggleButton = playbackToggleButton,
		NextButton = nextButton
	})
	return createElement(view, v16, children)
end

return AudioPlayer
