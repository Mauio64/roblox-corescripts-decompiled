local GameTile = script:FindFirstAncestor("GameTile")

local parent = GameTile.Parent
local React = require(parent.React)

local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local UIBlox = require(parent.UIBlox)
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset

local getGameTileMetadataFont = require(GameTile.Footer.getGameTileMetadataFont)

local function fn(p: number, linesOfText: number?) -- 2 equivalent calls inferred from this helper
	return p * (linesOfText or 1)
end

local function GridTileTextFooter(props)
	local v = useDesignTokens()
	local v2 = useTextSizeOffset()
	local v3 = useTokens()
	local size_500

	if props.isUnifiedGameTile then
		size_500 = v3.Size.Size_500
	else
		size_500 = v.Size.Size_500
	end

	local default

	if props.isUnifiedGameTile then
		default = v3.Color.Content.Default
	else
		default = v.Color.Content.Default
	end

	local gameTileMetadataFont = getGameTileMetadataFont(
		props.useLargerFont,
		v,
		v3,
		props.isUnifiedGameTile and true or nil
	)

	local createElement = React.createElement
	local v4 = {
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.new(props.shouldSizeToContentWidth and 0 or 1, 0, 0, fn(size_500 + v2, props.linesOfText)), -- inferred equivalent call
		AutomaticSize = 0,
		Position = 0,
		AnchorPoint = 0,
		ClipsDescendants = false,
		BackgroundTransparency = 1
	}
	local automaticSize

	if props.shouldSizeToContentWidth then
		automaticSize = Enum.AutomaticSize.X
	else
		automaticSize = Enum.AutomaticSize.None
	end

	v4.AutomaticSize = automaticSize
	v4.Position = props.Position
	v4.AnchorPoint = props.AnchorPoint

	local createElement2 = React.createElement
	local v5 = {
		Text = props.text,
		Size = UDim2.new(
			props.shouldSizeToContentWidth and 0 or 1,
			0,
			0,
			fn(gameTileMetadataFont.FontSize + v2, props.linesOfText) -- inferred equivalent call
		),
		AutomaticSize = 0,
		Position = 0,
		AnchorPoint = 0,
		BackgroundTransparency = 1,
		TextSize = 0,
		FontFace = 0,
		TextTransparency = 0,
		TextColor3 = 0,
		TextWrapped = 0,
		TextTruncate = 0,
		TextXAlignment = 0,
		TextYAlignment = 0,
		ClipsDescendants = 0,
		RichText = 0
	}
	local automaticSize2

	if props.shouldSizeToContentWidth then
		automaticSize2 = Enum.AutomaticSize.X
	else
		automaticSize2 = Enum.AutomaticSize.None
	end

	v5.AutomaticSize = automaticSize2
	v5.Position = UDim2.new(0, 0, 0.5, 0)
	v5.AnchorPoint = Vector2.new(0, 0.5)

	v5.TextSize = gameTileMetadataFont.FontSize
	v5.FontFace = normalizeFontFace(gameTileMetadataFont.Font)
	v5.TextTransparency = default.Transparency
	v5.TextColor3 = default.Color3
	v5.TextWrapped = props.TextWrapped or false
	v5.TextTruncate = Enum.TextTruncate.AtEnd
	v5.TextXAlignment = Enum.TextXAlignment.Left
	v5.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center
	v5.ClipsDescendants = props.ClipsDescendants
	v5.RichText = props.RichText
	return createElement("Frame", v4, {
		Text = createElement2("TextLabel", v5)
	})
end

return GridTileTextFooter
