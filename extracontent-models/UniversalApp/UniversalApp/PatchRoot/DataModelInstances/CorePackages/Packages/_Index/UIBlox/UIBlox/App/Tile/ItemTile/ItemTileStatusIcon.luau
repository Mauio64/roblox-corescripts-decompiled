local ParentParent = script.Parent.Parent
local ParentParent2 = ParentParent.Parent.Parent
local ParentParent2Parent = ParentParent2.Parent
local React = require(ParentParent2Parent.React)
local useStyle = require(ParentParent2.Core.Style.useStyle)
local IconSize = require(ParentParent2.App.ImageSet.Enum.IconSize)
local Images = require(ParentParent2.App.ImageSet.Images)
local ImageSetComponent = require(ParentParent2.Core.ImageSet.ImageSetComponent)
local ItemTileEnums = require(ParentParent.Enum.ItemTileEnums)
local getIconSize = require(ParentParent2.App.ImageSet.getIconSize)

local function getIconImage(p1) -- line: 21
	-- upvalues: ItemTileEnums (copy)
	if p1 == ItemTileEnums.StatusStyle.PendingIcon then
		return "icons/status/pending_small"
	end

	if p1 == ItemTileEnums.StatusStyle.AlertIcon then
		return "icons/actions/info_small"
	end

	return nil
end
local function ItemTileStatusIcon(t1: {[any]: any}) -- line: 31
	-- upvalues: useStyle (copy), ItemTileEnums (copy), getIconSize (copy), IconSize (copy), React (copy), ImageSetComponent (copy), Images (copy)
	local Tokens = useStyle().Tokens
	local statusStyle = t1.statusStyle
	local v17 = if statusStyle ~= ItemTileEnums.StatusStyle.PendingIcon then if statusStyle ~= ItemTileEnums.StatusStyle.AlertIcon then nil else "icons/actions/info_small" else "icons/status/pending_small"

	if not v17 then
		return nil
	end

	local v18 = getIconSize(IconSize.Small)
	local Emphasis = Tokens.Semantic.Color.Icon.Emphasis

	return React.createElement(ImageSetComponent.Label, {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(Tokens.Global.Size_100, Tokens.Global.Size_100),
		Size = UDim2.fromOffset(v18, v18),
		Image = Images[v17],
		ImageColor3 = Emphasis.Color3,
		ImageTransparency = Emphasis.Transparency
	})
end

return ItemTileStatusIcon
