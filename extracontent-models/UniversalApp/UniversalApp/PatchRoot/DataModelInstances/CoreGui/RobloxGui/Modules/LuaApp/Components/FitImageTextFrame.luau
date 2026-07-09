local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(Modules.Common.Roact)
local Constants = require(Modules.LuaApp.Constants)
local FitChildren = require(Modules.LuaApp.FitChildren)
local FitTextLabel = require(Modules.LuaApp.Components.FitTextLabel)
local LocalizedFitTextLabel = require(Modules.LuaApp.Components.LocalizedFitTextLabel)
local ImageSetLabel = require(CorePackages.Packages.UIBlox).Core.ImageSet.ImageSetLabel
local v9 = Roact.PureComponent:extend("FitImageTextFrame")
local t1 = {
	ImageTransparency = 0,
	ImageColor3 = Constants.Color.GRAY2
}
local t2 = {
	TextTransparency = 0,
	useLocalizedText = false,
	Font = Enum.Font.SourceSans,
	TextColor3 = Constants.Color.GRAY2
}

v9.defaultProps = {
	LayoutOrder = 1,
	padding = 0,
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(0, 0, 1, 0),
	VerticalAlignment = Enum.VerticalAlignment.Center,
	imageProps = t1,
	textProps = t2
}

function v9.render(p1) -- line: 39
	-- upvalues: ImageSetLabel (copy), Roact (copy), FitChildren (copy), LocalizedFitTextLabel (copy), FitTextLabel (copy)
	local v13 = ImageSetLabel
	local propsPosition = p1.props.Position
	local propsSize = p1.props.Size
	local propsLayoutOrder = p1.props.LayoutOrder
	local VerticalAlignment = p1.props.VerticalAlignment
	local padding = p1.props.padding
	local imageProps = p1.props.imageProps
	local textProps = p1.props.textProps

	return Roact.createElement(FitChildren.FitFrame, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = propsPosition,
		Size = propsSize,
		LayoutOrder = propsLayoutOrder,
		fitAxis = FitChildren.FitAxis.Width
	}, {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = VerticalAlignment,
			Padding = UDim.new(0, padding)
		}),
		Image = Roact.createElement(v13, {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = imageProps.Size,
			Image = imageProps.Image,
			ImageColor3 = imageProps.ImageColor3,
			ImageTransparency = imageProps.ImageTransparency
		}),
		Text = Roact.createElement(textProps.useLocalizedText and LocalizedFitTextLabel or FitTextLabel, {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 0, 1, 0),
			Font = textProps.Font,
			Text = textProps.Text,
			TextSize = textProps.TextSize,
			TextColor3 = textProps.TextColor3,
			TextTransparency = textProps.TextTransparency,
			fitAxis = FitChildren.FitAxis.Width
		})
	})
end

return v9
