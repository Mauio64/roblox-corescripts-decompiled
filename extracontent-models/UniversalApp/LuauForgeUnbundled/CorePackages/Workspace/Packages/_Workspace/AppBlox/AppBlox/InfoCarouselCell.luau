local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/UIBlox")
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation").Utility.normalizeFontFace
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Style").useDesignTokens

return function(props)
	local v5 = useDesignTokens()
	local padding = props.padding or v5.Size.Size_100
	local iconSize = props.iconSize or 18

	local font = v5.Typography.BodyLarge.Font

	local fontSize_350 = v5.FontSize.FontSize_350
	local default = v5.Color.Content.Default
	local font2 = v5.Typography.TitleLarge.Font
	local fontSize = v5.Typography.TitleLarge.FontSize
	local emphasis = v5.Color.Content.Emphasis

	local v6 = React.createElement("TextLabel", {
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
	local v8 = {
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
		v6 = React.createElement(
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
					Padding = UDim.new(0, v5.Size.Size_100)
				}),
				Icon = React.createElement(imageSetLabel, {
					LayoutOrder = 1,
					Size = UDim2.fromOffset(iconSize, iconSize),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Image = props.icon,
					ImageColor3 = emphasis.Color3,
					ImageTransparency = emphasis.Transparency
				}),
				BodyText = v6
			}
		)
	end

	v8.Body = v6
	return createElement("TextButton", onActivatedsByActivated, v8)
end
