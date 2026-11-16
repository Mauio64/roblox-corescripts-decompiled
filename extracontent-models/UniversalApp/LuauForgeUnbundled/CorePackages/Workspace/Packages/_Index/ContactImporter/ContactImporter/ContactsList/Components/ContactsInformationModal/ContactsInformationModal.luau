local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")

local t = dependencies.t
local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox

local imageSetLabel = uiBlox.Core.ImageSet.ImageSetLabel
local iconSize = uiBlox.App.Constant.IconSize
local styledTextLabel = uiBlox.App.Text.StyledTextLabel
local withStyle = uiBlox.Style.withStyle

local extended = roact.PureComponent:extend("ContactsInformationModal")

extended.validateProps = t.strictInterface({
	text = t.string,
	image = t.table,
	layoutOrder = t.optional(t.number)
})

function extended.render(p2)
	return withStyle(function(p3)
		local theme = p3.Theme
		local font = p3.Font
		local props = p2.props
		return roact.createElement(
			"Frame",
			{
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1, 0),
				BackgroundTransparency = 1,
				LayoutOrder = props.layoutOrder
			},
			{
				UIListLayout = roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 12),
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				UIPadding = roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 24),
					PaddingBottom = UDim.new(0, 36)
				}),
				IconContainer = roact.createElement(
					"Frame",
					{
						BackgroundTransparency = 1,
						Size = UDim2.fromOffset(120, 132),
						LayoutOrder = 1
					},
					{
						Icon = roact.createElement(imageSetLabel, {
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundTransparency = 1,
							ImageColor3 = p3.Theme.IconEmphasis.Color,
							ImageTransparency = p3.Theme.IconEmphasis.Transparency,
							Image = props.image,
							Size = UDim2.fromOffset(iconSize.XLarge, iconSize.XLarge),
							Position = UDim2.fromScale(0.5, 0.5),
							LayoutOrder = 1
						})
					}
				),
				Description = roact.createElement(styledTextLabel, {
					text = props.text,
					fontStyle = font.CaptionBody,
					colorStyle = theme.TextEmphasis,
					lineHeight = 1.2,
					size = UDim2.fromScale(1, 0),
					automaticSize = Enum.AutomaticSize.Y,
					textTruncate = Enum.TextTruncate.AtEnd,
					textXAlignment = Enum.TextXAlignment.Center,
					textYAlignment = Enum.TextYAlignment.Top,
					layoutOrder = 2
				})
			}
		)
	end)
end

return extended
