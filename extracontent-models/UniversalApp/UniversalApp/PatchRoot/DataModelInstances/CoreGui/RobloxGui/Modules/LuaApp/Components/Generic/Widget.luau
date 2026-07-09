local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local Colors = require(Modules.LuaApp.Themes.Colors)
local FitChildren = require(Modules.LuaApp.FitChildren)
local IconTextBar = require(Modules.LuaApp.Components.Generic.IconTextBar)
local White = Colors.White
local rect = Rect.new(9, 9, 9, 9)
local t1 = {
	PaddingTop = UDim.new(0, 0),
	PaddingBottom = UDim.new(0, 0),
	PaddingLeft = UDim.new(0, 0),
	PaddingRight = UDim.new(0, 0)
}
local t2 = {
	PaddingTop = UDim.new(0, 0),
	PaddingBottom = UDim.new(0, 0),
	PaddingLeft = UDim.new(0, 0),
	PaddingRight = UDim.new(0, 0)
}
local v12 = Roact.PureComponent:extend("Widget")

v12.defaultProps = {
	backgroundTransparency = 0,
	iconSize = 26,
	titleGutterSize = 9,
	titleSize = 28,
	backgroundColor = White,
	titleFont = Enum.Font.SourceSans
}

function v12.render(p1) -- line: 39
	-- upvalues: Cryo (copy), t1 (copy), t2 (copy), Roact (copy), FitChildren (copy), rect (copy), IconTextBar (copy)
	local layoutOrder = p1.props.layoutOrder
	local v15 = Cryo.Dictionary.join(t1, p1.props.titlePadding or {})
	local v16 = Cryo.Dictionary.join(t2, p1.props.contentPadding or {})
	local backgroundImage = p1.props.backgroundImage
	local backgroundColor = p1.props.backgroundColor
	local backgroundTransparency = p1.props.backgroundTransparency
	local icon = p1.props.icon
	local iconSize = p1.props.iconSize
	local titleGutterSize = p1.props.titleGutterSize
	local titleKey = p1.props.titleKey
	local titleSize = p1.props.titleSize
	local titleColor = p1.props.titleColor
	local titleFont = p1.props.titleFont
	local renderContent = p1.props.renderContent

	return Roact.createElement(FitChildren.FitImageLabel, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		LayoutOrder = layoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		fitAxis = FitChildren.FitAxis.Height,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = rect,
		Image = backgroundImage,
		ImageColor3 = backgroundColor,
		ImageTransparency = backgroundTransparency
	}, {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		TitleBar = Roact.createElement(IconTextBar, {
			layoutOrder = 1,
			padding = v15,
			icon = icon,
			iconSize = iconSize,
			gutterSize = titleGutterSize,
			textKey = titleKey,
			textSize = titleSize,
			textColor = titleColor,
			textFont = titleFont
		}),
		ContentFrame = renderContent and Roact.createElement(FitChildren.FitFrame, {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			fitAxis = FitChildren.FitAxis.Height
		}, {
			Layout = Roact.createElement("UIListLayout"),
			Padding = Roact.createElement("UIPadding", v16),
			Content = Roact.createElement(renderContent)
		})
	})
end

return v12
