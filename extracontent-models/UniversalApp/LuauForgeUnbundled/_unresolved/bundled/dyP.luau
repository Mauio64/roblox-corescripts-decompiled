local module = require("@luauforge/bundled/dyQ")
local module2 = require("@luauforge/bundled/dyR")
local module3 = require("@luauforge/bundled/dyS")
local validateProps = require("@luauforge/bundled/dyT").validateProps
local useDispatch = require("@luauforge/bundled/dyU").Hooks.RoactRodux.useDispatch

local useStyle = require("@luauforge/bundled/dyV").Core.Style.useStyle

local fFlagEnableTopSongsSort = require("@luauforge/bundled/dyW").FFlagEnableTopSongsSort
local useSongTileData = require("@luauforge/bundled/dyX").useSongTileData

local useTokens = require("@luauforge/bundled/dyR").Hooks.useTokens
local gameTileView = require("@luauforge/bundled/dyY").GameTileView
local gameTileViewConfig = require("@luauforge/bundled/dyY").GameTileViewConfig
local gameTileConstants = require("@luauforge/bundled/dyY").GameTileConstants
local useImpressionsTagger = require("@luauforge/bundled/dyZ").useImpressionsTagger

local openSongDetail = require("@luauforge/bundled/dza").OpenSongDetail

local normalizeFontFace = module2.Utility.normalizeFontFace

local strictInterface = module3.strictInterface({
	contentId = module3.string,
	contentTextLineCount = module3.optional(module3.number),
	hasBackground = module3.optional(module3.boolean),
	hasOutline = module3.optional(module3.boolean),
	layoutOrder = module3.optional(module3.number),
	size = module3.optional(module3.UDim2),
	zIndex = module3.optional(module3.number),
	useLargerFooterFont = module3.optional(module3.boolean),
	impressionsTag = module3.optional(module3.string),
	reportTileOpened = module3.optional(module3.callback),
	isContained = module3.optional(module3.boolean)
})

return function(props)
	assert(fFlagEnableTopSongsSort, "Song Sort is not enabled")
	validateProps(strictInterface, props)

	local v5 = useDispatch()
	local v6 = useStyle()
	local v7 = useSongTileData(props.contentId)
	local song = v7.song
	local thumbnail = v7.thumbnail

	local size = props.size or UDim2.fromScale(1, 1)

	local v8 = useTokens()
	local v9 = module.useCallback(function()
		local artist = song and song.artist or ""

		local titleMedium = v8.Typography.TitleMedium

		return module.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, titleMedium.FontSize),
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			},
			{ module.createElement("TextLabel", {
					Text = artist,
					Size = UDim2.new(1, 0, 0, titleMedium.FontSize),
					FontFace = normalizeFontFace(titleMedium.Font),
					BackgroundTransparency = 1,
					TextWrapped = false,
					TextSize = titleMedium.FontSize,
					TextColor3 = v6.Theme.TextMuted.Color,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center
				}) }
		)
	end, { v6, song, v8 })

	local v10 = module.useCallback(function()
		if props.reportTileOpened then
			props.reportTileOpened(props.contentId)
		end

		v5(openSongDetail(props.contentId))
	end, { v5, props.contentId, props.reportTileOpened })

	local ref = module.useRef(nil)

	useImpressionsTagger(ref, props.impressionsTag or "", props.layoutOrder)

	if song and thumbnail then
		return module.createElement("Frame", {
			Size = size,
			BackgroundTransparency = 1,
			LayoutOrder = props.layoutOrder,
			ZIndex = props.zIndex,
			ref = ref
		}, {
			Tile = module.createElement(gameTileView, {
				numLinesForTitle = gameTileConstants.TileTextLines.Narrow.titleTextLines,
				Size = UDim2.fromScale(1, 1),
				image = thumbnail,
				title = song.title,
				onActivated = v10,
				footerMetadata = v9(),
				containmentSidePadding = gameTileViewConfig.getContainmentSidePadding(v6.Tokens, "Narrow"),
				isUnifiedGameTile = true,
				hidePlayButton = true,
				isContained = props.isContained and true or false,
				isHovered = false,
				imageAspectRatio = gameTileViewConfig.getImageAspectRatio("Narrow")
			})
		})
	end

	return nil
end
