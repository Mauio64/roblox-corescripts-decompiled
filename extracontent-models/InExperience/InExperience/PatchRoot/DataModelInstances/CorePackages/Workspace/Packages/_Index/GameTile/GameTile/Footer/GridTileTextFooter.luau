local GameTile = script:FindFirstAncestor("GameTile")
local GameTileParent = GameTile.Parent
local React = require(GameTileParent.React)
local useDesignTokens = require(GameTileParent.Style).useDesignTokens
local useTokens = require(GameTileParent.Foundation).Hooks.useTokens
local useTextSizeOffset = require(GameTileParent.UIBlox).Core.Style.useTextSizeOffset
local getGameTileMetadataFont = require(GameTile.Footer.getGameTileMetadataFont)

local function GridTileTextFooter(t1: {[any]: any}) -- line: 47
	-- upvalues: useDesignTokens (copy), useTextSizeOffset (copy), useTokens (copy), getGameTileMetadataFont (copy), React (copy)
	local v12 = useDesignTokens()
	local v13 = useTextSizeOffset()
	local v14 = useTokens()
	local v15 = if not t1.isUnifiedGameTile then v12.Size.Size_500 else v14.Size.Size_500
	local v16 = if not t1.isUnifiedGameTile then v12.Color.Content.Default else v14.Color.Content.Default
	local v17 = getGameTileMetadataFont(t1.useLargerFont, v12, v14, not not t1.isUnifiedGameTile or nil)

	return React.createElement("Frame", {
		ClipsDescendants = false,
		BackgroundTransparency = 1,
		LayoutOrder = t1.LayoutOrder,
		Size = UDim2.new(not t1.shouldSizeToContentWidth and 1 or 0, 0, 0, (v15 + v13) * (t1.linesOfText or 1)),
		AutomaticSize = if not t1.shouldSizeToContentWidth then Enum.AutomaticSize.None else Enum.AutomaticSize.X,
		Position = t1.Position,
		AnchorPoint = t1.AnchorPoint
	}, {
		Text = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = t1.text,
			Size = UDim2.new(not t1.shouldSizeToContentWidth and 1 or 0, 0, 0, (v17.FontSize + v13) * (t1.linesOfText or 1)),
			AutomaticSize = if not t1.shouldSizeToContentWidth then Enum.AutomaticSize.None else Enum.AutomaticSize.X,
			Position = UDim2.new(0, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			TextSize = v17.FontSize,
			Font = v17.Font,
			TextTransparency = v16.Transparency,
			TextColor3 = v16.Color3,
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
