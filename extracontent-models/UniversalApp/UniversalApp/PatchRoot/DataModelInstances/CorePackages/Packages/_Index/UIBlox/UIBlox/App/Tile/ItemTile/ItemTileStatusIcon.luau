local parent = script.Parent.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent

local React = require(parent3.React)
local useStyle = require(parent2.Core.Style.useStyle)

local IconSize = require(parent2.App.ImageSet.Enum.IconSize)
local Images = require(parent2.App.ImageSet.Images)
local ImageSetComponent = require(parent2.Core.ImageSet.ImageSetComponent)
local ItemTileEnums = require(parent.Enum.ItemTileEnums)
local getIconSize = require(parent2.App.ImageSet.getIconSize)

local function getIconImage(statusStyle): nil | string -- 1 equivalent call inferred from this helper
	if statusStyle == ItemTileEnums.StatusStyle.PendingIcon then
		return "icons/status/pending_small"
	end

	if statusStyle == ItemTileEnums.StatusStyle.AlertIcon then
		return "icons/actions/info_small"
	end

	return nil
end

local function ItemTileStatusIcon(p)
	local tokens = useStyle().Tokens

	local iconImage = getIconImage(p.statusStyle) -- inferred equivalent call

	if not iconImage then
		return nil
	end

	local iconSize = getIconSize(IconSize.Small)
	local emphasis = tokens.Color.Content.Emphasis

	return React.createElement(ImageSetComponent.Label, {
		Position = UDim2.fromOffset(tokens.Size.Size_200, tokens.Size.Size_200),
		Size = UDim2.fromOffset(iconSize, iconSize),
		BackgroundTransparency = 1,
		Image = Images[iconImage],
		ImageColor3 = emphasis.Color3,
		ImageTransparency = emphasis.Transparency
	})
end

return ItemTileStatusIcon
