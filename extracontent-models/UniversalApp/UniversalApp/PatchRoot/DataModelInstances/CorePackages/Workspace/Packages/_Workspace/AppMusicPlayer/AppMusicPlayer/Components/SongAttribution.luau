local AppMusicPlayer = script:FindFirstAncestor("AppMusicPlayer")
local Cryo = require(AppMusicPlayer.Parent.Cryo)
local Foundation = require(AppMusicPlayer.Parent.Foundation)
local React = require(AppMusicPlayer.Parent.React)
local ReactUtils = require(AppMusicPlayer.Parent.ReactUtils)
local SongAttributionVariant = require(AppMusicPlayer.Enums.SongAttributionVariant)
local createNextOrder = ReactUtils.createNextOrder
local useTokens = Foundation.Hooks.useTokens
local t1 = {
	isLoading = false,
	variant = SongAttributionVariant.Expanded
}

local function SongAttribution(t2: {[any]: any}) -- line: 32
	-- upvalues: Cryo (copy), t1 (copy), createNextOrder (copy), useTokens (copy), React (copy), Foundation (copy), SongAttributionVariant (copy)
	local v12 = Cryo.Dictionary.join(t1, t2)
	local v13 = createNextOrder()
	local v14 = useTokens()

	return React.createElement(Foundation.View, {
		testId = "song-attribution-root",
		tag = {
			["auto-xy row shrink flex-between align-y-center"] = true,
			["gap-medium"] = v12.variant == SongAttributionVariant.Expanded,
			["gap-small"] = v12.variant == SongAttributionVariant.Compact
		},
		LayoutOrder = v12.LayoutOrder
	}, {
		AlbumArt = if v12.isLoading then React.createElement(Foundation.Skeleton, {
			testId = "song-attribution-album-art-skeleton",
			Size = UDim2.fromOffset(v14.Size.Size_1600, v14.Size.Size_1600)
		}) else React.createElement(Foundation.Image, {
			testId = "song-attribution-album-art",
			tag = {
				["bg-surface-100 radius-medium"] = true,
				["size-1600-1600"] = v12.variant == SongAttributionVariant.Expanded,
				["size-800-800"] = v12.variant == SongAttributionVariant.Compact
			},
			Image = v12.albumArt,
			LayoutOrder = v13(),
			onActivated = v12.onActivated
		}),
		Attribution = React.createElement(Foundation.View, {
			tag = "auto-xy shrink col gap-xsmall",
			LayoutOrder = v13()
		}, {
			Title = if v12.isLoading then React.createElement(Foundation.Skeleton, {
				testId = "song-attribution-song-title-skeleton",
				Size = UDim2.new(1, 0, 0, v14.FontSize.FontSize_300)
			}) else React.createElement(Foundation.Text, {
				tag = {
					["auto-xy text-truncate-end content-emphasis"] = true,
					["text-title-medium"] = v12.variant == SongAttributionVariant.Expanded,
					["text-title-small"] = v12.variant == SongAttributionVariant.Compact
				},
				Text = v12.title,
				LayoutOrder = v13(),
				onActivated = v12.onActivated
			}),
			Artist = if v12.isLoading then React.createElement(Foundation.Skeleton, {
				testId = "song-attribution-artist-name-skeleton",
				Size = UDim2.new(0.5, 0, 0, v14.FontSize.FontSize_300)
			}) else React.createElement(Foundation.Text, {
				tag = {
					["auto-xy text-truncate-end content-muted"] = true,
					["text-body-medium"] = v12.variant == SongAttributionVariant.Expanded,
					["text-body-small"] = v12.variant == SongAttributionVariant.Compact
				},
				Text = v12.artist,
				LayoutOrder = v13(),
				onActivated = v12.onActivated
			})
		})
	})
end

return SongAttribution
