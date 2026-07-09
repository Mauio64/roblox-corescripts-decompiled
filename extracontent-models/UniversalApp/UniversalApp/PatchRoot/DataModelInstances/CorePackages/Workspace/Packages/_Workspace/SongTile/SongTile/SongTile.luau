local Parent = script:FindFirstAncestor("SongTile").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local MediaPlayback = require(Parent.MediaPlayback)
local t = require(Parent.t)
local validateProps = require(Parent.DiscoveryUtils).validateProps
local SignalsReact = require(Parent.SignalsReact)
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local useStyle = require(Parent.UIBlox).Core.Style.useStyle
local SharedFlags = require(Parent.SharedFlags)
local FFlagEnableTopSongsSort = SharedFlags.FFlagEnableTopSongsSort
local GetFFlagLuaAppPersistentMusicPlayer = SharedFlags.GetFFlagLuaAppPersistentMusicPlayer
local useSongTileData = require(Parent.SongInfosRodux).useSongTileData
local useTokens = require(Parent.Foundation).Hooks.useTokens
local GameTileView = require(Parent.GameTile).GameTileView
local GameTileViewConfig = require(Parent.GameTile).GameTileViewConfig
local GameTileConstants = require(Parent.GameTile).GameTileConstants
local useImpressionsTagger = require(Parent.Impressions).useImpressionsTagger
local OpenSongDetail = require(Parent.DiscoveryRouting).OpenSongDetail
local getAudioPlaybackStore = MediaPlayback.getAudioPlaybackStore
local useAudioStore = MediaPlayback.useAudioStore
local useSignalState = SignalsReact.useSignalState
local v23 = t.strictInterface({
	contentId = t.string,
	contentTextLineCount = t.optional(t.number),
	hasBackground = t.optional(t.boolean),
	hasOutline = t.optional(t.boolean),
	layoutOrder = t.optional(t.number),
	size = t.optional(t.UDim2),
	zIndex = t.optional(t.number),
	useLargerFooterFont = t.optional(t.boolean),
	impressionsTag = t.optional(t.string),
	reportTileOpened = t.optional(t.callback),
	isContained = t.optional(t.boolean)
})

return function(t1: {[any]: any}) -- line: 62
	-- upvalues: FFlagEnableTopSongsSort (copy), validateProps (copy), v23 (copy), useDispatch (copy), useStyle (copy), useSongTileData (copy), GetFFlagLuaAppPersistentMusicPlayer (copy), useAudioStore (copy), useSignalState (copy), React (copy), getAudioPlaybackStore (copy), useTokens (copy), OpenSongDetail (copy), useImpressionsTagger (copy), Foundation (copy), GameTileView (copy), GameTileConstants (copy), GameTileViewConfig (copy)
	assert(FFlagEnableTopSongsSort, "Song Sort is not enabled")
	validateProps(v23, t1)

	local v25 = useDispatch()
	local v26 = useStyle()
	local v27 = useSongTileData(t1.contentId)
	local song = v27.song
	local thumbnail = v27.thumbnail
	local v30 = t1.size or UDim2.fromScale(1, 1)
	local v31 = if not GetFFlagLuaAppPersistentMusicPlayer() then nil else useAudioStore(t1.contentId)
	local v32 = if not GetFFlagLuaAppPersistentMusicPlayer() then nil else useSignalState(v31.getIsPlaying)
	local v33 = if not GetFFlagLuaAppPersistentMusicPlayer() then nil else React.useCallback(function() -- line: 81
		-- upvalues: getAudioPlaybackStore (copy), v32 (copy), v31 (copy)
		getAudioPlaybackStore(false).stopAll()

		if not v32 then
			v31.play()
		end
	end, {
		v32,
		v31.play
	})
	local v34 = useTokens()
	local v35 = React.useCallback(function() -- line: 91
		-- upvalues: song (copy), v34 (copy), React (copy), v26 (copy)
		local v39 = song and song.artist or ""
		local TitleMedium = v34.Typography.TitleMedium

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, TitleMedium.FontSize)
		}, { React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextWrapped = false,
			Text = v39,
			Size = UDim2.new(1, 0, 0, TitleMedium.FontSize),
			Font = v34.Typography.TitleMedium.Font,
			TextSize = TitleMedium.FontSize,
			TextColor3 = v26.Theme.TextMuted.Color,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center
		}) })
	end, {
		v26,
		song,
		v34
	})
	local v36 = React.useCallback(function() -- line: 116
		-- upvalues: t1 (copy), v25 (copy), OpenSongDetail (copy)
		if t1.reportTileOpened then
			t1.reportTileOpened(t1.contentId)
		end

		v25(OpenSongDetail(t1.contentId))
	end, {
		v25,
		t1.contentId,
		t1.reportTileOpened
	})
	local v37 = React.useRef(nil)

	useImpressionsTagger(v37, t1.impressionsTag or "", t1.layoutOrder)

	if not song or not thumbnail then
		return nil
	end

	local v38 = if not GetFFlagLuaAppPersistentMusicPlayer() then nil else React.createElement(Foundation.View, {
		tag = "size-full col align-x-right align-y-bottom padding-small",
		stateLayer = {
			affordance = Foundation.Enums.StateLayerAffordance.None
		},
		onActivated = v33
	}, {
		TogglePlaybackButton = React.createElement(Foundation.View, {
			tag = "auto-xy bg-over-media-100 radius-circle"
		}, {
			IconButton = React.createElement(Foundation.IconButton, {
				isCircular = true,
				icon = if not v32 then Foundation.Enums.IconName.PlayLarge else Foundation.Enums.IconName.PauseLarge,
				size = Foundation.Enums.InputSize.Medium,
				variant = Foundation.Enums.ButtonVariant.Utility,
				onActivated = v33
			})
		})
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = v30,
		LayoutOrder = t1.layoutOrder,
		ZIndex = t1.zIndex,
		ref = v37
	}, {
		Tile = React.createElement(GameTileView, {
			isUnifiedGameTile = true,
			hidePlayButton = true,
			isHovered = false,
			numLinesForTitle = GameTileConstants.TileTextLines.Narrow.titleTextLines,
			Size = UDim2.fromScale(1, 1),
			image = thumbnail,
			title = song.title,
			onActivated = v36,
			footerMetadata = v35(),
			containmentSidePadding = GameTileViewConfig.getContainmentSidePadding(v26.Tokens, "Narrow"),
			isContained = not not t1.isContained,
			imageAspectRatio = GameTileViewConfig.getImageAspectRatio("Narrow"),
			thumbnailOverlay = if not GetFFlagLuaAppPersistentMusicPlayer() then nil else v38
		})
	})
end
