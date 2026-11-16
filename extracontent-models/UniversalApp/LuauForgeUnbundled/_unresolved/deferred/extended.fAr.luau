local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local module = require("@luauforge/bundled/edi")

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
		local createElement = Roact.createElement
		local onActivatedsByActivated = {
			Size = UDim2.new(1, 0, 0, maxSize.Y),
			LayoutOrder = layoutOrder,
			BackgroundTransparency = 1,
			Text = "",
			[Roact.Event.Activated] = onActivated
		}
		local v7 = {
			SizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = maxSize
			}),
			ContentFrame = 0,
			Divider = 0
		}

		local createElement2 = Roact.createElement
		local v9 = { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0) }
		local children = {
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
			TextFrame = 0,
			Circle = 0
		}

		local createElement3 = Roact.createElement
		local v11 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -64, 1, 0),
			LayoutOrder = 2
		}

		local children2 = {
			Padding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 12),
				PaddingRight = UDim.new(0, 12)
			}),
			Title = 0,
			List = 0
		}

		local createElement4 = Roact.createElement
		local v13 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 22),
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextXAlignment = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextTruncate = 0,
			Text = 0
		}

		local v14 = if not foundationFontFaceMigration then props2.Font.Header2.Font else nil
		v13.Font = v14

		local v15 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.TitleLarge.Font) else nil
		v13.FontFace = v15

		v13.TextSize = props2.Font.BaseSize * props2.Font.Header2.RelativeSize
		v13.TextXAlignment = Enum.TextXAlignment.Left
		v13.TextColor3 = props2.Theme.TextEmphasis.Color
		v13.TextTransparency = active and props2.Theme.TextEmphasis.Transparency
			or props2.Theme.TextEmphasis.Transparency * 0.5
		v13.TextTruncate = Enum.TextTruncate.AtEnd

		v13.Text = Game.name
		children2.Title = createElement4("TextLabel", v13)

		local createElement5 = Roact.createElement
		local v17 = {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 17),
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextXAlignment = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextTruncate = 0,
			Text = 0
		}

		local v18 = if not foundationFontFaceMigration then props2.Font.Body.Font else nil
		v17.Font = v18

		local v19 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font) else nil
		v17.FontFace = v19

		v17.TextSize = props2.Font.BaseSize * props2.Font.Body.RelativeSize
		v17.TextXAlignment = Enum.TextXAlignment.Left
		v17.TextColor3 = props2.Theme.TextDefault.Color
		v17.TextTransparency = active and props2.Theme.TextDefault.Transparency
			or props2.Theme.TextDefault.Transparency * 0.5
		v17.TextTruncate = Enum.TextTruncate.AtEnd

		v17.Text = table.concat(subNames, ", ")
		children2.List = createElement5("TextLabel", v17)
		children.TextFrame = createElement3("Frame", v11, children2)

		local createElement6 = Roact.createElement
		local v21 = {
			Size = UDim2.new(0, 20, 0, 20),
			LayoutOrder = 3,
			Image = "LuaApp/graphic/gr-counter-slot-32x32",
			BackgroundTransparency = 1,
			ImageTransparency = active and 0 or props2.Theme.UIDefault.Transparency,
			ImageColor3 = props2.Theme.UIDefault.Color
		}

		local createElement7 = Roact.createElement
		local v24 = {
			Visible = active,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			Text = 0
		}

		local v25 = if not foundationFontFaceMigration then props2.Font.Footer.Font else nil
		v24.Font = v25

		local v26 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.CaptionSmall.Font) else nil
		v24.FontFace = v26

		v24.TextSize = props2.Font.BaseSize * props2.Font.Footer.RelativeSize
		v24.TextColor3 = props2.Theme.TextDefault.Color
		v24.TextTransparency = props2.Theme.TextDefault.Transparency

		v24.Text = activeSubs
		children.Circle = createElement6(module, v21, { createElement7("TextLabel", v24) })
		v7.ContentFrame = createElement2("Frame", v9, children)

		v7.Divider = not dividerDisabled and Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundColor3 = props2.Theme.Divider.Color,
			BackgroundTransparency = active and props2.Theme.Divider.Transparency or 0.5,
			Size = UDim2.new(1, -80, 0, 1),
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, 0, 1, 0)
		})
		return createElement("TextButton", onActivatedsByActivated, v7)
	end)
end

return extended
