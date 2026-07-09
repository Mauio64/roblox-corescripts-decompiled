local GameTile = script:FindFirstAncestor("GameTile")
local GameTileParent = GameTile.Parent
local React = require(GameTileParent.React)
local useDesignTokens = require(GameTileParent.Style).useDesignTokens
local UIBlox = require(GameTileParent.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(GameTileParent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getGameTileMetadataFont = require(GameTile.Footer.getGameTileMetadataFont)
local useTokens = require(GameTileParent.Foundation).Hooks.useTokens
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local GameTileTypes = require(GameTile.GameTileTypes)

local function GridTileIconTextFooter(t1: {[any]: any}) -- line: 52
	-- upvalues: useDesignTokens (copy), useTextSizeOffset (copy), useTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), GameTileTypes (copy), getGameTileMetadataFont (copy), React (copy), ImageSetLabel (copy)
	local v14 = useDesignTokens()
	local v15 = useTextSizeOffset()
	local v16 = useTokens()
	local v17 = if not t1.isUnifiedGameTile then if not FFlagRenameDeprecatedUIBloxTokens then v14.Global.Space_250 else v14.Size.Size_500 else v16.Size.Size_500
	local v18 = if not t1.isUnifiedGameTile then if not FFlagRenameDeprecatedUIBloxTokens then v14.Global.Space_50 else v14.Size.Size_100 else if not t1.isNarrowScreenXSmall or t1.gameTileLayoutType ~= GameTileTypes.GameTileLayoutType.Narrow then v16.Gap.XSmall else v16.Gap.XXSmall
	local v19 = if not t1.isUnifiedGameTile then if not FFlagRenameDeprecatedUIBloxTokens then v14.Semantic.Color.Text.Default else v14.Color.Content.Default else v16.Color.Content.Default
	local v20 = getGameTileMetadataFont(t1.useLargerFont, v14, v16 or nil, not not t1.isUnifiedGameTile or nil)
	local FontSize = v20.FontSize
	local iconSize, v23

	if t1.iconSize then
		iconSize = t1.iconSize
		v23 = if not FFlagRenameDeprecatedUIBloxTokens then v14.Global.Size_250 else v14.Size.Size_500
	else
		iconSize = FontSize / 1.26
		v23 = iconSize
	end

	return React.createElement("Frame", {
		ClipsDescendants = false,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v17 + v15),
		AutomaticSize = Enum.AutomaticSize.None,
		Position = t1.Position
	}, {
		IconSlot = React.createElement("Frame", {
			LayoutOrder = 1,
			ClipsDescendants = false,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(v23, v23),
			Position = UDim2.fromScale(0, 0.5),
			AnchorPoint = Vector2.new(0, 0.5)
		}, {
			Icon = if not t1.iconElement then React.createElement(ImageSetLabel, {
				ImageTransparency = 0,
				BackgroundTransparency = 1,
				Image = t1.icon,
				ImageColor3 = v19.Color3,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(iconSize, iconSize),
				AnchorPoint = Vector2.new(0.5, 0.5)
			}) else t1.iconElement
		}),
		Text = React.createElement("TextLabel", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			TextWrapped = false,
			Text = t1.text,
			Size = UDim2.new(1, -(v23 + v18), 0, FontSize + v15),
			AutomaticSize = Enum.AutomaticSize.None,
			Position = UDim2.new(0, v23 + v18, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			TextSize = FontSize,
			Font = v20.Font,
			TextTransparency = v19.Transparency,
			TextColor3 = v19.Color3,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center
		})
	})
end

return GridTileIconTextFooter
