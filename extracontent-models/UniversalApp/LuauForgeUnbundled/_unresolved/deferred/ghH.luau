local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local Style = require("@game/CorePackages/Workspace/Packages/Style")

local Foundation2 = require(CorePackages.Packages.Foundation)
local foundationFontFaceMigration = Foundation2.Utility.Flags.FoundationFontFaceMigration
local module2 = require("@luauforge/deferred/ghI")

local useDesignTokens = Style.useDesignTokens
local mapTypographyVariantToFontEnum = Style.mapTypographyVariantToFontEnum

return function(props)
	local v5 = useDesignTokens()
	local createElement = React.createElement
	local v7 = {
		Size = UDim2.new(1, 0, 0, v5.Size.Size_2800),
		BackgroundTransparency = 1,
		LayoutOrder = 2
	}

	local v8 = {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v5.Size.Size_600),
			PaddingBottom = UDim.new(0, v5.Size.Size_1400)
		}),
		TargetInner = 0
	}

	local createElement2 = React.createElement
	local v10 = {
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0)
	}
	local v11 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Thumbnail = React.createElement(module2, { thumbnailUrl = props.thumbnailUrl }),
		Texts = 0
	}

	local createElement3 = React.createElement
	local v13 = {
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1
	}

	local children = {
		Layout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v5.Size.Size_300)
		}),
		PrimaryText = 0,
		SecondaryText = 0
	}

	local createElement4 = React.createElement
	local v15 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		Text = props.primaryText,
		Font = 0,
		FontFace = 0,
		LayoutOrder = 1,
		TextColor3 = 0,
		TextTransparency = 0,
		TextSize = 0,
		TextWrapped = true,
		TextXAlignment = 0,
		Size = 0,
		BackgroundTransparency = 1
	}

	local v16 = if not foundationFontFaceMigration then mapTypographyVariantToFontEnum(v5.Typography.TitleLarge) else nil
	v15.Font = v16

	local v17 = if foundationFontFaceMigration then normalizeFontFace(v5.Typography.TitleLarge.Font) else nil
	v15.FontFace = v17

	v15.TextColor3 = v5.Color.Content.Emphasis.Color3
	v15.TextTransparency = v5.Color.Content.Emphasis.Transparency
	v15.TextSize = v5.Typography.TitleLarge.FontSize

	v15.TextXAlignment = Enum.TextXAlignment.Left
	v15.Size = UDim2.new(0, 0, 0, v5.Typography.TitleLarge.FontSize)
	children.PrimaryText = createElement4("TextLabel", v15)

	local createElement5 = React.createElement
	local v19 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		Text = props.secondaryText,
		Font = 0,
		FontFace = 0,
		LayoutOrder = 2,
		TextColor3 = 0,
		TextTransparency = 0,
		TextSize = 0,
		TextWrapped = true,
		TextXAlignment = 0,
		Size = 0,
		BackgroundTransparency = 1
	}

	local v20 = if not foundationFontFaceMigration then mapTypographyVariantToFontEnum(v5.Typography.BodyLarge) else nil
	v19.Font = v20

	local v21 = if foundationFontFaceMigration then normalizeFontFace(v5.Typography.BodyLarge.Font) else nil
	v19.FontFace = v21

	v19.TextColor3 = v5.Color.Content.Default.Color3
	v19.TextTransparency = v5.Color.Content.Emphasis.Transparency
	v19.TextSize = v5.Typography.BodyLarge.FontSize

	v19.TextXAlignment = Enum.TextXAlignment.Left
	v19.Size = UDim2.new(0, 0, 0, v5.Typography.TitleLarge.FontSize)
	children.SecondaryText = createElement5("TextLabel", v19)
	v11.Texts = createElement3("Frame", v13, children)
	v8.TargetInner = createElement2("Frame", v10, v11)
	return createElement("Frame", v7, v8)
end
