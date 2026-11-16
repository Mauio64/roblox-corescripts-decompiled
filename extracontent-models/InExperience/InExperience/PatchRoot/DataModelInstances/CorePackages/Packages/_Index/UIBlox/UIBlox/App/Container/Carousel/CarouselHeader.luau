local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local t = require(parent3.t)
local withStyle = require(parent2.Core.Style.withStyle)

local GetTextSize = require(parent2.Core.Text.GetTextSize)
local GetFontFromFontStyle = require(parent2.Core.Text.GetFontFromFontStyle)

local IconSize = require(parent.ImageSet.Enum.IconSize)
local getIconSize = require(parent.ImageSet.getIconSize)
local Images = require(parent.ImageSet.Images)

local core = parent2.Core
local Interactable = require(core.Control.Interactable)
local GenericTextLabel = require(core.Text.GenericTextLabel.GenericTextLabel)
local ImageSetComponent = require(core.ImageSet.ImageSetComponent)

local iconsnavigationpushRight_small = Images["icons/navigation/pushRight_small"]

local extended = Roact.PureComponent:extend("CarouselHeader")

extended.validateProps = t.strictInterface({
	headerText = t.optional(t.string),
	onSeeAll = t.optional(t.callback),
	carouselMargin = t.optional(t.number),
	layoutOrder = t.optional(t.number)
})

extended.defaultProps = { headerText = "", carouselMargin = 0 }

function extended.render(p)
	local headerText = p.props.headerText
	local onSeeAll = p.props.onSeeAll

	local layoutOrder = p.props.layoutOrder
	local carouselMargin = p.props.carouselMargin

	return withStyle(function(p2)
		local header1 = p2.Font.Header1
		local baseSize = p2.Font.BaseSize
		local textSize = GetTextSize(
			headerText,
			header1.RelativeSize * baseSize,
			GetFontFromFontStyle(header1),
			Vector2.new(10000, 10000)
		)

		local udim = UDim2.fromOffset(textSize.X + 4 + getIconSize(IconSize.Small), textSize.Y)

		return Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, textSize.Y),
				BackgroundTransparency = 1,
				LayoutOrder = layoutOrder
			},
			{
				CarouselHeaderButton = Roact.createElement(Interactable, {
					Position = UDim2.fromOffset(carouselMargin, 0),
					Size = udim,
					AutoButtonColor = false,
					BackgroundTransparency = 1,
					[Roact.Event.Activated] = onSeeAll,
					onStateChanged = function() end
				}, {
					Layout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 4)
					}),
					HeaderText = Roact.createElement(GenericTextLabel, {
						Text = headerText,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						LayoutOrder = 1,
						fontStyle = header1,
						colorStyle = p2.Theme.TextEmphasis
					}),
					SeeAllArrow = onSeeAll and Roact.createElement(ImageSetComponent.Label, {
						Size = UDim2.fromOffset(getIconSize(IconSize.Small), getIconSize(IconSize.Small)),
						BackgroundTransparency = 1,
						Image = iconsnavigationpushRight_small,
						ImageColor3 = p2.Theme.TextEmphasis.Color,
						ImageTransparency = p2.Theme.TextEmphasis.Transparency,
						LayoutOrder = 2
					}) or nil
				})
			}
		)
	end)
end

return extended
