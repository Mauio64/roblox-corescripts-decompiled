local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local t = require(parent3.t)
local Foundation = require(parent3.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local withStyle = require(parent2.Core.Style.withStyle)
local Images = require(parent2.App.ImageSet.Images)

local Skeleton = Foundation.Skeleton
local ImageSetComponent = require(parent2.Core.ImageSet.ImageSetComponent)
local IconSize = require(parent.ImageSet.Enum.IconSize)
local getIconSizeUDim2 = require(parent.ImageSet.getIconSizeUDim2)

local extended = Roact.PureComponent:extend("ItemSplitTileFooter")

extended.validateProps = t.strictInterface({
	priceText = t.optional(t.string),
	isOwned = t.optional(t.boolean),
	layoutOrder = t.optional(t.number)
})

function extended.render(p)
	local priceText = p.props.priceText
	local isOwned = p.props.isOwned
	local image

	if isOwned then
		image = Images["icons/status/item/owned"]
	else
		image = Images["icons/common/robux_small"]
	end

	return withStyle(function(p2)
		local font = p2.Font.Body.Font
		local textSize = p2.Font.BaseSize * p2.Font.Body.RelativeSize
		local theme = p2.Theme

		local v = priceText and tonumber(priceText:sub(1, 1)) or priceText == "--"
		local v2 = priceText and (v or isOwned)
		local iconSizeUDim2 = getIconSizeUDim2(IconSize.Small)
		local v3 = not v2 and 0 or iconSizeUDim2.Width.Offset + 4

		local createElement = Roact.createElement
		local v4 = {
			Size = UDim2.new(1, 0, 0, textSize),
			BackgroundTransparency = 1,
			LayoutOrder = p.props.layoutOrder
		}
		local shimmer

		if not priceText then
			shimmer = Roact.createElement(Skeleton, { Size = UDim2.new(0.8, 0, 0, textSize) })
		end

		return createElement("Frame", v4, {
			Shimmer = shimmer,
			Icon = v2 and Roact.createElement(ImageSetComponent.Label, {
				BackgroundTransparency = 1,
				Image = image,
				ImageColor3 = theme.TextMuted.Color,
				ImageTransparency = theme.TextMuted.Transparency,
				Size = iconSizeUDim2,
				Position = UDim2.new(0, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5)
			}),
			TextLabel = priceText and Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, v3, 0, 0),
				Size = UDim2.new(1, -v3, 1, 0),
				FontFace = normalizeFontFace(font),
				TextColor3 = theme.TextMuted.Color,
				TextTransparency = theme.TextMuted.Transparency,
				TextSize = textSize,
				Text = priceText,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center
			})
		})
	end)
end

return extended
