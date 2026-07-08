local App = script:FindFirstAncestor("App")
local AppParent = App.Parent
local AppParentParent = AppParent.Parent
local React = require(AppParentParent.React)
local Cryo = require(AppParentParent.Cryo)

require(App.ImageSet.ImagesTypes)
require(App.Style.StyleTypes)

local IconSize = require(App.ImageSet.Enum.IconSize)
local getIconSize = require(App.ImageSet.getIconSize)
local Label = require(AppParent.Core.ImageSet.ImageSetComponent).Label
local GenericTextLabel = require(AppParent.Core.Text.GenericTextLabel.GenericTextLabel)
local useStyle = require(AppParent.Core.Style.useStyle)
local t1 = {
	containerPaddingLeft = 12,
	containerPaddingRight = 12,
	containerGap = 12,
	dataGap = 0,
	iconSize = getIconSize(IconSize.Large)
}

local function StatWidget(t2: {[any]: any}) -- line: 65
	-- upvalues: useStyle (copy), Cryo (copy), t1 (copy), React (copy), Label (copy), GenericTextLabel (copy)
	local v14 = useStyle()
	local v15 = Cryo.Dictionary.join(t1, t2.styleProps or {})
	local containerPaddingLeft = v15.containerPaddingLeft
	local containerPaddingRight = v15.containerPaddingRight
	local containerGap = v15.containerGap
	local iconSize = v15.iconSize
	local v20 = v15.iconContentColor or v14.Theme.IconEmphasis
	local dataGap = v15.dataGap
	local v22 = v15.dataContentColor or v14.Theme.TextEmphasis
	local v23 = v15.dataLabelContentColor or v14.Theme.TextEmphasis

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = t2.position,
		AnchorPoint = t2.anchorPoint,
		Size = t2.size,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t2.layoutOrder
	}, {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = t2.horizontalAlignment,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, containerGap)
		}),
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, containerPaddingLeft),
			PaddingRight = UDim.new(0, containerPaddingRight)
		}),
		Icon = React.createElement(Label, {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, iconSize, 0, iconSize),
			Image = t2.icon,
			ImageColor3 = v20.Color,
			Position = UDim2.new(0, 0, 0, 0)
		}),
		TextSection = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			Position = UDim2.new(0, iconSize + containerGap, 0, 0)
		}, {
			ListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, dataGap)
			}),
			Number = React.createElement(GenericTextLabel, {
				LayoutOrder = 1,
				fluidSizing = true,
				TextWrapped = false,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				Text = t2.countText,
				TextXAlignment = Enum.TextXAlignment.Left,
				colorStyle = v22,
				fontStyle = v14.Font.Title,
				TextTruncate = Enum.TextTruncate.AtEnd
			}),
			Label = React.createElement(GenericTextLabel, {
				LayoutOrder = 2,
				fluidSizing = true,
				TextWrapped = false,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				Text = t2.labelText,
				TextXAlignment = Enum.TextXAlignment.Left,
				colorStyle = v23,
				fontStyle = v14.Font.CaptionHeader,
				TextTruncate = Enum.TextTruncate.AtEnd
			})
		})
	})
end

return StatWidget
