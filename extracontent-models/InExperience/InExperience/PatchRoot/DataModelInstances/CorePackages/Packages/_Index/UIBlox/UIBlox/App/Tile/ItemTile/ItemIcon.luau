local parent = script.Parent.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local t = require(parent3.t)
local withStyle = require(parent2.Core.Style.withStyle)

local Images = require(parent2.App.ImageSet.Images)
local ImageSetComponent = require(parent2.Core.ImageSet.ImageSetComponent)
local ItemTileEnums = require(parent.Enum.ItemTileEnums)

local extended = Roact.PureComponent:extend("ItemIcon")

local v = {
	[ItemTileEnums.ItemIconType.AnimationBundle] = Images["icons/status/item/bundle"],
	[ItemTileEnums.ItemIconType.Bundle] = Images["icons/status/item/bundle"],
	[ItemTileEnums.ItemIconType.DynamicHead] = Images["icons/status/dynamicHead_small"]
}

local function isValidItemIconType(p)
	if v[p] then
		return true
	end

	return false, "Unknown ItemType " .. p
end

extended.validateProps = t.strictInterface({
	itemIconType = t.intersection(ItemTileEnums.ItemIconType.isEnumValue, isValidItemIconType)
})

function extended.render(p)
	local image = v[p.props.itemIconType]
	local v2 = image.ImageRectSize / Images.ImagesResolutionScale

	return withStyle(function(p2)
		local theme = p2.Theme
		local tokens = p2.Tokens

		return Roact.createElement(ImageSetComponent.Label, {
			AnchorPoint = Vector2.new(1, 1),
			BackgroundTransparency = 1,
			Image = image,
			ImageColor3 = theme.IconEmphasis.Color,
			ImageTransparency = theme.IconEmphasis.Transparency,
			Position = UDim2.new(1, -tokens.Size.Size_200, 1, -tokens.Size.Size_200),
			Size = UDim2.new(0, v2.X, 0, v2.Y)
		})
	end)
end

return extended
