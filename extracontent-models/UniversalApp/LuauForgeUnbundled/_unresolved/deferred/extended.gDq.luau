local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/ego")
local module2 = require("@luauforge/deferred/fFU")
local module3 = require("@luauforge/bundled/egF")
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize
local withStyle = UIBlox.Style.withStyle

local extended = module.PureComponent:extend("PrimaryStatWidget")

extended.defaultProps = {
	AnchorPoint = Vector2.new(0, 0),
	Position = UDim2.new(0, 0, 0, 0)
}

function extended.GetMinimumWidth(p2, p3, p4)
	return math.max(module2.GetTextWidth(p2, p4, 42), (module2.GetTextWidth(p3, p4, 12))) + 74
end

function extended.GetMinimumWidthRethemed(p2, p3, p4)
	local vector2 = Vector2.new(10000, 10000)
	return math.max(
		getTextSize(
			p2,
			p4.Font.BaseSize * p4.Font.Title.RelativeSize,
			p4.Tokens.Typography.HeadingLarge.Font,
			vector2
		).X,
		getTextSize(
			p3,
			p4.Font.BaseSize * p4.Font.CaptionHeader.RelativeSize,
			p4.Tokens.Typography.CaptionLarge.Font,
			vector2
		).X
	) + 74
end

function extended.render(p2)
	local icon = p2.props.icon
	local number = p2.props.number
	local label = p2.props.label
	local width = p2.props.width
	local layoutOrder = p2.props.LayoutOrder
	local anchorPoint = p2.props.AnchorPoint
	local position = p2.props.Position

	local v5 = width - 74

	return withStyle(function(props)
		return module.createElement("Frame", {
			AnchorPoint = anchorPoint,
			Position = position,
			Size = UDim2.new(0, width, 0, 44),
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder
		}, {
			ListLayout = module.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10)
			}),
			Padding = module.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10)
			}),
			Icon = module.createElement(module3, {
				Size = UDim2.new(0, 44, 0, 44),
				Image = icon,
				ImageColor3 = props.Theme.IconEmphasis.Color,
				ImageTransparency = props.Theme.IconEmphasis.Transparency,
				BackgroundTransparency = 1,
				LayoutOrder = 1
			}),
			TextSection = module.createElement(
				"Frame",
				{
					Size = UDim2.new(0, v5, 1, 0),
					BackgroundTransparency = 1,
					LayoutOrder = 2
				},
				{
					Number = module.createElement("TextLabel", {
						Size = UDim2.new(1, 0, 0, 42),
						Position = UDim2.new(0, 0, 0, -7),
						Text = number,
						FontFace = normalizeFontFace(props.Tokens.Typography.HeadingLarge.Font),
						TextSize = props.Font.BaseSize * props.Font.Title.RelativeSize,
						TextColor3 = props.Theme.TextEmphasis.Color,
						TextTransparency = props.Theme.TextEmphasis.Transparency,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextScaled = true,
						BackgroundTransparency = 1
					}),
					Label = module.createElement("TextLabel", {
						Size = UDim2.new(1, 0, 0, 12),
						Position = UDim2.new(0, 0, 0, 28),
						Text = label,
						FontFace = normalizeFontFace(props.Tokens.Typography.CaptionLarge.Font),
						TextSize = props.Font.BaseSize * props.Font.CaptionHeader.RelativeSize,
						TextColor3 = props.Theme.TextEmphasis.Color,
						TextTransparency = props.Theme.TextEmphasis.Transparency,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextScaled = true,
						BackgroundTransparency = 1
					})
				}
			)
		})
	end)
end

return extended
