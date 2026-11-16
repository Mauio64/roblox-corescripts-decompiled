local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

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

		local createElement = Roact.createElement
		local v = {
			LayoutOrder = p.props.layoutOrder,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, p.props.height)
		}
		local v2 = {
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
			CellContents = 0,
			Divider = 0
		}

		local createElement2 = Roact.createElement
		local v3 = { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }
		local children = {
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
				{ BackgroundTransparency = 1, LayoutOrder = 1, Size = UDim2.fromOffset(36, 36) },
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
			Text = 0
		}

		local createElement3 = Roact.createElement
		local v4 = {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, -48, 1, 0),
			Text = formatByKey,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			TextTruncate = 0
		}
		local font2

		if not FoundationFontFaceMigration then
			font2 = font.Header2.Font
		end

		v4.Font = font2
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font)
		end

		v4.FontFace = fontFace

		v4.TextSize = font.BaseSize * font.Header2.RelativeSize
		v4.TextColor3 = theme.TextEmphasis.Color
		v4.TextTransparency = theme.TextEmphasis.TextTransparency
		v4.TextXAlignment = Enum.TextXAlignment.Left
		v4.TextYAlignment = Enum.TextYAlignment.Center
		v4.TextTruncate = Enum.TextTruncate.AtEnd
		children.Text = createElement3("TextLabel", v4)
		v2.CellContents = createElement2("Frame", v3, children)

		v2.Divider = p.props.hasDivider and Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.fromScale(0, 1),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = theme.Divider.Transparency,
			BackgroundColor3 = theme.Divider.Color
		})
		return createElement("Frame", v, v2)
	end)
end

return extended
