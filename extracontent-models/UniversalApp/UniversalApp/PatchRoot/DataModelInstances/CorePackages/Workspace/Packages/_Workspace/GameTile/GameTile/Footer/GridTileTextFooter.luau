local GameTile = script:FindFirstAncestor("GameTile")
local GameTileParent = GameTile.Parent
local React = require(GameTileParent.React)
local FFlagRenameDeprecatedUIBloxTokens = require(GameTileParent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useDesignTokens = require(GameTileParent.Style).useDesignTokens
local useTokens = require(GameTileParent.Foundation).Hooks.useTokens
local useTextSizeOffset = require(GameTileParent.UIBlox).Core.Style.useTextSizeOffset
local getGameTileMetadataFont = require(GameTile.Footer.getGameTileMetadataFont)

local function GridTileTextFooter(t1: {[any]: any}) -- line: 49
	-- upvalues: useDesignTokens (copy), useTextSizeOffset (copy), useTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), getGameTileMetadataFont (copy), React (copy)
	local v13 = useDesignTokens()
	local v14 = useTextSizeOffset()
	local v15 = useTokens()
	local v16 = if not t1.isUnifiedGameTile then if not FFlagRenameDeprecatedUIBloxTokens then v13.Global.Space_250 else v13.Size.Size_500 else v15.Size.Size_500
	local v17 = if not t1.isUnifiedGameTile then if not FFlagRenameDeprecatedUIBloxTokens then v13.Semantic.Color.Text.Default else v13.Color.Content.Default else v15.Color.Content.Default
	local v18 = getGameTileMetadataFont(t1.useLargerFont, v13, v15, not not t1.isUnifiedGameTile or nil)

	return React.createElement("Frame", {
		ClipsDescendants = false,
		BackgroundTransparency = 1,
		LayoutOrder = t1.LayoutOrder,
		Size = UDim2.new(not t1.shouldSizeToContentWidth and 1 or 0, 0, 0, (v16 + v14) * (t1.linesOfText or 1)),
		AutomaticSize = if not t1.shouldSizeToContentWidth then Enum.AutomaticSize.None else Enum.AutomaticSize.X,
		Position = t1.Position,
		AnchorPoint = t1.AnchorPoint
	}, {
		Text = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = t1.text,
			Size = UDim2.new(not t1.shouldSizeToContentWidth and 1 or 0, 0, 0, (v18.FontSize + v14) * (t1.linesOfText or 1)),
			AutomaticSize = if not t1.shouldSizeToContentWidth then Enum.AutomaticSize.None else Enum.AutomaticSize.X,
			Position = UDim2.new(0, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			TextSize = v18.FontSize,
			Font = v18.Font,
			TextTransparency = v17.Transparency,
			TextColor3 = v17.Color3,
			TextWrapped = t1.TextWrapped or false,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = t1.TextYAlignment or Enum.TextYAlignment.Center,
			ClipsDescendants = t1.ClipsDescendants,
			RichText = t1.RichText
		})
	})
end

return GridTileTextFooter
