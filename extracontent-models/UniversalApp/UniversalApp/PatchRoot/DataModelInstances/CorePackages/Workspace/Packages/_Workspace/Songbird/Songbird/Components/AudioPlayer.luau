local Songbird = script:FindFirstAncestor("Songbird")
local Cryo = require(Songbird.Parent.Cryo)
local Foundation = require(Songbird.Parent.Foundation)
local MediaPlayback = require(Songbird.Parent.MediaPlayback)
local React = require(Songbird.Parent.React)
local ReactUtils = require(Songbird.Parent.ReactUtils)
local SignalsReact = require(Songbird.Parent.SignalsReact)
local useLocalization = require(Songbird.Parent.Localization).Hooks.useLocalization
local RoundIconButton = require(Songbird.Components.RoundIconButton)
local AudioPlaybackTimeline = require(Songbird.Components.AudioPlaybackTimeline)

require(Songbird.types)

local AnalyticActions = require(Songbird.Analytics.AnalyticActions)
local sendAudioPlayerAnalytics = require(Songbird.Analytics.sendAudioPlayerAnalytics)
local useStopSongOnPageNavigation = require(Songbird.Hooks.useStopSongOnPageNavigation)
local GetFFlagLuaAppPersistentMusicPlayer = require(Songbird.Parent.SharedFlags).GetFFlagLuaAppPersistentMusicPlayer
local GetFFlagAudioPlayerCanSkipTracks = require(Songbird.Parent.SharedFlags).GetFFlagAudioPlayerCanSkipTracks
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
local t1 = {
	isNavigationFocus = true
}
local vector2 = Vector2.new(320, 320)

