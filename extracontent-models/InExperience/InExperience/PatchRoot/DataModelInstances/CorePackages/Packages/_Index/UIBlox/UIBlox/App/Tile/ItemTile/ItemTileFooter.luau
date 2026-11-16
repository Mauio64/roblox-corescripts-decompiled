local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)
local t = require(parent2.t)
local Foundation = require(parent2.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local withStyle = require(parent.Core.Style.withStyle)
local Images = require(parent.App.ImageSet.Images)

local Skeleton = Foundation.Skeleton
local ImageSetComponent = require(parent.Core.ImageSet.ImageSetComponent)

local extended = Roact.PureComponent:extend("ItemTileFooter")

extended.validateProps = t.strictInterface({
	priceText = t.optional(t.string),
	isOwned = t.optional(t.boolean)
})

function extended.render(p)
	local priceText = p.props.priceText
	local isOwned = p.props.isOwned

	local image = Images["icons/common/robux_small"]

	if isOwned then
		image = Images["icons/status/item/owned"]
	end

	return withStyle(function(p2)
		local font = p2.Font.SubHeader1.Font
		local textSize = p2.Font.BaseSize * p2.Font.SubHeader1.RelativeSize
		local theme = p2.Theme

		local v = image.ImageRectSize / Images.ImagesResolutionScale

		local v2 = priceText and tonumber(priceText:sub(1, 1))
		local v3 = priceText and (v2 or isOwned)
		local v4 = not v3 and 0 or v.X + 4

		return Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1
		}, {
			Shimmer = not priceText and Roact.createElement(Skeleton, {
				Size = UDim2.new(0.8, 0, 0, textSize)
			}),
			icon = v3 and Roact.createElement(ImageSetComponent.Label, {
				BackgroundTransparency = 1,
				Image = image,
				ImageColor3 = theme.IconEmphasis.Color,
				ImageTransparency = theme.IconEmphasis.Transparency,
				Size = UDim2.new(0, v.X, 0, v.Y)
			}),
			TextLabel = priceText and Roact.createElement("TextLabel", {
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, 0, 0, 0),
				Size = UDim2.new(1, -v4, 1, 0),
				FontFace = normalizeFontFace(font),
				TextColor3 = theme.SecondaryContent.Color,
				TextTransparency = theme.SecondaryContent.Transparency,
				TextSize = textSize,
				Text = priceText,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top
			})
		})
	end)
end

return extended
