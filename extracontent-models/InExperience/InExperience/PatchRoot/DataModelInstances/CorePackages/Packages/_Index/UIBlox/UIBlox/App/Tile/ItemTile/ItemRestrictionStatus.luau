local parent = script.Parent.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local t = require(parent3.t)
local Foundation = require(parent3.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local withStyle = require(parent2.Core.Style.withStyle)

local GetTextSize = require(parent2.Core.Text.GetTextSize)
local Images = require(parent2.App.ImageSet.Images)
local ImageSetComponent = require(parent2.Core.ImageSet.ImageSetComponent)

local ItemTileEnums = require(parent.Enum.ItemTileEnums)

local extended = Roact.PureComponent:extend("ItemRestrictionStatus")

local vector2 = Vector2.new(50, 20)
local vector2_2 = Vector2.new(8, 8)

extended.validateProps = t.strictInterface({
	restrictionTypes = t.map(ItemTileEnums.Restriction.isEnumValue, t.boolean),
	restrictionInfo = t.optional(t.table)
})

local function getAdditionalText(restrictionTypes, restrictionInfo) -- 1 equivalent call inferred from this helper
	local v = restrictionTypes[ItemTileEnums.Restriction.LimitedUnique] and "#" or ""

	if restrictionTypes[ItemTileEnums.Restriction.Collectible] then
		return "#"
	end

	if restrictionInfo and restrictionInfo.limitedSerialNumber then
		return v .. " " .. restrictionInfo.limitedSerialNumber
	end

	return v
end

local function getRestrictionIcon(restrictionTypes) -- 1 equivalent call inferred from this helper
	if
		restrictionTypes[ItemTileEnums.Restriction.Collectible]
		or (restrictionTypes[ItemTileEnums.Restriction.Limited] or restrictionTypes[ItemTileEnums.Restriction.LimitedUnique])
	then
		return Images["icons/status/item/limited"]
	end

	return nil
end

function extended.render(p)
	return withStyle(function(props)
		local theme = props.Theme
		local font = props.Font
		local tokens = props.Tokens

		local restrictionInfo = p.props.restrictionInfo
		local restrictionTypes = p.props.restrictionTypes
		local additionalText = getAdditionalText(restrictionTypes, restrictionInfo) -- inferred equivalent call
		local font2 = font.CaptionHeader.Font
		local textSize = font.BaseSize * font.CaptionHeader.RelativeSize
		local textSize2 = GetTextSize(additionalText, textSize, font2, vector2)
		local restrictionIcon = getRestrictionIcon(restrictionTypes) -- inferred equivalent call
		local v = restrictionIcon and restrictionIcon.ImageRectSize / Images.ImagesResolutionScale or Vector2.new(0, 0)

		local v2 = v.X + textSize2.X + vector2_2.X
		local v3 = math.max(v.Y, textSize2.Y) + vector2_2.Y

		return Roact.createElement(ImageSetComponent.Label, {
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = 1,
			Image = Images["component_assets/circle_17"],
			ImageColor3 = theme.UIDefault.Color,
			ImageTransparency = theme.UIDefault.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(8, 8, 9, 9),
			Position = UDim2.new(0, tokens.Size.Size_200, 1, -tokens.Size.Size_200),
			Size = UDim2.new(0, v2, 0, v3)
		}, {
			Icon = restrictionIcon and Roact.createElement(ImageSetComponent.Label, {
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				Image = restrictionIcon,
				ImageColor3 = theme.IconEmphasis.Color,
				ImageTransparency = theme.IconEmphasis.Transparency,
				Position = UDim2.new(0, vector2_2.X / 2, 0.5, 0),
				Size = UDim2.new(0, v.X, 0, v.Y)
			}),
			Text = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				FontFace = normalizeFontFace(font2),
				TextSize = textSize,
				Text = additionalText,
				TextColor3 = theme.TextMuted.Color,
				TextTransparency = theme.TextMuted.TextTransparency,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Position = UDim2.new(0, v.X, 0, 0),
				Size = UDim2.new(0, textSize2.X + 10, 1, 0)
			})
		})
	end)
end

return extended
