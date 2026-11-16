local parent = script.Parent.Parent.Parent.Parent
local core = parent.Core
local parent2 = parent.Parent
local Foundation = require(parent2.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local React = require(parent2.React)
local useStyle = require(core.Style.useStyle)
local useTextSizeOffset = require(parent.Core.Style.useTextSizeOffset)

require(parent.App.Style.Fonts)
require(parent.App.Style.StyleTypes)
local setDefault = require(parent.Utility.setDefault)

local function TileContentPanel(props)
	local v = useStyle()
	local settings = v.Settings
	local v2 = useTextSizeOffset()

	local v3 = settings.ReducedMotion and 6 or 8
	local contentTitle = props.contentTitle
	local contentFooter = props.contentFooter
	local v4 = setDefault(props.textLineCount, 2)
	local v5 = setDefault(props.hasSidePadding, true)
	local v6, v7, v8, v9

	if props.outerPadding == nil or type(props.outerPadding) == "number" then
		v6 = setDefault(props.outerPadding, v3)
		v7 = v6
		v8 = v7
		v9 = v8
		v7 = v9
		v8 = v7
	else
		v6 = setDefault(props.outerPadding.Left, v3)
		v9 = setDefault(props.outerPadding.Right, v3)
		v8 = setDefault(props.outerPadding.Top, v3)
		v7 = setDefault(props.outerPadding.Bottom, v3)
	end

	local v10 = setDefault(props.titlePadding, v3)
	local panelHeight = props.panelHeight
	local footerHeight = props.footerHeight

	local font = v.Font
	local v11 = setDefault(props.titleFont, font.Header2)
	local theme = v.Theme

	local v12 = (font.BaseSize + v2) * v11.RelativeSize * v4

	local textEmphasis = theme.TextEmphasis

	local createElement = React.createElement
	local v13 = {
		Size = UDim2.new(UDim.new(1, 0), panelHeight),
		BackgroundTransparency = 1
	}

	local v14 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v10)
		}),
		Padding = 0,
		TitleText = 0,
		ContentFooter = 0
	}

	local createElement2 = React.createElement
	local paddingLeft

	if v5 then
		paddingLeft = UDim.new(0, v6)
	end

	local paddingRight

	if v5 then
		paddingRight = UDim.new(0, v9)
	end

	v14.Padding = createElement2("UIPadding", {
		PaddingLeft = paddingLeft,
		PaddingRight = paddingRight,
		PaddingTop = UDim.new(0, v8),
		PaddingBottom = UDim.new(0, v7)
	})
	local titleText

	if v4 > 0 and contentTitle and string.len(contentTitle) > 0 then
		titleText = React.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Text = contentTitle,
			FontFace = normalizeFontFace(v11.Font),
			TextSize = font.BaseSize * v11.RelativeSize,
			TextTransparency = textEmphasis.Transparency,
			TextColor3 = textEmphasis.Color,
			TextWrapped = true,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			LayoutOrder = 1
		}, {
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(1e999, v12)
			})
		})
	end

	v14.TitleText = titleText
	local contentFooter2

	if contentFooter then
		contentFooter2 = React.createElement(
			"Frame",
			{
				Size = UDim2.new(UDim.new(1, 0), footerHeight),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 2
			},
			{ contentFooter }
		)
	end

	v14.ContentFooter = contentFooter2
	return createElement("Frame", v13, v14)
end

return TileContentPanel
