local parent = script:FindFirstAncestor("AppBlox").Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens

return function(props)
	local v = useDesignTokens()
	local padding = props.padding or v.Size.Size_100
	local iconSize = props.iconSize or 18

	local font = v.Typography.BodyLarge.Font

	local fontSize_350 = v.FontSize.FontSize_350
	local default = v.Color.Content.Default
	local font2 = v.Typography.TitleLarge.Font
	local fontSize = v.Typography.TitleLarge.FontSize
	local emphasis = v.Color.Content.Emphasis

	local createElement = React.createElement
	local v2 = {
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.XY,
		Text = props.bodyText,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		BackgroundTransparency = 1,
		TextYAlignment = 0
	}
	local font3

	if not FoundationFontFaceMigration then
		font3 = font2
	end

	v2.Font = font3
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(font2)
	end

	v2.FontFace = fontFace
	v2.TextSize = fontSize
	v2.TextColor3 = emphasis.Color3
	v2.TextTransparency = emphasis.Transparency

	v2.TextYAlignment = Enum.TextYAlignment.Center
	local v3 = createElement("TextLabel", v2)

	local createElement2 = React.createElement
	local onActivatedsByActivated = {
		AutomaticSize = Enum.AutomaticSize.XY,
		TextTransparency = 1,
		Text = "",
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
		[React.Event.Activated] = props.onActivated
	}
	local v4 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, padding)
		}),
		Header = 0,
		Body = 0
	}

	local createElement3 = React.createElement
	local v5 = {
		LayoutOrder = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Text = props.headerText,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		BackgroundTransparency = 1,
		TextYAlignment = 0
	}
	local font4

	if not FoundationFontFaceMigration then
		font4 = font
	end

	v5.Font = font4
	local fontFace2

	if FoundationFontFaceMigration then
		fontFace2 = normalizeFontFace(font)
	end

	v5.FontFace = fontFace2
	v5.TextSize = fontSize_350
	v5.TextColor3 = default.Color3
	v5.TextTransparency = default.Transparency

	v5.TextYAlignment = Enum.TextYAlignment.Center
	v4.Header = createElement3("TextLabel", v5)

	if props.icon then
		v3 = React.createElement(
			"Frame",
			{
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			},
			{
				BodyLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, v.Size.Size_100)
				}),
				Icon = React.createElement(ImageSetLabel, {
					LayoutOrder = 1,
					Size = UDim2.fromOffset(iconSize, iconSize),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Image = props.icon,
					ImageColor3 = emphasis.Color3,
					ImageTransparency = emphasis.Transparency
				}),
				BodyText = v3
			}
		)
	end

	v4.Body = v3
	return createElement2("TextButton", onActivatedsByActivated, v4)
end
