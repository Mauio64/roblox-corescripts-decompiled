local ParentParent = script.Parent.Parent
local ParentParent2 = ParentParent.Parent.Parent
local ParentParent2Parent = ParentParent2.Parent
local Roact = require(ParentParent2Parent.Roact)
local t = require(ParentParent2Parent.t)
local withStyle = require(ParentParent2.Core.Style.withStyle)
local Images = require(ParentParent2.App.ImageSet.Images)
local ImageSetComponent = require(ParentParent2.Core.ImageSet.ImageSetComponent)
local ItemTileEnums = require(ParentParent.Enum.ItemTileEnums)
local v10 = Roact.PureComponent:extend("ItemIcon")
local t1 = {
	[ItemTileEnums.ItemIconType.AnimationBundle] = Images["icons/status/item/bundle"],
	[ItemTileEnums.ItemIconType.Bundle] = Images["icons/status/item/bundle"],
	[ItemTileEnums.ItemIconType.DynamicHead] = Images["icons/status/dynamicHead_small"]
}

local function isValidItemIconType(p1) -- line: 24
	-- upvalues: t1 (copy)
	if t1[p1] then
		return true
	end

	return false, "Unknown ItemType " .. p1
end

v10.validateProps = t.strictInterface({
	itemIconType = t.intersection(ItemTileEnums.ItemIconType.isEnumValue, isValidItemIconType)
})

function v10.render(p2) -- line: 37
	-- upvalues: t1 (copy), Images (copy), withStyle (copy), Roact (copy), ImageSetComponent (copy)
	local v15 = t1[p2.props.itemIconType]
	local v16 = v15.ImageRectSize / Images.ImagesResolutionScale

	return withStyle(function(p3) -- line: 43
		-- upvalues: Roact (copy), ImageSetComponent (copy), v15 (copy), v16 (copy)
		local Theme = p3.Theme
		local Tokens = p3.Tokens

		return Roact.createElement(ImageSetComponent.Label, {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 1),
			Image = v15,
			ImageColor3 = Theme.IconEmphasis.Color,
			ImageTransparency = Theme.IconEmphasis.Transparency,
			Position = UDim2.new(1, -Tokens.Global.Size_100, 1, -Tokens.Global.Size_100),
			Size = UDim2.new(0, v16.X, 0, v16.Y)
		})
	end)
end

return v10
