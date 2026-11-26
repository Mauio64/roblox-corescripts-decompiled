local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Style").useDesignTokens
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/UIBlox")

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getGameTileMetadataFont = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/getGameTileMetadataFont")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Foundation")
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local GameTileTypes = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileTypes")

local function GridTileIconTextFooter(props)
	local v5 = useDesignTokens()
	local v6 = useTextSizeOffset()
	local v7 = useTokens()
	local size_500 = if props.isUnifiedGameTile then v7.Size.Size_500 else v5.Size.Size_500
	local v8

	if props.isUnifiedGameTile then
		if props.isNarrowScreenXSmall and props.gameTileLayoutType == GameTileTypes.GameTileLayoutType.Narrow then
			v8 = v7.Gap.XXSmall
		else
			v8 = v7.Gap.XSmall
		end
	else
		v8 = v5.Size.Size_100
	end

	local default = if props.isUnifiedGameTile then v7.Color.Content.Default else v5.Color.Content.Default
	local v9 = getGameTileMetadataFont(props.useLargerFont, v5, v7 or nil, props.isUnifiedGameTile and true or nil)

	local fontSize = v9.FontSize
	local v10, v11

	if props.iconSize then
		v10 = props.iconSize
		v11 = v5.Size.Size_500
	else
		v10 = fontSize / 1.26
		v11 = v10
	end

	local createElement = React.createElement
	local v13 = {
		Size = UDim2.new(1, 0, 0, size_500 + v6),
		AutomaticSize = Enum.AutomaticSize.None,
		Position = props.Position,
		ClipsDescendants = false,
		BackgroundTransparency = 1
	}

	local createElement2 = React.createElement
	local v15 = {
		LayoutOrder = 1,
		Size = UDim2.fromOffset(v11, v11),
		ClipsDescendants = false,
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0, 0.5),
		AnchorPoint = Vector2.new(0, 0.5)
	}

	local v17 = if props.iconElement then props.iconElement else React.createElement(imageSetLabel, {
		Image = props.icon,
		ImageColor3 = default.Color3,
		ImageTransparency = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(v10, v10),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1
	})
	return createElement("Frame", v13, {
		IconSlot = createElement2("Frame", v15, { Icon = v17 }),
		Text = React.createElement("TextLabel", {
			LayoutOrder = 2,
			Text = props.text,
			Size = UDim2.new(1, -(v11 + v8), 0, fontSize + v6),
			AutomaticSize = Enum.AutomaticSize.None,
			Position = UDim2.new(0, v11 + v8, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			TextSize = fontSize,
			FontFace = normalizeFontFace(v9.Font),
			TextTransparency = default.Transparency,
			TextColor3 = default.Color3,
			TextWrapped = false,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center
		})
	})
end

return GridTileIconTextFooter
