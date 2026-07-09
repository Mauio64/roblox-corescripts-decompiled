local AppMusicPlayer = script:FindFirstAncestor("AppMusicPlayer")
local Cryo = require(AppMusicPlayer.Parent.Cryo)
local Foundation = require(AppMusicPlayer.Parent.Foundation)
local React = require(AppMusicPlayer.Parent.React)
local ReactUtils = require(AppMusicPlayer.Parent.ReactUtils)
local Songbird = require(AppMusicPlayer.Parent.Songbird)
local Localization = require(AppMusicPlayer.Parent.Localization)
local SongAttribution = require(AppMusicPlayer.Components.SongAttribution)
local createNextOrder = ReactUtils.createNextOrder
local useLocalization = Localization.Hooks.useLocalization
local useRef = React.useRef
local useCallback = React.useCallback
local useMemo = React.useMemo
local useState = React.useState
local vector2 = Vector2.new(300, 1e999)
local t1 = {
	isLoading = false,
	analyticsSource = "unknown"
}

local function ExpandedMusicPlayer(t2: {[any]: any}) -- line: 63
	-- upvalues: Cryo (copy), t1 (copy), createNextOrder (copy), useRef (copy), useState (copy), useLocalization (copy), useCallback (copy), useMemo (copy), Foundation (copy), React (copy), vector2 (copy), SongAttribution (copy), Songbird (copy)
	local v19 = Cryo.Dictionary.join(t1, t2)
	local v20 = createNextOrder()
	local v21 = useRef(nil)
	local v22, v23 = useState(false)
	local v24 = useLocalization({
		report = "Feature.MusicPlayer.Action.Report",
		goToSongDetails = "Feature.MusicPlayer.Action.GoToSongDetails"
	})
	local v25 = useCallback(function() -- line: 75
		-- upvalues: v23 (copy)
		v23(false)
	end, {})
	local v26 = useCallback(function() -- line: 79
		-- upvalues: v23 (copy)
		v23(true)
	end, {})
	local v27 = useMemo(function() -- line: 83
		-- upvalues: v24 (copy), Foundation (copy), v23 (copy), v19 (copy)
		return {
			{
				id = "report",
				isChecked = false,
				isDisabled = false,
				text = v24.report,
				icon = Foundation.Enums.IconName.Flag,
				onActivated = function() -- line: 91
					-- upvalues: v23 (copy), v19 (copy)
					v23(false)
					v19.onReport()
				end
			},
			{
				id = "view-details",
				isChecked = false,
				isDisabled = false,
				text = v24.goToSongDetails,
				icon = Foundation.Enums.IconName.MusicNote,
				onActivated = function() -- line: 102
					-- upvalues: v23 (copy), v19 (copy)
					v23(false)
					v19.onOpenSongDetails()
				end
			}
		}
	end, {
		v19.onReport,
		v19.onOpenSongDetails
	})

	return React.createElement(Foundation.View, {
		tag = "size-full-2000 row flex-between gap-medium bg-surface-200 align-y-center padding-small"
	}, {
		SongAttributionWrapper = React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y shrink row align-y-center gap-medium",
			sizeConstraint = {
				MaxSize = vector2
			},
			LayoutOrder = v20()
		}, {
			SongAttribution = React.createElement(SongAttribution, {
				title = v19.title,
				artist = v19.artist,
				albumArt = v19.albumArt,
				isLoading = v19.isLoading,
				onActivated = v19.onOpenSongDetails,
				LayoutOrder = v20()
			}),
			LikeButton = React.createElement(Foundation.IconButton, {
				icon = {
					name = Foundation.Enums.IconName.Star,
					variant = if not v19.isLiked then nil else Foundation.Enums.IconVariant.Filled
				},
				onActivated = v19.onToggleLike,
				LayoutOrder = v20()
			})
		}),
		PlaybackControls = React.createElement(Foundation.View, {
			tag = "auto-xy shrink-3 col align-x-center align-y-center",
			LayoutOrder = v20()
		}, {
			ButtonCluster = React.createElement(Foundation.View, {
				tag = "auto-xy row gap-small align-x-center"
			}, {
				PrevButton = React.createElement(Foundation.IconButton, {
					icon = Foundation.Enums.IconName.SkipStartLarge,
					isDisabled = not v19.hasPrevSong,
					onActivated = v19.onPlayPrevTrack,
					LayoutOrder = v20()
				}),
				PlaybackToggleButton = React.createElement(Foundation.IconButton, {
					isCircular = true,
					icon = if not v19.isPlaying then Foundation.Enums.IconName.PlayLarge else Foundation.Enums.IconName.PauseLarge,
					variant = Foundation.Enums.ButtonVariant.Emphasis,
					onActivated = v19.onTogglePlayback,
					LayoutOrder = v20()
				}),
				NextButton = React.createElement(Foundation.IconButton, {
					icon = Foundation.Enums.IconName.SkipEndLarge,
					isDisabled = not v19.hasNextSong,
					onActivated = v19.onPlayNextTrack,
					LayoutOrder = v20()
				})
			}),
			AudioPlaybackTimelineWrapper = React.createElement(Foundation.View, {
				tag = "auto-xy",
				sizeConstraint = {
					MaxSize = vector2
				}
			}, {
				AudioPlaybackTimeline = React.createElement(Songbird.AudioPlaybackTimeline, {
					duration = v19.duration,
					elapsed = v19.elapsed,
					onDragTimeline = v19.onDragTimeline,
					onDragTimelineStart = v19.onDragTimelineStart,
					onDragTimelineEnd = v19.onDragTimelineEnd,
					LayoutOrder = v20()
				})
			})
		}),
		Actions = React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y shrink row gap-small align-x-right",
			sizeConstraint = {
				MaxSize = vector2
			},
			LayoutOrder = v20()
		}, {
			VolumeControl = React.createElement(Foundation.View, {
				tag = "auto-xy row align-y-center",
				LayoutOrder = v20()
			}, {
				VolumeButton = React.createElement(Foundation.IconButton, {
					icon = if v19.volume ~= 0 then Foundation.Enums.IconName.Speaker else Foundation.Enums.IconName.SpeakerSlash,
					onActivated = v19.onToggleMute,
					LayoutOrder = v20()
				})
			}),
			CollapseButton = React.createElement(Foundation.IconButton, {
				icon = Foundation.Enums.IconName.TwoArrowsToCenter,
				onActivated = v19.onCollapse,
				LayoutOrder = v20()
			}),
			OverflowButton = React.createElement(Foundation.IconButton, {
				icon = Foundation.Enums.IconName.ThreeDotsVertical,
				onActivated = if not v22 then v26 else v25,
				ref = v21,
				LayoutOrder = v20()
			}),
			CloseButton = React.createElement(Foundation.IconButton, {
				icon = Foundation.Enums.IconName.X,
				onActivated = v19.onClose,
				LayoutOrder = v20()
			})
		}),
		OverflowMenu = v22 and React.createElement(Foundation.Menu, {
			isOpen = true,
			items = v27,
			side = Foundation.Enums.PopoverSide.Top,
			anchorRef = v21,
			onPressedOutside = v25
		})
	})
end

return React.memo(ExpandedMusicPlayer)
