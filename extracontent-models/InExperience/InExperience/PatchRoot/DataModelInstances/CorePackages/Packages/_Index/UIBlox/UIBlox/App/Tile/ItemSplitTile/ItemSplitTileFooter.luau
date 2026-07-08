local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Roact = require(ParentParentParentParent.Roact)
local t = require(ParentParentParentParent.t)
local Foundation = require(ParentParentParentParent.Foundation)
local withStyle = require(ParentParentParent.Core.Style.withStyle)
local Images = require(ParentParentParent.App.ImageSet.Images)
local Skeleton = Foundation.Skeleton
local ImageSetComponent = require(ParentParentParent.Core.ImageSet.ImageSetComponent)
local IconSize = require(ParentParent.ImageSet.Enum.IconSize)
local getIconSizeUDim2 = require(ParentParent.ImageSet.getIconSizeUDim2)
local v13 = Roact.PureComponent:extend("ItemSplitTileFooter")

v13.validateProps = t.strictInterface({
	priceText = t.optional(t.string),
	isOwned = t.optional(t.boolean),
	layoutOrder = t.optional(t.number)
})

function v13.render(p1) -- line: 33
	-- upvalues: Images (copy), withStyle (copy), getIconSizeUDim2 (copy), IconSize (copy), Roact (copy), Skeleton (copy), ImageSetComponent (copy)
	local priceText = p1.props.priceText
	local isOwned = p1.props.isOwned
	local v17 = if not isOwned then Images["icons/common/robux_small"] else Images["icons/status/item/owned"]

	return withStyle(function(p2) -- line: 38
		-- upvalues: priceText (copy), isOwned (copy), getIconSizeUDim2 (copy), IconSize (copy), Roact (copy), p1 (copy), Skeleton (copy), ImageSetComponent (copy), v17 (copy)
		local BodyFont = p2.Font.Body.Font
		local v20 = p2.Font.BaseSize * p2.Font.Body.RelativeSize
		local Theme = p2.Theme
		local v22 = priceText and tonumber(priceText:sub(1, 1)) or priceText == "--"
		local v23 = priceText and (v22 or isOwned)
		local v24 = getIconSizeUDim2(IconSize.Small)
		local v25 = not v23 and 0 or v24.Width.Offset + 4

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v20),
			LayoutOrder = p1.props.layoutOrder
		}, {
			Shimmer = if priceText then nil else Roact.createElement(Skeleton, {
				Size = UDim2.new(0.8, 0, 0, v20)
			}),
			Icon = v23 and Roact.createElement(ImageSetComponent.Label, {
				BackgroundTransparency = 1,
				Image = v17,
				ImageColor3 = Theme.TextMuted.Color,
				ImageTransparency = Theme.TextMuted.Transparency,
				Size = v24,
				Position = UDim2.new(0, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5)
			}),
			TextLabel = priceText and Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, v25, 0, 0),
				Size = UDim2.new(1, -v25, 1, 0),
				Font = BodyFont,
				TextColor3 = Theme.TextMuted.Color,
				TextTransparency = Theme.TextMuted.Transparency,
				TextSize = v20,
				Text = priceText,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center
			})
		})
	end)
end

return v13
