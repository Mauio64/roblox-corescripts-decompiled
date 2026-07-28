local GameTile = script:FindFirstAncestor("GameTile")
local GameTileParent = GameTile.Parent
local React = require(GameTileParent.React)
local useDesignTokens = require(GameTileParent.Style).useDesignTokens
local UIBlox = require(GameTileParent.UIBlox)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getGameTileMetadataFont = require(GameTile.Footer.getGameTileMetadataFont)
local useTokens = require(GameTileParent.Foundation).Hooks.useTokens
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local GameTileTypes = require(GameTile.GameTileTypes)

local function GridTileIconTextFooter(t1: {[any]: any}) -- line: 48
	-- upvalues: useDesignTokens (copy), useTextSizeOffset (copy), useTokens (copy), GameTileTypes (copy), getGameTileMetadataFont (copy), React (copy), ImageSetLabel (copy)
	local v13 = useDesignTokens()
	local v14 = useTextSizeOffset()
	local v15 = useTokens()
	local v16 = if not t1.isUnifiedGameTile then v13.Size.Size_500 else v15.Size.Size_500
	local v17 = if not t1.isUnifiedGameTile then v13.Size.Size_100 else if not t1.isNarrowScreenXSmall or t1.gameTileLayoutType ~= GameTileTypes.GameTileLayoutType.Narrow then v15.Gap.XSmall else v15.Gap.XXSmall
	local v18 = if not t1.isUnifiedGameTile then v13.Color.Content.Default else v15.Color.Content.Default
	local v19 = getGameTileMetadataFont(t1.useLargerFont, v13, v15 or nil, not not t1.isUnifiedGameTile or nil)
	local FontSize = v19.FontSize
	local iconSize, Size_500

	if t1.iconSize then
		iconSize = t1.iconSize
		Size_500 = v13.Size.Size_500
	else
		iconSize = FontSize / 1.26
		Size_500 = iconSize
	end

	return React.createElement("Frame", {
		ClipsDescendants = false,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v16 + v14),
		AutomaticSize = Enum.AutomaticSize.None,
		Position = t1.Position
	}, {
		IconSlot = React.createElement("Frame", {
			LayoutOrder = 1,
			ClipsDescendants = false,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(Size_500, Size_500),
			Position = UDim2.fromScale(0, 0.5),
			AnchorPoint = Vector2.new(0, 0.5)
		}, {
			Icon = if not t1.iconElement then React.createElement(ImageSetLabel, {
				ImageTransparency = 0,
				BackgroundTransparency = 1,
				Image = t1.icon,
				ImageColor3 = v18.Color3,
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
			Size = UDim2.new(1, -(Size_500 + v17), 0, FontSize + v14),
			AutomaticSize = Enum.AutomaticSize.None,
			Position = UDim2.new(0, Size_500 + v17, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			TextSize = FontSize,
			Font = v19.Font,
			TextTransparency = v18.Transparency,
			TextColor3 = v18.Color3,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center
		})
	})
end

return GridTileIconTextFooter
