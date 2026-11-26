local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local module = require("@luauforge/bundled/egF")

local withStyle = UIBlox.Style.withStyle

local extended = Roact.PureComponent:extend("DevSubGame")

local v5 = { LEFT = 24, TOP = 13, BOTTOM = 13, RIGHT = 22 }

extended.defaultProps = { layoutOrder = 0 }

function extended.render(p2)
	local props = p2.props
	local Game = props.game
	local subNames = props.subNames
	local activeSubs = props.activeSubs
	local active = props.active
	local dividerDisabled = props.dividerDisabled
	local onActivated = props.onActivated
	local layoutOrder = props.layoutOrder
	local maxSize = props.maxSize

	return withStyle(function(props2)
		return Roact.createElement("TextButton", {
			Size = UDim2.new(1, 0, 0, maxSize.Y),
			LayoutOrder = layoutOrder,
			BackgroundTransparency = 1,
			Text = "",
			[Roact.Event.Activated] = onActivated
		}, {
			SizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = maxSize
			}),
			ContentFrame = Roact.createElement(
				"Frame",
				{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0) },
				{
					Padding = Roact.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, 24),
						PaddingTop = UDim.new(0, 13),
						PaddingBottom = UDim.new(0, 13),
						PaddingRight = UDim.new(0, 22)
					}),
					Layout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Center
					}),
					Icon = Roact.createElement("ImageLabel", {
						LayoutOrder = 1,
						Size = UDim2.new(0, 44, 0, 44),
						BackgroundTransparency = Game.icon == nil and 0 or 1,
						Image = Game.icon,
						ImageTransparency = active and 0 or 0.5
					}),
					TextFrame = Roact.createElement(
						"Frame",
						{
							BackgroundTransparency = 1,
							Size = UDim2.new(1, -64, 1, 0),
							LayoutOrder = 2
						},
						{
							Padding = Roact.createElement("UIPadding", {
								PaddingLeft = UDim.new(0, 12),
								PaddingRight = UDim.new(0, 12)
							}),
							Title = Roact.createElement("TextLabel", {
								BackgroundTransparency = 1,
								Size = UDim2.new(1, 0, 0, 22),
								FontFace = normalizeFontFace(props2.Tokens.Typography.TitleLarge.Font),
								TextSize = props2.Font.BaseSize * props2.Font.Header2.RelativeSize,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextColor3 = props2.Theme.TextEmphasis.Color,
								TextTransparency = active and props2.Theme.TextEmphasis.Transparency or props2.Theme.TextEmphasis.Transparency * 0.5,
								TextTruncate = Enum.TextTruncate.AtEnd,
								Text = Game.name
							}),
							List = Roact.createElement("TextLabel", {
								AnchorPoint = Vector2.new(0, 1),
								Position = UDim2.new(0, 0, 1, 0),
								BackgroundTransparency = 1,
								Size = UDim2.new(1, 0, 0, 17),
								FontFace = normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font),
								TextSize = props2.Font.BaseSize * props2.Font.Body.RelativeSize,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextColor3 = props2.Theme.TextDefault.Color,
								TextTransparency = active and props2.Theme.TextDefault.Transparency or props2.Theme.TextDefault.Transparency * 0.5,
								TextTruncate = Enum.TextTruncate.AtEnd,
								Text = table.concat(subNames, ", ")
							})
						}
					),
					Circle = Roact.createElement(module, {
						Size = UDim2.new(0, 20, 0, 20),
						LayoutOrder = 3,
						Image = "LuaApp/graphic/gr-counter-slot-32x32",
						BackgroundTransparency = 1,
						ImageTransparency = active and 0 or props2.Theme.UIDefault.Transparency,
						ImageColor3 = props2.Theme.UIDefault.Color
					}, { Roact.createElement("TextLabel", {
							Visible = active,
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.new(0.5, 0, 0.5, 0),
							Size = UDim2.new(1, 0, 1, 0),
							BackgroundTransparency = 1,
							FontFace = normalizeFontFace(props2.Tokens.Typography.CaptionSmall.Font),
							TextSize = props2.Font.BaseSize * props2.Font.Footer.RelativeSize,
							TextColor3 = props2.Theme.TextDefault.Color,
							TextTransparency = props2.Theme.TextDefault.Transparency,
							Text = activeSubs
						}) })
				}
			),
			Divider = not dividerDisabled and Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundColor3 = props2.Theme.Divider.Color,
				BackgroundTransparency = active and props2.Theme.Divider.Transparency or 0.5,
				Size = UDim2.new(1, -80, 0, 1),
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.new(1, 0, 1, 0)
			})
		})
	end)
end

return extended
