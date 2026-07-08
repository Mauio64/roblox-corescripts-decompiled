local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParentParent.t)
local Foundation = require(ParentParentParent.Foundation)
local withStyle = require(ParentParent.Core.Style.withStyle)
local Images = require(ParentParent.App.ImageSet.Images)
local Skeleton = Foundation.Skeleton
local ImageTextLabel = require(ParentParent.Core.Text.ImageTextLabel.ImageTextLabel)
local EmojiTextLabel = require(ParentParent.Core.Text.EmojiTextLabel.EmojiTextLabel)
local Emoji = require(ParentParent.Core.Emoji.Enum.Emoji)
local validateFontInfo = require(ParentParent.Core.Style.Validator.validateFontInfo)
local validateTypographyInfo = require(ParentParent.Core.Style.Validator.validateTypographyInfo)
local v14 = Roact.PureComponent:extend("ItemTileName")

v14.validateProps = t.strictInterface({
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

function v14.render(p1) -- line: 63
	-- upvalues: withStyle (copy), Roact (copy), EmojiTextLabel (copy), Emoji (copy), Images (copy), ImageTextLabel (copy), Skeleton (copy)
	local propsLayoutOrder = p1.props.LayoutOrder
	local maxHeight = p1.props.maxHeight
	local maxWidth = p1.props.maxWidth
	local name = p1.props.name
	local titleIcon = p1.props.titleIcon
	local useMaxHeight = p1.props.useMaxHeight
	local fluidSizing = p1.props.fluidSizing
	local hasVerifiedBadge = p1.props.hasVerifiedBadge
	local richText = p1.props.richText
	local v25 = if p1.props.horizontalAlignment ~= Enum.HorizontalAlignment.Center then nil else Enum.TextXAlignment.Center

	return withStyle(function(p2) -- line: 77
		-- upvalues: p1 (copy), name (copy), maxWidth (copy), maxHeight (copy), hasVerifiedBadge (copy), Roact (copy), EmojiTextLabel (copy), richText (copy), fluidSizing (copy), Emoji (copy), propsLayoutOrder (copy), titleIcon (copy), Images (copy), ImageTextLabel (copy), v25 (copy), useMaxHeight (copy), Skeleton (copy)
		local Theme = p2.Theme
		local p2Font = p2.Font
		local v29 = p1.props.titleFontStyle or p2Font.Header2
		local v30 = if not v29.RelativeSize then v29.FontSize else p2Font.BaseSize * v29.RelativeSize

		if name ~= nil then
			local vector2 = Vector2.new(maxWidth, maxHeight)
			local t1 = {
				Color = p1.props.nameTextColor or Theme.TextEmphasis.Color,
				Transparency = p1.props.nameTextTransparency or Theme.TextEmphasis.Transparency
			}

			if hasVerifiedBadge then
				return Roact.createElement(EmojiTextLabel, {
					RichText = richText,
					maxSize = vector2,
					fluidSizing = fluidSizing,
					emoji = Emoji.Verified,
					fontStyle = v29,
					colorStyle = t1,
					Text = name,
					TextTruncate = Enum.TextTruncate.SplitWord,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					LayoutOrder = propsLayoutOrder
				})
			end

			local v33 = titleIcon and titleIcon.ImageRectSize / Images.ImagesResolutionScale or Vector2.new(0, 0)

			return Roact.createElement(ImageTextLabel, {
				padding = 4,
				imageProps = titleIcon and {
					BackgroundTransparency = 1,
					Image = titleIcon,
					ImageColor3 = Theme.IconEmphasis.Color,
					ImageTransparency = Theme.IconEmphasis.Transparency,
					Size = UDim2.new(0, v33.X, 0, v33.Y),
					AnchorPoint = Vector2.new(0, 0),
					Position = UDim2.new(0, 0, 0, 0)
				} or nil,
				genericTextLabelProps = {
					fluidSizing = fluidSizing,
					fontStyle = v29,
					colorStyle = t1,
					Text = name,
					TextTruncate = Enum.TextTruncate.SplitWord,
					RichText = richText,
					TextXAlignment = v25
				},
				frameProps = {
					BackgroundTransparency = 1,
					LayoutOrder = propsLayoutOrder
				},
				maxSize = vector2,
				useMaxHeight = useMaxHeight
			})
		end

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = propsLayoutOrder,
			Size = UDim2.new(0, maxWidth, 0, maxHeight)
		}, {
			FirstLine = Roact.createElement(Skeleton, {
				Size = UDim2.new(1, 0, 0, v30)
			}),
			SecondLine = Roact.createElement(Skeleton, {
				Position = UDim2.fromOffset(0, v30 + 4),
				Size = UDim2.new(0.4, 0, 0, v30)
			})
		})
	end)
end

return v14
