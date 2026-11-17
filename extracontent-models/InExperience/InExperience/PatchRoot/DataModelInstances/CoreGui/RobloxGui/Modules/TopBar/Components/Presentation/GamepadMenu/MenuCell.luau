local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local withStyle = UIBlox.Core.Style.withStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local extended = Roact.PureComponent:extend("MenuCell")

extended.validateProps = t.strictInterface({
	layoutOrder = t.integer,
	icon = t.optional(t.union(t.table, t.string)),
	iconComponent = t.optional(t.table),
	localizationKey = t.string,
	height = t.numberPositive,
	hasDivider = t.boolean,
	isSelected = t.boolean
})

function extended.render(p)
	return withStyle(function(props)
		local theme = props.Theme
		local font = props.Font

		local formatByKey = RobloxTranslator:FormatByKey(p.props.localizationKey)

		return Roact.createElement(
			"Frame",
			{
				LayoutOrder = p.props.layoutOrder,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, p.props.height)
			},
			{
				SelectedFrame = p.props.isSelected and Roact.createElement(
					"Frame",
					{
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 4, 1, 4),
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5)
					},
					{
						TopBorder = Roact.createElement("Frame", {
							BorderSizePixel = 0,
							Size = UDim2.new(1, 0, 0, 2),
							BackgroundTransparency = theme.SystemPrimaryOnHover.Transparency,
							BackgroundColor3 = theme.SystemPrimaryOnHover.Color
						}),
						LeftBorder = Roact.createElement("Frame", {
							BorderSizePixel = 0,
							Size = UDim2.new(0, 2, 1, 0),
							BackgroundTransparency = theme.SystemPrimaryOnHover.Transparency,
							BackgroundColor3 = theme.SystemPrimaryOnHover.Color
						}),
						RightBorder = Roact.createElement("Frame", {
							BorderSizePixel = 0,
							Size = UDim2.new(0, 2, 1, 0),
							Position = UDim2.fromScale(1, 0),
							AnchorPoint = Vector2.new(1, 0),
							BackgroundTransparency = theme.SystemPrimaryOnHover.Transparency,
							BackgroundColor3 = theme.SystemPrimaryOnHover.Color
						}),
						BottomBorder = Roact.createElement("Frame", {
							BorderSizePixel = 0,
							Size = UDim2.new(1, 0, 0, 2),
							Position = UDim2.fromScale(0, 1),
							AnchorPoint = Vector2.new(0, 1),
							BackgroundTransparency = theme.SystemPrimaryOnHover.Transparency,
							BackgroundColor3 = theme.SystemPrimaryOnHover.Color
						})
					}
				),
				CellContents = Roact.createElement(
					"Frame",
					{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) },
					{
						Layout = Roact.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Horizontal,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							Padding = UDim.new(0, 12)
						}),
						Padding = Roact.createElement("UIPadding", {
							PaddingLeft = UDim.new(0, 12),
							PaddingRight = UDim.new(0, 12)
						}),
						IconFrame = Roact.createElement(
							"Frame",
							{
								BackgroundTransparency = 1,
								LayoutOrder = 1,
								Size = UDim2.fromOffset(36, 36)
							},
							{
								IconLabel = p.props.icon ~= nil and Roact.createElement(ImageSetLabel, {
									BackgroundTransparency = 1,
									Image = p.props.icon,
									Size = UDim2.fromScale(1, 1),
									ImageTransparency = theme.IconEmphasis.Transparency,
									ImageColor3 = theme.IconEmphasis.Color
								}),
								IconComponent = p.props.iconComponent ~= nil and Roact.createElement(p.props.iconComponent)
							}
						),
						Text = Roact.createElement("TextLabel", {
							BackgroundTransparency = 1,
							LayoutOrder = 2,
							Size = UDim2.new(1, -48, 1, 0),
							Text = formatByKey,
							FontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font),
							TextSize = font.BaseSize * font.Header2.RelativeSize,
							TextColor3 = theme.TextEmphasis.Color,
							TextTransparency = theme.TextEmphasis.TextTransparency,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = Enum.TextYAlignment.Center,
							TextTruncate = Enum.TextTruncate.AtEnd
						})
					}
				),
				Divider = p.props.hasDivider and Roact.createElement("Frame", {
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.fromScale(0, 1),
					AnchorPoint = Vector2.new(0, 1),
					BackgroundTransparency = theme.Divider.Transparency,
					BackgroundColor3 = theme.Divider.Color
				})
			}
		)
	end)
end

return extended
