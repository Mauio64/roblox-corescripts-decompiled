local App = script:FindFirstAncestor("App")
local parent = App.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Cryo = require(parent2.Cryo)

require(App.ImageSet.ImagesTypes)
require(App.Style.StyleTypes)

local IconSize = require(App.ImageSet.Enum.IconSize)
local getIconSize = require(App.ImageSet.getIconSize)
local ImageSetComponent = require(parent.Core.ImageSet.ImageSetComponent)
local Label = ImageSetComponent.Label
local GenericTextLabel = require(parent.Core.Text.GenericTextLabel.GenericTextLabel)
local useStyle = require(parent.Core.Style.useStyle)

local v = {
	containerPaddingLeft = 12,
	containerPaddingRight = 12,
	containerGap = 12,
	iconSize = getIconSize(IconSize.Large),
	dataGap = 0
}

local function StatWidget(props)
	local v2 = useStyle()

	local joined = Cryo.Dictionary.join(v, props.styleProps or {})
	local containerPaddingLeft = joined.containerPaddingLeft
	local containerPaddingRight = joined.containerPaddingRight
	local containerGap = joined.containerGap
	local iconSize = joined.iconSize
	local iconContentColor = joined.iconContentColor or v2.Theme.IconEmphasis
	local dataGap = joined.dataGap
	local dataContentColor = joined.dataContentColor or v2.Theme.TextEmphasis
	local dataLabelContentColor = joined.dataLabelContentColor or v2.Theme.TextEmphasis

	return React.createElement("Frame", {
		Position = props.position,
		AnchorPoint = props.anchorPoint,
		Size = props.size,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder
	}, {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = props.horizontalAlignment,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, containerGap)
		}),
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, containerPaddingLeft),
			PaddingRight = UDim.new(0, containerPaddingRight)
		}),
		Icon = React.createElement(Label, {
			Size = UDim2.new(0, iconSize, 0, iconSize),
			Image = props.icon,
			ImageColor3 = iconContentColor.Color,
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1
		}),
		TextSection = React.createElement("Frame", {
			Size = UDim2.fromScale(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, iconSize + containerGap, 0, 0)
		}, {
			ListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, dataGap)
			}),
			Number = React.createElement(GenericTextLabel, {
				Size = UDim2.fromScale(0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				LayoutOrder = 1,
				Text = props.countText,
				fluidSizing = true,
				TextWrapped = false,
				TextXAlignment = Enum.TextXAlignment.Left,
				colorStyle = dataContentColor,
				fontStyle = v2.Font.Title,
				TextTruncate = Enum.TextTruncate.AtEnd,
				BackgroundTransparency = 1
			}),
			Label = React.createElement(GenericTextLabel, {
				Size = UDim2.fromScale(0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				LayoutOrder = 2,
				Text = props.labelText,
				fluidSizing = true,
				TextWrapped = false,
				TextXAlignment = Enum.TextXAlignment.Left,
				colorStyle = dataLabelContentColor,
				fontStyle = v2.Font.CaptionHeader,
				TextTruncate = Enum.TextTruncate.AtEnd,
				BackgroundTransparency = 1
			})
		})
	})
end

return StatWidget
