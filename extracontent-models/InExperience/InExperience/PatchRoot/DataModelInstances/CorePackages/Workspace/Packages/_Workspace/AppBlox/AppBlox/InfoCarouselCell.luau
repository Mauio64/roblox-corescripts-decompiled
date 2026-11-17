local parent = script:FindFirstAncestor("AppBlox").Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
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

	local v2 = React.createElement("TextLabel", {
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.XY,
		Text = props.bodyText,
		FontFace = normalizeFontFace(font2),
		TextSize = fontSize,
		TextColor3 = emphasis.Color3,
		TextTransparency = emphasis.Transparency,
		BackgroundTransparency = 1,
		TextYAlignment = Enum.TextYAlignment.Center
	})

	local createElement = React.createElement
	local onActivatedsByActivated = {
		AutomaticSize = Enum.AutomaticSize.XY,
		TextTransparency = 1,
		Text = "",
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
		[React.Event.Activated] = props.onActivated
	}
	local v3 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, padding)
		}),
		Header = React.createElement("TextLabel", {
			LayoutOrder = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Text = props.headerText,
			FontFace = normalizeFontFace(font),
			TextSize = fontSize_350,
			TextColor3 = default.Color3,
			TextTransparency = default.Transparency,
			BackgroundTransparency = 1,
			TextYAlignment = Enum.TextYAlignment.Center
		}),
		Body = 0
	}

	if props.icon then
		v2 = React.createElement(
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
				BodyText = v2
			}
		)
	end

	v3.Body = v2
	return createElement("TextButton", onActivatedsByActivated, v3)
end
