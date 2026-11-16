local module = require("@luauforge/bundled/dvN")
local module2 = require("@luauforge/bundled/dvO")
local module3 = require("@luauforge/bundled/dvP")
local validateProps = require("@luauforge/bundled/dvQ").validateProps
local useDispatch = require("@luauforge/bundled/dvR").Hooks.RoactRodux.useDispatch

local useStyle = require("@luauforge/bundled/dvS").Core.Style.useStyle

local fFlagEnableTopSongsSort = require("@luauforge/bundled/dvT").FFlagEnableTopSongsSort
local foundationFontFaceMigration = module2.Utility.Flags.FoundationFontFaceMigration
local useSongTileData = require("@luauforge/bundled/dvU").useSongTileData

local useTokens = require("@luauforge/bundled/dvO").Hooks.useTokens
local gameTileView = require("@luauforge/bundled/dvV").GameTileView
local gameTileViewConfig = require("@luauforge/bundled/dvV").GameTileViewConfig
local gameTileConstants = require("@luauforge/bundled/dvV").GameTileConstants
local useImpressionsTagger = require("@luauforge/bundled/dvW").useImpressionsTagger

local openSongDetail = require("@luauforge/bundled/dvX").OpenSongDetail

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

		local createElement = module.createElement
		local v11 = {
			Size = UDim2.new(1, 0, 0, titleMedium.FontSize),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}

		local createElement2 = module.createElement
		local v14 = {
			Text = artist,
			Size = UDim2.new(1, 0, 0, titleMedium.FontSize),
			Font = 0,
			FontFace = 0,
			BackgroundTransparency = 1,
			TextWrapped = false,
			TextSize = 0,
			TextColor3 = 0,
			TextTruncate = 0,
			TextXAlignment = 0,
			TextYAlignment = 0
		}
		local v15 = if not foundationFontFaceMigration then v8.Typography.TitleMedium.Font else nil
		v14.Font = v15
		local v16 = if foundationFontFaceMigration then normalizeFontFace(titleMedium.Font) else nil
		v14.FontFace = v16

		v14.TextSize = titleMedium.FontSize
		v14.TextColor3 = v6.Theme.TextMuted.Color
		v14.TextTruncate = Enum.TextTruncate.AtEnd
		v14.TextXAlignment = Enum.TextXAlignment.Left
		v14.TextYAlignment = Enum.TextYAlignment.Center
		return createElement("Frame", v11, { createElement2("TextLabel", v14) })
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
