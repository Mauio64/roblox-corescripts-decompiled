local AppMusicPlayer = script:FindFirstAncestor("AppMusicPlayer")
local Cryo = require(AppMusicPlayer.Parent.Cryo)
local Foundation = require(AppMusicPlayer.Parent.Foundation)
local React = require(AppMusicPlayer.Parent.React)
local ReactUtils = require(AppMusicPlayer.Parent.ReactUtils)
local Responsive = require(AppMusicPlayer.Parent.Responsive)
local SongAttribution = require(AppMusicPlayer.Components.SongAttribution)
local SongAttributionVariant = require(AppMusicPlayer.Enums.SongAttributionVariant)
local createNextOrder = ReactUtils.createNextOrder
local t1 = {
	isLoading = false
}

local function CompactMusicPlayer(t2: {[any]: any}) -- line: 38
	-- upvalues: Cryo (copy), t1 (copy), createNextOrder (copy), Responsive (copy), React (copy), Foundation (copy), SongAttribution (copy), SongAttributionVariant (copy)
	local v13 = Cryo.Dictionary.join(t1, t2)
	local v14 = createNextOrder()
	local v15 = Responsive.useBreakpointXOrSmaller(Responsive.BreakpointConfig.Enum.Small)

	return React.createElement(Foundation.View, {
		tag = "auto-xy col bg-surface-200 radius-medium",
		sizeConstraint = {
			MaxSize = Vector2.new(300, 1e999)
		},
		LayoutOrder = v13.LayoutOrder
	}, {
		ProgressBar = React.createElement(Foundation.View, {
			tag = "size-full-50 bg-action-standard",
			LayoutOrder = v14()
		}, {
			Fill = React.createElement(Foundation.View, {
				tag = "size-0-full bg-action-emphasis",
				testId = "compact-music-player-progress-bar-fill",
				Size = v13.elapsed:map(function(n1: number) -- line: 58
					-- upvalues: v13 (copy)
					return UDim2.fromScale(n1 / v13.duration, 1)
				end)
			})
		}),
		Content = React.createElement(Foundation.View, {
			tag = "auto-xy row flex-between gap-medium align-y-center padding-small",
			LayoutOrder = v14()
		}, {
			SongAttributionWrapper = React.createElement(Foundation.View, {
				tag = "size-full-0 auto-y shrink",
				LayoutOrder = v14()
			}, {
				SongAttribution = React.createElement(SongAttribution, {
					title = v13.title,
					artist = v13.artist,
					albumArt = v13.albumArt,
					isLoading = v13.isLoading,
					variant = SongAttributionVariant.Compact,
					onActivated = v13.onOpenSongDetails,
					LayoutOrder = v14()
				})
			}),
			CollapseButton = if v15 then nil else React.createElement(Foundation.IconButton, {
				icon = Foundation.Enums.IconName.TwoArrowsFromCenter,
				size = Foundation.Enums.ButtonSize.Small,
				onActivated = v13.onExpand,
				LayoutOrder = v14()
			}),
			PlaybackToggleButton = React.createElement(Foundation.IconButton, {
				isCircular = true,
				icon = if not v13.isPlaying then Foundation.Enums.IconName.PlayLarge else Foundation.Enums.IconName.PauseLarge,
				variant = Foundation.Enums.ButtonVariant.Emphasis,
				size = Foundation.Enums.ButtonSize.Small,
				onActivated = v13.onTogglePlayback,
				LayoutOrder = v14()
			})
		})
	})
end

return React.memo(CompactMusicPlayer)
