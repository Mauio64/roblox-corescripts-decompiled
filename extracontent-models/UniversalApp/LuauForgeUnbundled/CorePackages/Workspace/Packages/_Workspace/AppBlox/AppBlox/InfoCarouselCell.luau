local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
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

	local createElement = React.createElement
	local v7 = {
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.XY,
		Text = props.bodyText,
		Font = if not foundationFontFaceMigration then font2 else nil,
		FontFace = 0,
		TextSize = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		BackgroundTransparency = 1,
		TextYAlignment = 0
	}

	local v9 = if foundationFontFaceMigration then normalizeFontFace(font2) else nil
	v7.FontFace = v9
	v7.TextSize = fontSize
	v7.TextColor3 = emphasis.Color3
	v7.TextTransparency = emphasis.Transparency

	v7.TextYAlignment = Enum.TextYAlignment.Center
	local v10 = createElement("TextLabel", v7)

	local createElement2 = React.createElement
	local onActivatedsByActivated = {
		AutomaticSize = Enum.AutomaticSize.XY,
		TextTransparency = 1,
		Text = "",
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
		[React.Event.Activated] = props.onActivated
	}
	local v12 = {
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
	local v14 = {
		LayoutOrder = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Text = props.headerText,
		Font = if not foundationFontFaceMigration then font else nil,
		FontFace = 0,
		TextSize = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		BackgroundTransparency = 1,
		TextYAlignment = 0
	}

	local v16 = if foundationFontFaceMigration then normalizeFontFace(font) else nil
	v14.FontFace = v16
	v14.TextSize = fontSize_350
	v14.TextColor3 = default.Color3
	v14.TextTransparency = default.Transparency

	v14.TextYAlignment = Enum.TextYAlignment.Center
	v12.Header = createElement3("TextLabel", v14)

	if props.icon then
		v10 = React.createElement(
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
				BodyText = v10
			}
		)
	end

	v12.Body = v10
	return createElement2("TextButton", onActivatedsByActivated, v12)
end
