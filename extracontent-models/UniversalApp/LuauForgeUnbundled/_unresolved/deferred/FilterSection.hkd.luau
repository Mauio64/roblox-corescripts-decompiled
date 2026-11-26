local CorePackages = game:GetService("CorePackages")

local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useStyle = UIBlox.Core.Style.useStyle

local module = require("@luauforge/deferred/haU")

local udim = UDim.new(0, 12)

local function FilterSection(props)
	local v5 = useStyle()
	local theme = v5.Theme
	local font = v5.Font

	local createElement = React.createElement
	local v7 = {
		Size = props.Size,
		AutomaticSize = 0,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}
	local v8 = if module() then props.AutomaticSize else nil
	v7.AutomaticSize = v8

	local v9 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = udim
		}),
		Padding = React.createElement("UIPadding", {
			PaddingTop = udim,
			PaddingBottom = udim,
			PaddingLeft = udim,
			PaddingRight = udim
		}),
		Title = React.createElement("TextLabel", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			FontFace = normalizeFontFace(v5.Tokens.Typography.HeadingSmall.Font),
			TextSize = font.Header1.RelativeSize * font.BaseSize,
			Text = props.title,
			TextColor3 = theme.TextEmphasis.Color,
			TextTransparency = theme.TextEmphasis.Transparency
		}),
		Content = 0
	}

	local createElement2 = React.createElement

	local v11 = {
		LayoutOrder = 2,
		Size = props.contentSize,
		AutomaticSize = 0,
		BackgroundTransparency = 0,
		BackgroundColor3 = 0,
		BorderSizePixel = 0
	}
	local v12 = if module() then props.AutomaticSize else nil
	v11.AutomaticSize = v12
	v11.BackgroundTransparency = theme.PlaceHolder.Transparency
	v11.BackgroundColor3 = theme.PlaceHolder.Color
	v9.Content = createElement2("Frame", v11, Dash.join({
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical
		}),
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) })
	}, props.children))
	return createElement("Frame", v7, v9)
end

return FilterSection
