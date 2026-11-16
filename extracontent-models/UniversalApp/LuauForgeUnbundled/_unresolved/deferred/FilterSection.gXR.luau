local CorePackages = game:GetService("CorePackages")

local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local useStyle = UIBlox.Core.Style.useStyle

local module = require("@luauforge/deferred/gOR")

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

	local children = {
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
		Title = 0,
		Content = 0
	}

	local createElement2 = React.createElement
	local v10 = {
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		Text = 0,
		TextColor3 = 0,
		TextTransparency = 0
	}
	local v11 = if not foundationFontFaceMigration then font.Header1.Font else nil
	v10.Font = v11

	local v12 = if foundationFontFaceMigration then normalizeFontFace(v5.Tokens.Typography.HeadingSmall.Font) else nil
	v10.FontFace = v12

	v10.TextSize = font.Header1.RelativeSize * font.BaseSize
	v10.Text = props.title
	v10.TextColor3 = theme.TextEmphasis.Color
	v10.TextTransparency = theme.TextEmphasis.Transparency
	children.Title = createElement2("TextLabel", v10)

	local createElement3 = React.createElement

	local v14 = {
		LayoutOrder = 2,
		Size = props.contentSize,
		AutomaticSize = 0,
		BackgroundTransparency = 0,
		BackgroundColor3 = 0,
		BorderSizePixel = 0
	}
	local v15 = if module() then props.AutomaticSize else nil
	v14.AutomaticSize = v15
	v14.BackgroundTransparency = theme.PlaceHolder.Transparency
	v14.BackgroundColor3 = theme.PlaceHolder.Color
	children.Content = createElement3("Frame", v14, Dash.join({
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical
		}),
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) })
	}, props.children))
	return createElement("Frame", v7, children)
end

return FilterSection
