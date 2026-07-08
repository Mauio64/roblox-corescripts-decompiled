local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParentParent.t)
local Foundation = require(ParentParentParent.Foundation)
local withStyle = require(ParentParent.Core.Style.withStyle)
local Images = require(ParentParent.App.ImageSet.Images)
local Skeleton = Foundation.Skeleton
local ImageSetComponent = require(ParentParent.Core.ImageSet.ImageSetComponent)
local v10 = Roact.PureComponent:extend("ItemTileFooter")

v10.validateProps = t.strictInterface({
	priceText = t.optional(t.string),
	isOwned = t.optional(t.boolean)
})

function v10.render(p1) -- line: 30
	-- upvalues: Images (copy), withStyle (copy), Roact (copy), Skeleton (copy), ImageSetComponent (copy)
	local priceText = p1.props.priceText
	local isOwned = p1.props.isOwned
	local u14 = Images["icons/common/robux_small"]

	if isOwned then
		u14 = Images["icons/status/item/owned"]
	end

	return withStyle(function(p2) -- line: 38
		-- upvalues: u14 (ref), Images (copy), priceText (copy), isOwned (copy), Roact (copy), Skeleton (copy), ImageSetComponent (copy)
		local SubHeader1Font = p2.Font.SubHeader1.Font
		local v17 = p2.Font.BaseSize * p2.Font.SubHeader1.RelativeSize
		local Theme = p2.Theme
		local v19 = u14.ImageRectSize / Images.ImagesResolutionScale
		local v20 = priceText and tonumber(priceText:sub(1, 1))
		local v21 = priceText and (v20 or isOwned)
		local n1 = 0

		if v21 then
			n1 = v19.X + 4
		end

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			Shimmer = not priceText and Roact.createElement(Skeleton, {
				Size = UDim2.new(0.8, 0, 0, v17)
			}),
			icon = v21 and Roact.createElement(ImageSetComponent.Label, {
				BackgroundTransparency = 1,
				Image = u14,
				ImageColor3 = Theme.IconEmphasis.Color,
				ImageTransparency = Theme.IconEmphasis.Transparency,
				Size = UDim2.new(0, v19.X, 0, v19.Y)
			}),
			TextLabel = priceText and Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, 0, 0, 0),
				Size = UDim2.new(1, -n1, 1, 0),
				Font = SubHeader1Font,
				TextColor3 = Theme.SecondaryContent.Color,
				TextTransparency = Theme.SecondaryContent.Transparency,
				TextSize = v17,
				Text = priceText,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top
			})
		})
	end)
end

return v10
