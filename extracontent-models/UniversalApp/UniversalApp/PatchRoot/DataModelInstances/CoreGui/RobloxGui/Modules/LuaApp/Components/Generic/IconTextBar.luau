local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local Colors = require(Modules.LuaApp.Themes.Colors)
local FitChildren = require(Modules.LuaApp.FitChildren)
local DEPRECATED_ImageSetLabel = require(Modules.LuaApp.Components.DEPRECATED_ImageSetLabel)
local LocalizedTextLabel = require(Modules.LuaApp.Components.LocalizedTextLabel)
local t1 = {
	PaddingTop = UDim.new(0, 0),
	PaddingBottom = UDim.new(0, 0),
	PaddingLeft = UDim.new(0, 0),
	PaddingRight = UDim.new(0, 0)
}
local v10 = Roact.PureComponent:extend("IconTextBar")

v10.defaultProps = {
	iconSize = 26,
	gutterSize = 9,
	textSize = 28,
	textColor = Colors.Green,
	textFont = Enum.Font.SourceSans
}

function v10.render(p1) -- line: 29
	-- upvalues: Cryo (copy), t1 (copy), Roact (copy), FitChildren (copy), DEPRECATED_ImageSetLabel (copy), LocalizedTextLabel (copy)
	local layoutOrder = p1.props.layoutOrder
	local v13 = Cryo.Dictionary.join(t1, p1.props.padding or {})
	local icon = p1.props.icon
	local iconSize = p1.props.iconSize
	local gutterSize = p1.props.gutterSize
	local textKey = p1.props.textKey
	local textSize = p1.props.textSize
	local textColor = p1.props.textColor
	local textFont = p1.props.textFont
	local n1 = 0

	if icon then
		n1 = -(iconSize + gutterSize)
	end

	return Roact.createElement(FitChildren.FitFrame, {
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		fitAxis = FitChildren.FitAxis.Height
	}, {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, gutterSize)
		}),
		Padding = Roact.createElement("UIPadding", v13),
		Icon = icon and Roact.createElement(DEPRECATED_ImageSetLabel, {
			LayoutOrder = 1,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, iconSize, 0, iconSize),
			Image = icon
		}),
		Text = textKey and Roact.createElement(LocalizedTextLabel, {
			LayoutOrder = 2,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, n1, 0, textSize),
			TextSize = textSize,
			TextColor3 = textColor,
			Font = textFont,
			Text = textKey
		})
	})
end

return v10
