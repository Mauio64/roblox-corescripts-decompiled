local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)
local t = require(parent2.t)
local Foundation = require(parent2.Foundation)
local withStyle = require(parent.Core.Style.withStyle)

local Images = require(parent.App.ImageSet.Images)
local Skeleton = Foundation.Skeleton
local ImageTextLabel = require(parent.Core.Text.ImageTextLabel.ImageTextLabel)
local EmojiTextLabel = require(parent.Core.Text.EmojiTextLabel.EmojiTextLabel)
local Emoji = require(parent.Core.Emoji.Enum.Emoji)
local validateFontInfo = require(parent.Core.Style.Validator.validateFontInfo)
local validateTypographyInfo = require(parent.Core.Style.Validator.validateTypographyInfo)

local extended = Roact.PureComponent:extend("ItemTileName")

extended.validateProps = t.strictInterface({
	LayoutOrder = t.optional(t.integer),
	maxHeight = t.intersection(t.number, t.numberMin(0)),
	maxWidth = t.intersection(t.number, t.numberMin(0)),
	name = t.optional(t.string),
	titleIcon = t.optional(t.table),
	nameTextColor = t.optional(t.Color3),
	nameTextTransparency = t.optional(t.number),
	richText = t.optional(t.boolean),
	hasVerifiedBadge = t.optional(t.boolean),
	useMaxHeight = t.optional(t.boolean),
	fluidSizing = t.optional(t.boolean),
	titleFontStyle = t.optional(t.union(validateFontInfo, validateTypographyInfo)),
	horizontalAlignment = t.optional(t.enum(Enum.HorizontalAlignment))
})

function extended.render(p)
	local layoutOrder = p.props.LayoutOrder
	local maxHeight = p.props.maxHeight
	local maxWidth = p.props.maxWidth
	local name = p.props.name
	local titleIcon = p.props.titleIcon
	local useMaxHeight = p.props.useMaxHeight
	local fluidSizing = p.props.fluidSizing
	local hasVerifiedBadge = p.props.hasVerifiedBadge
	local richText = p.props.richText
	local center

	if p.props.horizontalAlignment == Enum.HorizontalAlignment.Center then
		center = Enum.TextXAlignment.Center
	else
		center = nil
	end

	return withStyle(function(p2)
		local theme = p2.Theme
		local font = p2.Font

		local titleFontStyle = p.props.titleFontStyle or font.Header2
		local v

		if titleFontStyle.RelativeSize then
			v = font.BaseSize * titleFontStyle.RelativeSize
		else
			v = titleFontStyle.FontSize
		end

		if name == nil then
			return Roact.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					LayoutOrder = layoutOrder,
					Size = UDim2.new(0, maxWidth, 0, maxHeight)
				},
				{
					FirstLine = Roact.createElement(Skeleton, { Size = UDim2.new(1, 0, 0, v) }),
					SecondLine = Roact.createElement(Skeleton, {
						Position = UDim2.fromOffset(0, v + 4),
						Size = UDim2.new(0.4, 0, 0, v)
					})
				}
			)
		end

		local vector2 = Vector2.new(maxWidth, maxHeight)

		local colorStyle = {
			Color = p.props.nameTextColor or theme.TextEmphasis.Color,
			Transparency = p.props.nameTextTransparency or theme.TextEmphasis.Transparency
		}

		if hasVerifiedBadge then
			return Roact.createElement(EmojiTextLabel, {
				RichText = richText,
				maxSize = vector2,
				fluidSizing = fluidSizing,
				emoji = Emoji.Verified,
				fontStyle = titleFontStyle,
				colorStyle = colorStyle,
				Text = name,
				TextTruncate = Enum.TextTruncate.SplitWord,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				LayoutOrder = layoutOrder
			})
		end

		local v2 = titleIcon and titleIcon.ImageRectSize / Images.ImagesResolutionScale or Vector2.new(0, 0)

		return Roact.createElement(ImageTextLabel, {
			imageProps = titleIcon and {
				BackgroundTransparency = 1,
				Image = titleIcon,
				ImageColor3 = theme.IconEmphasis.Color,
				ImageTransparency = theme.IconEmphasis.Transparency,
				Size = UDim2.new(0, v2.X, 0, v2.Y),
				AnchorPoint = Vector2.new(0, 0),
				Position = UDim2.new(0, 0, 0, 0)
			} or nil,
			genericTextLabelProps = {
				fluidSizing = fluidSizing,
				fontStyle = titleFontStyle,
				colorStyle = colorStyle,
				Text = name,
				TextTruncate = Enum.TextTruncate.SplitWord,
				RichText = richText,
				TextXAlignment = center
			},
			frameProps = { BackgroundTransparency = 1, LayoutOrder = layoutOrder },
			maxSize = vector2,
			padding = 4,
			useMaxHeight = useMaxHeight
		})
	end)
end

return extended