local function AudioPlayer(t2: {[any]: any}) -- line: 62
	-- upvalues: Cryo (copy), t1 (copy), createNextOrder (copy), useLocalization (copy), useAudioStore (copy), getFFlagAudioPreviewLua (copy), useSignalState (copy), useSignalBinding (copy), GetFFlagAudioPlayerCanSkipTracks (copy), getAudioPlaybackStore (copy), useCallback (copy), sendAudioPlayerAnalytics (copy), AnalyticActions (copy), useRef (copy), GetFFlagLuaAppPersistentMusicPlayer (copy), useStopSongOnPageNavigation (copy), usePrevious (copy), useEffect (copy), React (copy), Foundation (copy), vector2 (copy), AudioPlaybackTimeline (copy), RoundIconButton (copy)
	local v30 = Cryo.Dictionary.join(t1, t2)
	local v31 = createNextOrder()
	local v32 = useLocalization({
		songPreview = "Feature.SongDetails.Label.SongPreview"
	})
	local v33 = useAudioStore(v30.audio.assetId, if not getFFlagAudioPreviewLua() then nil else v30.audio.isPrivate)
	local v34 = useSignalState(v33.getIsPlaying)
	local v35 = useSignalState(v33.getIsElapsed)
	local v36 = useSignalState(v33.getDuration)
	local v37 = useSignalBinding(v33.getElapsed)
	local v38 = if not GetFFlagAudioPlayerCanSkipTracks() then nil else useSignalState(getAudioPlaybackStore)
	local v39 = if not GetFFlagAudioPlayerCanSkipTracks() then nil else useSignalState(v38.hasNextSong)
	local v40 = if not GetFFlagAudioPlayerCanSkipTracks() then nil else useSignalState(v38.hasPrevSong)
	local v41 = v39 or v40
	local v42 = useCallback(function(p1) -- line: 91
		-- upvalues: v30 (copy), sendAudioPlayerAnalytics (copy), v37 (copy)
		local v52 = v30.audio.assetId:gsub("rbxassetid://", "")
		local v53 = if not v30.audio.thumbnailAssetId then nil else v30.audio.thumbnailAssetId:gsub("rbxassetid://", "")

		sendAudioPlayerAnalytics({
			action = p1,
			songId = v52,
			thumbnailId = v53 or "-1",
			source = v30.analyticsSource,
			listenDurationSeconds = v37:getValue()
		})
	end, {
		v30.audio.assetId,
		v30.audio.thumbnail,
		v30.analyticsSource,
		v37
	})
	local v43 = useCallback(function() -- line: 118
		-- upvalues: v42 (copy), AnalyticActions (copy)
		v42(AnalyticActions.AudioElapsed)
		v42(AnalyticActions.AudioStopped)
	end, { v42 })
	local v44 = useRef(false)
	local v45 = useCallback(function() -- line: 125
		-- upvalues: v44 (copy), v34 (copy), v33 (copy)
		v44.current = v34
		v33.pause()
	end, {
		v33.pause,
		v34
	})
	local v46 = useCallback(function(n1: number) -- line: 130
		-- upvalues: v33 (copy), v36 (copy)
		v33.seek(v36 * n1)
	end, {
		v33.seek,
		v36
	})
	local v47 = useCallback(function() -- line: 134
		-- upvalues: v44 (copy), v33 (copy)
		if v44.current then
			v33.play()
		end
	end, { v33.play })
	local v48 = useCallback(function() -- line: 141
		-- upvalues: v34 (copy), v42 (copy), AnalyticActions (copy), v33 (copy), GetFFlagAudioPlayerCanSkipTracks (copy), v38 (copy), getAudioPlaybackStore (copy)
		if v34 then
			v42(AnalyticActions.AudioPause)
			v42(AnalyticActions.AudioStopped)
			v33.pause()

			return
		end

		v42(AnalyticActions.AudioPlay)

		if GetFFlagAudioPlayerCanSkipTracks() then
			v38.pauseAll()
		else
			getAudioPlaybackStore(false).pauseAll()
		end

		v33.play()
	end, {
		v33.play,
		v33.pause,
		v34,
		if not GetFFlagAudioPlayerCanSkipTracks() then nil else v38
	})

	if not GetFFlagLuaAppPersistentMusicPlayer() then
		local v49 = useCallback(function() -- line: 165
			-- upvalues: v42 (copy), AnalyticActions (copy)
			v42(AnalyticActions.AudioStopped)
		end, { v42 })

		useStopSongOnPageNavigation(v30.isNavigationFocus, v49)

		local v50 = usePrevious(v35)

		useEffect(function() -- line: 171
			-- upvalues: v35 (copy), v50 (copy), v43 (copy)
			if v35 and not v50 then
				v43()
			end
		end, { v35 })
	end

	return React.createElement(Foundation.View, {
		tag = "auto-xy col align-x-center gap-large",
		LayoutOrder = v30.LayoutOrder
	}, {
		AudioDetails = React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y col align-x-center gap-xlarge"
		}, {
			AlbumArt = React.createElement(Foundation.Image, {
				tag = "size-full shrink bg-surface-100 radius-medium",
				aspectRatio = 1,
				sizeConstraint = {
					MaxSize = vector2
				},
				Image = v30.audio.thumbnail,
				LayoutOrder = v31()
			}),
			Info = React.createElement(Foundation.View, {
				tag = "size-full-0 auto-y grow col align-x-center gap-medium",
				LayoutOrder = v31()
			}, {
				Title = React.createElement(Foundation.Text, {
					tag = "auto-xy text-heading-small content-emphasis text-truncate-end",
					Text = v30.audio.title,
					LayoutOrder = v31()
				}),
				Artist = if getFFlagAudioPreviewLua() then nil else React.createElement(Foundation.Text, {
					tag = "auto-xy text-body-large content-default text-truncate-end",
					Text = v30.audio.artist,
					LayoutOrder = v31()
				}),
				ArtistRow = if not getFFlagAudioPreviewLua() then nil else React.createElement(Foundation.View, {
					tag = "row align-x-center align-y-center gap-xsmall auto-xy",
					LayoutOrder = v31()
				}, {
					Artist = React.createElement(Foundation.Text, {
						tag = "auto-xy text-body-large text-truncate-end content-default",
						LayoutOrder = 1,
						Text = v30.audio.artist
					}),
					SongPreviewSeparator = if not v30.audio.isPrivate then nil else React.createElement(Foundation.Text, {
						tag = "auto-xy text-body-large content-default",
						Text = "·",
						LayoutOrder = 2
					}),
					SongPreviewLabel = if not v30.audio.isPrivate then nil else React.createElement(Foundation.Text, {
						tag = "auto-xy text-body-large content-default",
						LayoutOrder = 3,
						Text = v32.songPreview
					})
				})
			})
		}),
		PlaybackProgress = React.createElement(AudioPlaybackTimeline, {
			LayoutOrder = v31(),
			duration = v36,
			elapsed = v37,
			onDragTimeline = v46,
			onDragTimelineStart = v45,
			onDragTimelineEnd = v47
		}),
		PlaybackControls = React.createElement(Foundation.View, {
			tag = "auto-xy row gap-medium align-y-center",
			LayoutOrder = v31()
		}, {
			PrevButton = if not GetFFlagAudioPlayerCanSkipTracks() or not v41 then nil else React.createElement(Foundation.IconButton, {
				icon = Foundation.Enums.IconName.SkipStartLarge,
				isDisabled = not v40,
				onActivated = v38.playPrevSong,
				LayoutOrder = v31()
			}),
			PlaybackToggleButton = if not GetFFlagAudioPlayerCanSkipTracks() then React.createElement(RoundIconButton, {
				icon = not v34 and "icons/controls/media-play-medium" or "icons/controls/media-pause-medium",
				onActivated = v48,
				LayoutOrder = v31()
			}) else React.createElement(Foundation.IconButton, {
				isCircular = true,
				icon = if not v34 then Foundation.Enums.IconName.PlayLarge else Foundation.Enums.IconName.PauseLarge,
				variant = Foundation.Enums.ButtonVariant.Emphasis,
				onActivated = v48,
				LayoutOrder = v31()
			}),
			NextButton = if not GetFFlagAudioPlayerCanSkipTracks() or not v41 then nil else React.createElement(Foundation.IconButton, {
				icon = Foundation.Enums.IconName.SkipEndLarge,
				isDisabled = not v39,
				onActivated = v38.playNextSong,
				LayoutOrder = v31()
			})
		})
	})
end

return AudioPlayer
