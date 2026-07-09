local AppMusicPlayer = script:FindFirstAncestor("AppMusicPlayer")
local AssetFavorites = require(AppMusicPlayer.Parent.AssetFavorites)
local ExperienceService = require(AppMusicPlayer.Parent.ExperienceService).ExperienceService
local Foundation = require(AppMusicPlayer.Parent.Foundation)
local MediaPlayback = require(AppMusicPlayer.Parent.MediaPlayback)
local Motion = require(AppMusicPlayer.Parent.Motion)
local Navigation = require(AppMusicPlayer.Parent.Navigation)
local React = require(AppMusicPlayer.Parent.React)
local ReactRoblox = require(AppMusicPlayer.Parent.ReactRoblox)
local Responsive = require(AppMusicPlayer.Parent.Responsive)
local RobloxAppEnums = require(AppMusicPlayer.Parent.RobloxAppEnums)
local SignalsReact = require(AppMusicPlayer.Parent.SignalsReact)
local Songbird = require(AppMusicPlayer.Parent.Songbird)
local CompactMusicPlayer = require(AppMusicPlayer.Components.CompactMusicPlayer)
local ExpandedMusicPlayer = require(AppMusicPlayer.Components.ExpandedMusicPlayer)
local SongDetailsSheet = require(AppMusicPlayer.Components.SongDetailsSheet)
local useMusicTop100Playlist = require(AppMusicPlayer.Hooks.useMusicTop100Playlist)
local useAudioMetadata = Songbird.useAudioMetadata
local useSongAlbumArt = Songbird.useSongAlbumArt
local useAssetFavoriting = AssetFavorites.useAssetFavoriting
local useNavigation = Navigation.useNavigation
local useLastPlayedAudioStore = MediaPlayback.useLastPlayedAudioStore
local getAudioPlaybackStore = MediaPlayback.getAudioPlaybackStore
local useRef = React.useRef
local useCallback = React.useCallback
local useMemo = React.useMemo
local useState = React.useState
local useEffect = React.useEffect
local useSignalState = SignalsReact.useSignalState
local useSignalBinding = SignalsReact.useSignalBinding
local useOverlay = Foundation.Hooks.useOverlay

