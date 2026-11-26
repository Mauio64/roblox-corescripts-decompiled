local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Style").useDesignTokens
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Foundation")
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useTextSizeOffset = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/UIBlox").Core.Style.useTextSizeOffset

local getGameTileMetadataFont = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/getGameTileMetadataFont")

local function GridTileTextFooter(props)
	local v5 = useDesignTokens()
	local v6 = useTextSizeOffset()
	local v7 = useTokens()
	local size_500 = if props.isUnifiedGameTile then v7.Size.Size_500 else v5.Size.Size_500
	local default = if props.isUnifiedGameTile then v7.Color.Content.Default else v5.Color.Content.Default
	local v8 = getGameTileMetadataFont(props.useLargerFont, v5, v7, props.isUnifiedGameTile and true or nil)

	local createElement = React.createElement
	local v10 = {
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.new(
			props.shouldSizeToContentWidth and 0 or 1,
			0,
			0,
			(size_500 + v6) * (props.linesOfText or 1)
		),
		AutomaticSize = 0,
		Position = 0,
		AnchorPoint = 0,
		ClipsDescendants = false,
		BackgroundTransparency = 1
	}

	local v11 = if props.shouldSizeToContentWidth then Enum.AutomaticSize.X else Enum.AutomaticSize.None
	v10.AutomaticSize = v11
	v10.Position = props.Position
	v10.AnchorPoint = props.AnchorPoint

	local createElement2 = React.createElement
	local v14 = {
		Text = props.text,
		Size = UDim2.new(
			props.shouldSizeToContentWidth and 0 or 1,
			0,
			0,
			(v8.FontSize + v6) * (props.linesOfText or 1)
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

	local v15 = if props.shouldSizeToContentWidth then Enum.AutomaticSize.X else Enum.AutomaticSize.None
	v14.AutomaticSize = v15
	v14.Position = UDim2.new(0, 0, 0.5, 0)
	v14.AnchorPoint = Vector2.new(0, 0.5)

	v14.TextSize = v8.FontSize
	v14.FontFace = normalizeFontFace(v8.Font)
	v14.TextTransparency = default.Transparency
	v14.TextColor3 = default.Color3
	v14.TextWrapped = props.TextWrapped or false
	v14.TextTruncate = Enum.TextTruncate.AtEnd
	v14.TextXAlignment = Enum.TextXAlignment.Left
	v14.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center
	v14.ClipsDescendants = props.ClipsDescendants
	v14.RichText = props.RichText
	return createElement("Frame", v10, {
		Text = createElement2("TextLabel", v14)
	})
end

return GridTileTextFooter
