local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Roact = require(ParentParentParentParent.Roact)
local t = require(ParentParentParentParent.t)
local withStyle = require(ParentParentParent.Core.Style.withStyle)
local GetTextSize = require(ParentParentParent.Core.Text.GetTextSize)
local IconSize = require(ParentParent.ImageSet.Enum.IconSize)
local getIconSize = require(ParentParent.ImageSet.getIconSize)
local Images = require(ParentParent.ImageSet.Images)
local Core = ParentParentParent.Core
local Interactable = require(Core.Control.Interactable)
local GenericTextLabel = require(Core.Text.GenericTextLabel.GenericTextLabel)
local ImageSetComponent = require(Core.ImageSet.ImageSetComponent)
local v15 = Images["icons/navigation/pushRight_small"]
local v16 = Roact.PureComponent:extend("CarouselHeader")

v16.validateProps = t.strictInterface({
	headerText = t.optional(t.string),
	onSeeAll = t.optional(t.callback),
	carouselMargin = t.optional(t.number),
	layoutOrder = t.optional(t.number)
})
v16.defaultProps = {
	headerText = "",
	carouselMargin = 0
}

function v16.render(p1) -- line: 48
	-- upvalues: withStyle (copy), GetTextSize (copy), getIconSize (copy), IconSize (copy), Roact (copy), Interactable (copy), GenericTextLabel (copy), ImageSetComponent (copy), v15 (copy)
	local headerText = p1.props.headerText
	local onSeeAll = p1.props.onSeeAll
	local layoutOrder = p1.props.layoutOrder
	local carouselMargin = p1.props.carouselMargin

	return withStyle(function(p2) -- line: 55
		-- upvalues: GetTextSize (copy), headerText (copy), getIconSize (copy), IconSize (copy), Roact (copy), layoutOrder (copy), Interactable (copy), carouselMargin (copy), onSeeAll (copy), GenericTextLabel (copy), ImageSetComponent (copy), v15 (copy)
		local Header1 = p2.Font.Header1
		local BaseSize = p2.Font.BaseSize
		local v25 = Header1.RelativeSize * BaseSize
		local Header1Font = Header1.Font
		local v27 = GetTextSize(headerText, v25, Header1Font, Vector2.new(10000, 10000))
		local uDim2 = UDim2.fromOffset(v27.X + 4 + getIconSize(IconSize.Small), v27.Y)

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v27.Y),
			LayoutOrder = layoutOrder
		}, {
			CarouselHeaderButton = Roact.createElement(Interactable, {
				Position = UDim2.fromOffset(carouselMargin, 0),
				Size = uDim2,
				AutoButtonColor = false,
				BackgroundTransparency = 1,
				[Roact.Event.Activated] = onSeeAll,
				onStateChanged = function() -- line: 77
				end
			}, {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 4)
				}),
				HeaderText = Roact.createElement(GenericTextLabel, {
					LayoutOrder = 1,
					Text = headerText,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					fontStyle = Header1,
					colorStyle = p2.Theme.TextEmphasis
				}),
				SeeAllArrow = onSeeAll and Roact.createElement(ImageSetComponent.Label, {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.fromOffset(getIconSize(IconSize.Small), getIconSize(IconSize.Small)),
					Image = v15,
					ImageColor3 = p2.Theme.TextEmphasis.Color,
					ImageTransparency = p2.Theme.TextEmphasis.Transparency
				}) or nil
			})
		})
	end)
end

return v16
