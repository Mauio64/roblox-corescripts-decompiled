local GameTile = script:FindFirstAncestor("GameTile")

local parent = GameTile.Parent
local React = require(parent.React)
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local UIBlox = require(parent.UIBlox)

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getGameTileMetadataFont = require(GameTile.Footer.getGameTileMetadataFont)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local GameTileTypes = require(GameTile.GameTileTypes)

local function GridTileIconTextFooter(props)
	local v = useDesignTokens()
	local v2 = useTextSizeOffset()
	local v3 = useTokens()
	local size_500

	if props.isUnifiedGameTile then
		size_500 = v3.Size.Size_500
	else
		size_500 = v.Size.Size_500
	end

	local v4

	if props.isUnifiedGameTile then
		if props.isNarrowScreenXSmall and props.gameTileLayoutType == GameTileTypes.GameTileLayoutType.Narrow then
			v4 = v3.Gap.XXSmall
		else
			v4 = v3.Gap.XSmall
		end
	else
		v4 = v.Size.Size_100
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
		v3 or nil,
		props.isUnifiedGameTile and true or nil
	)

	local fontSize = gameTileMetadataFont.FontSize
	local v5, v6

	if props.iconSize then
		v5 = props.iconSize
		v6 = v.Size.Size_500
	else
		v5 = fontSize / 1.26
		v6 = v5
	end

	local createElement = React.createElement
	local v7 = {
		Size = UDim2.new(1, 0, 0, size_500 + v2),
		AutomaticSize = Enum.AutomaticSize.None,
		Position = props.Position,
		ClipsDescendants = false,
		BackgroundTransparency = 1
	}

	local createElement2 = React.createElement
	local v8 = {
		LayoutOrder = 1,
		Size = UDim2.fromOffset(v6, v6),
		ClipsDescendants = false,
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0, 0.5),
		AnchorPoint = Vector2.new(0, 0.5)
	}
	local icon

	if props.iconElement then
		icon = props.iconElement
	else
		icon = React.createElement(ImageSetLabel, {
			Image = props.icon,
			ImageColor3 = default.Color3,
			ImageTransparency = 0,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(v5, v5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1
		})
	end

	local children = {
		IconSlot = createElement2("Frame", v8, { Icon = icon }),
		Text = 0
	}

	local createElement3 = React.createElement
	local v9 = {
		LayoutOrder = 2,
		Text = props.text,
		Size = UDim2.new(1, -(v6 + v4), 0, fontSize + v2),
		AutomaticSize = Enum.AutomaticSize.None,
		Position = UDim2.new(0, v6 + v4, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		TextSize = fontSize,
		Font = 0,
		FontFace = 0,
		TextTransparency = 0,
		TextColor3 = 0,
		TextWrapped = false,
		TextTruncate = 0,
		TextXAlignment = 0,
		TextYAlignment = 0
	}
	local font

	if not FoundationFontFaceMigration then
		font = gameTileMetadataFont.Font
	end

	v9.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(gameTileMetadataFont.Font)
	end

	v9.FontFace = fontFace
	v9.TextTransparency = default.Transparency
	v9.TextColor3 = default.Color3

	v9.TextTruncate = Enum.TextTruncate.AtEnd
	v9.TextXAlignment = Enum.TextXAlignment.Left
	v9.TextYAlignment = Enum.TextYAlignment.Center
	children.Text = createElement3("TextLabel", v9)
	return createElement("Frame", v7, children)
end

return GridTileIconTextFooter