local function PersistentMusicPlayer(t1: {[any]: any}) -- line: 43
	-- upvalues: useNavigation (copy), useOverlay (copy), useRef (copy), useState (copy), Responsive (copy), useMemo (copy), useMusicTop100Playlist (copy), getAudioPlaybackStore (copy), useSignalState (copy), useLastPlayedAudioStore (copy), useSignalBinding (copy), useAssetFavoriting (copy), useAudioMetadata (copy), useSongAlbumArt (copy), Motion (copy), useCallback (copy), RobloxAppEnums (copy), useEffect (copy), ExperienceService (copy), React (copy), Foundation (copy), CompactMusicPlayer (copy), ExpandedMusicPlayer (copy), SongDetailsSheet (copy), ReactRoblox (copy), Songbird (copy)
	local v34 = useNavigation()
	local v35 = useOverlay()
	local v36 = useRef(false)
	local v37, v38 = useState(false)
	local v39, v40 = useState(false)
	local v41, v42 = useState(true)
	local v43, v44 = useState(false)
	local v45 = Responsive.useBreakpointXOrSmaller(Responsive.BreakpointConfig.Enum.Small)
	local v46 = useMemo(function() -- line: 53
		-- upvalues: v45 (copy), v41 (copy)
		return v45 or not v41
	end, {
		v41,
		v45
	})
	local v47 = useMusicTop100Playlist()
	local v48 = getAudioPlaybackStore(false)
	local v49 = useSignalState(v48.hasNextSong)
	local v50 = useSignalState(v48.hasPrevSong)
	local v51 = useSignalState(v48.getIsMuted)
	local v52 = useSignalState(v48.getGlobalVolume)
	local v53 = useLastPlayedAudioStore()
	local v54 = useSignalState(v53.getDuration)
	local v55 = useSignalBinding(v53.getElapsed)
	local v56 = useSignalState(v53.getIsPlaying)
	local v57 = useSignalState(v53.getIsLoaded)
	local num = tonumber(v53.assetId)
	local v59 = useAssetFavoriting(if not num then {} else { num })
	local v60 = not not num and v59.getByAssetId(num)
	local v61 = useAudioMetadata({ v53.assetId })
	local v62 = useSongAlbumArt(v53.assetId)
	local v63 = useMemo(function() -- line: 78
		-- upvalues: Motion (copy)
		return {
			expanded = Motion.createState({
				expandedPlayerPosition = UDim2.fromScale(0, 0),
				compactPlayerPosition = UDim2.fromScale(1, 1)
			}),
			collapsed = Motion.createState({
				expandedPlayerPosition = UDim2.fromScale(0, 1),
				compactPlayerPosition = UDim2.fromScale(1, 0)
			}),
			closed = Motion.createState({
				expandedPlayerPosition = UDim2.fromScale(0, 1),
				compactPlayerPosition = UDim2.fromScale(1, 1)
			})
		}
	end, {})
	local v64, v65 = Motion.useMotion(v63.expanded)
	local v66 = useCallback(function() -- line: 97
		-- upvalues: v36 (copy), v56 (copy), v53 (copy)
		v36.current = v56
		v53.pause()
	end, {
		v53.pause,
		v56
	})
	local v67 = useCallback(function(n1: number) -- line: 102
		-- upvalues: v53 (copy), v54 (copy)
		v53.seek(v54 * n1)
	end, {
		v53.seek,
		v54
	})
	local v68 = useCallback(function() -- line: 106
		-- upvalues: v36 (copy), v53 (copy)
		if v36.current then
			v53.play()
		end
	end, { v53.play })
	local v69 = useCallback(function() -- line: 112
		-- upvalues: v56 (copy), v53 (copy)
		if v56 then
			v53.pause()

			return
		end

		v53.play()
	end, {
		v56,
		v53.play,
		v53.pause
	})
	local v70 = useCallback(function() -- line: 120
		-- upvalues: v48 (copy)
		v48.playPrevSong()
	end, {})
	local v71 = useCallback(function() -- line: 124
		-- upvalues: v48 (copy)
		v48.playNextSong()
	end, {})
	local v72 = useCallback(function() -- line: 128
		-- upvalues: v51 (copy), v48 (copy)
		if v51 then
			v48.unmute()

			return
		end

		v48.mute()
	end, {
		v51,
		v48.unmute,
		v48.mute
	})
	local v73 = useCallback(function() -- line: 136
		-- upvalues: num (copy), v59 (copy)
		if num then
			v59.toggleFavorite(num)
		end
	end, {
		v59.toggleFavorite,
		num
	})
	local v74 = useCallback(function() -- line: 142
		-- upvalues: v48 (copy), v40 (copy)
		v48.stopAll()
		v40(true)
	end, { v48 })
	local v75 = useCallback(function() -- line: 147
		-- upvalues: v42 (copy)
		v42(true)
	end, {})
	local v76 = useCallback(function() -- line: 151
		-- upvalues: v42 (copy)
		v42(false)
	end, {})
	local v77 = useCallback(function() -- line: 155
		-- upvalues: v34 (copy), RobloxAppEnums (copy), v53 (copy)
		v34.navigate(RobloxAppEnums.AppPage.SongDetail, {
			songId = v53.assetId
		})
	end, { v53.assetId })
	local v78 = useCallback(function() -- line: 161
		-- upvalues: v38 (copy)
		v38(false)
	end, {})
	local v79 = useCallback(function() -- line: 165
		-- upvalues: v48 (copy), v44 (copy), v38 (copy)
		v48.pauseAll()
		v44(false)
		v38(true)
	end, { v48 })
	local v80 = useCallback(function() -- line: 171
		-- upvalues: v44 (copy)
		v44(true)
	end, {})
	local v81 = useCallback(function() -- line: 175
		-- upvalues: v44 (copy)
		v44(false)
	end, {})

	useEffect(function() -- line: 179
		-- upvalues: v47 (copy), v48 (copy)
		if #v47 > 0 then
			v48.setPlaylist(v47)
		end
	end, { v47 })
	useEffect(function() -- line: 185
		-- upvalues: v39 (copy), v65 (copy), v63 (copy), v46 (copy)
		if v39 then
			v65(v63.closed)

			return
		end

		if v46 then
			v65(v63.collapsed)

			return
		end

		v65(v63.expanded)
	end, {
		v39,
		v46
	})
	useEffect(function() -- line: 197
		-- upvalues: v56 (copy), v40 (copy)
		if v56 then
			v40(false)
		end
	end, { v56 })
	useEffect(function() -- line: 203
		-- upvalues: ExperienceService (copy), v48 (copy)
		local v87 = ExperienceService:RegisterForExperienceJoin(function(...) -- line: 204
			-- upvalues: v48 (copy)
			v48.stopAll()
		end)

		return function() -- line: 208
			-- upvalues: v87 (copy)
			if v87 then
				v87:Disconnect()
			end
		end
	end, { v48 })

	if not v57 then
		return nil
	end

	local v82 = v61.getByAssetId(v53.assetId)
	local v83 = v82 ~= nil and v62.status == "ok"
	local v84 = not v82 and "" or v82.Title
	local v85 = not v82 and "" or v82.Artist

	return React.createElement(Foundation.View, {
		tag = "size-full-2000 clip",
		LayoutOrder = t1.LayoutOrder
	}, {
		Compact = React.createElement(Foundation.View, {
			tag = "auto-xy",
			AnchorPoint = Vector2.new(1, 0),
			Position = v64.compactPlayerPosition
		}, {
			CompactMusicPlayer = React.createElement(CompactMusicPlayer, {
				title = v84,
				artist = v85,
				albumArt = v62.value,
				isLoading = not v83,
				duration = v54,
				elapsed = v55,
				isPlaying = v56,
				onOpenSongDetails = v80,
				onTogglePlayback = v69,
				onExpand = v75,
				onToggleLike = v73
			})
		}),
		Expanded = React.createElement(Foundation.View, {
			tag = "size-full",
			ZIndex = 2,
			Position = v64.expandedPlayerPosition
		}, {
			ExpandedMusicPlayer = React.createElement(ExpandedMusicPlayer, {
				albumArt = v62.value,
				artist = v85,
				duration = v54,
				elapsed = v55,
				hasNextSong = v49,
				hasPrevSong = v50,
				isLiked = v60,
				isLoading = not v83,
				isPlaying = v56,
				title = v84,
				volume = v52,
				assetId = v53.assetId,
				analyticsSource = t1.analyticsSource,
				onClose = v74,
				onCollapse = v76,
				onDragTimeline = v67,
				onDragTimelineEnd = v68,
				onDragTimelineStart = v66,
				onOpenSongDetails = v77,
				onPlayNextTrack = v71,
				onPlayPrevTrack = v70,
				onToggleLike = v73,
				onToggleMute = v72,
				onVolumeChanged = v48.setGlobalVolume,
				onTogglePlayback = v69,
				onReport = v79
			})
		}),
		SongDetailsSheet = React.createElement(SongDetailsSheet, {
			title = v84,
			artist = v85,
			isLiked = v60,
			isOpen = v43,
			albumArt = v62.value,
			assetId = v53.assetId,
			onClose = v81,
			onLike = v73,
			onUnlike = v73,
			onReport = v79
		}),
		ReportDialog = if not v37 or not v35 then nil else ReactRoblox.createPortal(React.createElement(Foundation.View, {
			tag = "size-full row align-y-center align-x-center bg-over-media-100",
			stateLayer = {
				affordance = Foundation.Enums.StateLayerAffordance.None
			},
			onActivated = v78
		}, {
			Dialog = React.createElement(Songbird.ReportSongDialog, {
				audio = {
					thumbnailAssetId = "-1",
					assetId = v53.assetId
				},
				analyticsSource = t1.analyticsSource or "unknown",
				onClose = v78
			})
		}), v35)
	})
end

return React.memo(PersistentMusicPlayer)
