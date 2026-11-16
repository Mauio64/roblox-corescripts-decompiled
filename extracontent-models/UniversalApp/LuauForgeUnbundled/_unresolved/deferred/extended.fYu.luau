local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/ecR")
local module2 = require("@luauforge/bundled/fpF")
local module3 = require("@luauforge/bundled/edi")
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local getTextSize = require("@game/CorePackages/Workspace/Packages/Style").GetTextSize
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
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
	if not foundationFontFaceMigration then
		return math.max(
			module2.GetTextWidth(p2, p4.Font.Title.Font, p4.Font.BaseSize * p4.Font.Title.RelativeSize),
			(module2.GetTextWidth(
				p3,
				p4.Font.CaptionHeader.Font,
				p4.Font.BaseSize * p4.Font.CaptionHeader.RelativeSize
			))
		) + 74
	end

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
		local createElement = module.createElement
		local v7 = {
			AnchorPoint = anchorPoint,
			Position = position,
			Size = UDim2.new(0, width, 0, 44),
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder
		}

		local v8 = {
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
			TextSection = 0
		}

		local createElement2 = module.createElement
		local v10 = {
			Size = UDim2.new(0, v5, 1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 2
		}

		local createElement3 = module.createElement
		local v12 = {
			Size = UDim2.new(1, 0, 0, 42),
			Position = UDim2.new(0, 0, 0, -7),
			Text = number,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextXAlignment = 0,
			TextScaled = true,
			BackgroundTransparency = 1
		}

		local v13 = if not foundationFontFaceMigration then props.Font.Title.Font else nil
		v12.Font = v13

		local v14 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.HeadingLarge.Font) else nil
		v12.FontFace = v14

		v12.TextSize = props.Font.BaseSize * props.Font.Title.RelativeSize
		v12.TextColor3 = props.Theme.TextEmphasis.Color
		v12.TextTransparency = props.Theme.TextEmphasis.Transparency
		v12.TextXAlignment = Enum.TextXAlignment.Left
		local children = {
			Number = createElement3("TextLabel", v12),
			Label = 0
		}

		local createElement4 = module.createElement
		local v16 = {
			Size = UDim2.new(1, 0, 0, 12),
			Position = UDim2.new(0, 0, 0, 28),
			Text = label,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextXAlignment = 0,
			TextScaled = true,
			BackgroundTransparency = 1
		}

		local v17 = if not foundationFontFaceMigration then props.Font.CaptionHeader.Font else nil
		v16.Font = v17

		local v18 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.CaptionLarge.Font) else nil
		v16.FontFace = v18

		v16.TextSize = props.Font.BaseSize * props.Font.CaptionHeader.RelativeSize
		v16.TextColor3 = props.Theme.TextEmphasis.Color
		v16.TextTransparency = props.Theme.TextEmphasis.Transparency
		v16.TextXAlignment = Enum.TextXAlignment.Left
		children.Label = createElement4("TextLabel", v16)
		v8.TextSection = createElement2("Frame", v10, children)
		return createElement("Frame", v7, v8)
	end)
end

return extended
