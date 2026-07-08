local ParentParent = script.Parent.Parent
local ParentParent2 = ParentParent.Parent.Parent
local ParentParent2Parent = ParentParent2.Parent
local Roact = require(ParentParent2Parent.Roact)
local t = require(ParentParent2Parent.t)
local withStyle = require(ParentParent2.Core.Style.withStyle)
local GetTextSize = require(ParentParent2.Core.Text.GetTextSize)
local Images = require(ParentParent2.App.ImageSet.Images)
local ImageSetComponent = require(ParentParent2.Core.ImageSet.ImageSetComponent)
local ItemTileEnums = require(ParentParent.Enum.ItemTileEnums)
local v11 = Roact.PureComponent:extend("ItemRestrictionStatus")
local vector2 = Vector2.new(50, 20)
local vector2_2 = Vector2.new(8, 8)

v11.validateProps = t.strictInterface({
	restrictionTypes = t.map(ItemTileEnums.Restriction.isEnumValue, t.boolean),
	restrictionInfo = t.optional(t.table)
})

local function getAdditionalText(p1, p2) -- line: 33
	-- upvalues: ItemTileEnums (copy)
	local s1 = ""

	if p1[ItemTileEnums.Restriction.LimitedUnique] then
		s1 = "#"
	end

	if p1[ItemTileEnums.Restriction.Collectible] then
		return "#"
	end

	if p2 and p2.limitedSerialNumber then
		s1 ..= " " .. p2.limitedSerialNumber
	end

	return s1
end
local function getRestrictionIcon(p3) -- line: 51
	-- upvalues: ItemTileEnums (copy), Images (copy)
	if p3[ItemTileEnums.Restriction.Collectible] then
		return Images["icons/status/item/limited"]
	end

	if p3[ItemTileEnums.Restriction.Limited] or p3[ItemTileEnums.Restriction.LimitedUnique] then
		return Images["icons/status/item/limited"]
	end

	return nil
end

function v11.render(p4) -- line: 66
	-- upvalues: withStyle (copy), ItemTileEnums (copy), GetTextSize (copy), vector2 (copy), Images (copy), vector2_2 (copy), Roact (copy), ImageSetComponent (copy)
	return withStyle(function(p5) -- line: 67
		-- upvalues: p4 (copy), ItemTileEnums (copy), GetTextSize (copy), vector2 (copy), Images (copy), vector2_2 (copy), Roact (copy), ImageSetComponent (copy)
		local Theme = p5.Theme
		local p5Font = p5.Font
		local Tokens = p5.Tokens
		local restrictionInfo = p4.props.restrictionInfo
		local restrictionTypes = p4.props.restrictionTypes
		local s2 = ""

		if restrictionTypes[ItemTileEnums.Restriction.LimitedUnique] then
			s2 = "#"
		end

		if restrictionTypes[ItemTileEnums.Restriction.Collectible] then
			s2 = "#"
		elseif restrictionInfo and restrictionInfo.limitedSerialNumber then
			s2 ..= " " .. restrictionInfo.limitedSerialNumber
		end

		local CaptionHeaderFont = p5Font.CaptionHeader.Font
		local v29 = p5Font.BaseSize * p5Font.CaptionHeader.RelativeSize
		local v30 = GetTextSize(s2, v29, CaptionHeaderFont, vector2)
		local v31 = if not restrictionTypes[ItemTileEnums.Restriction.Collectible] then if not restrictionTypes[ItemTileEnums.Restriction.Limited] and not restrictionTypes[ItemTileEnums.Restriction.LimitedUnique] then nil else Images["icons/status/item/limited"] else Images["icons/status/item/limited"]
		local v32 = v31 and v31.ImageRectSize / Images.ImagesResolutionScale or Vector2.new(0, 0)
		local v33 = v32.X + v30.X + vector2_2.X
		local v34 = math.max(v32.Y, v30.Y) + vector2_2.Y

		return Roact.createElement(ImageSetComponent.Label, {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 1),
			Image = Images["component_assets/circle_17"],
			ImageColor3 = Theme.UIDefault.Color,
			ImageTransparency = Theme.UIDefault.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(8, 8, 9, 9),
			Position = UDim2.new(0, Tokens.Global.Size_100, 1, -Tokens.Global.Size_100),
			Size = UDim2.new(0, v33, 0, v34)
		}, {
			Icon = v31 and Roact.createElement(ImageSetComponent.Label, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				Image = v31,
				ImageColor3 = Theme.IconEmphasis.Color,
				ImageTransparency = Theme.IconEmphasis.Transparency,
				Position = UDim2.new(0, vector2_2.X / 2, 0.5, 0),
				Size = UDim2.new(0, v32.X, 0, v32.Y)
			}),
			Text = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Font = CaptionHeaderFont,
				TextSize = v29,
				Text = s2,
				TextColor3 = Theme.TextMuted.Color,
				TextTransparency = Theme.TextMuted.TextTransparency,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Position = UDim2.new(0, v32.X, 0, 0),
				Size = UDim2.new(0, v30.X + 10, 1, 0)
			})
		})
	end)
end

return v11
