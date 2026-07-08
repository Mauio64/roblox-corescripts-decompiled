local ParentParent = script.Parent.Parent
local ParentParent2 = ParentParent.Parent.Parent
local ParentParent2Parent = ParentParent2.Parent
local React = require(ParentParent2Parent.React)
local Object = require(ParentParent2Parent.LuauPolyfill).Object
local useStyle = require(ParentParent2.Core.Style.useStyle)
local Label = require(ParentParent2.Core.ImageSet.ImageSetComponent).Label
local GenericTextLabel = require(ParentParent2.Core.Text.GenericTextLabel.GenericTextLabel)
local Placement = require(ParentParent.Enum.Placement)
local ControlState = require(ParentParent2.Core.Control.Enum.ControlState)
local IconSize = require(ParentParent2.App.ImageSet.Enum.IconSize)
local getIconSize = require(ParentParent2.App.ImageSet.getIconSize)
local HorizontalContainer = require(script.Parent.HorizontalContainer)

require(script.Parent.Types)

local Constants = require(script.Parent.Constants)
local t1 = {
	selected = false,
	controlState = ControlState.Default,
	padding = {
		left = Constants.ICON_TAB_ITEM_PADDING_LEFT,
		right = Constants.ICON_TAB_ITEM_PADDING_RIGHT
	}
}

local function IconTab(t2: {[any]: any}) -- line: 45
	-- upvalues: Object (copy), t1 (copy), ControlState (copy), useStyle (copy), getIconSize (copy), IconSize (copy), Constants (copy), HorizontalContainer (copy), React (copy), Label (copy), Placement (copy), GenericTextLabel (copy)
	local v18 = Object.assign({}, t1, t2)
	local item = v18.item
	local v20 = v18.controlState == ControlState.SelectedPressed
	local selected = v18.selected
	local v22 = useStyle()
	local v23 = if not selected then v22.Tokens.Semantic.Color.Icon.Default else v22.Tokens.Semantic.Color.Icon.Emphasis
	local v24 = getIconSize(IconSize.Medium, v22)
	local v25 = Constants.ICON_TAB_HEIGHT - Constants.ICON_TAB_PADDING * 2

	assert(item.icon == nil or item.iconComponent == nil, "icon or iconComponent cannot be assigned at same time")

	local v26 = item.icon == nil and item.iconComponent == nil and 0 or Constants.ICON_TAB_ITEM_ICON_TITLE_SPACING

	return HorizontalContainer({
		size = UDim2.new(0, 0, 0, Constants.ICON_TAB_HEIGHT),
		automaticSize = Enum.AutomaticSize.X,
		roundedBackgroundSize = UDim2.new(1, -(Constants.ICON_TAB_PADDING * 2), 0, v25),
		roundedBackgroundPosition = UDim2.fromOffset(Constants.ICON_TAB_PADDING, Constants.ICON_TAB_PADDING),
		roundedBackgroundColor = v22.Theme.Divider.Color,
		roundedBackgroundTransparency = Constants.ICON_TAB_SELECTED_TRANSPARENCY,
		spacing = v26,
		padding = v18.padding,
		showRoundedBackground = if item.showRoundedBackground == nil then selected else item.showRoundedBackground,
		showOverlay = if item.showOverlay == nil then v20 else item.showOverlay
	}, {
		Icon = if item.icon == nil then if item.iconComponent == nil then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(0, v24, 0, v24)
		}, React.createElement(item.iconComponent, {
			hovered = false,
			placement = Placement.Bottom,
			selected = selected,
			pressed = v20
		})) else React.createElement(Label, {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, v24, 0, v24),
			Image = item.icon,
			ScaleType = Enum.ScaleType.Fit,
			ImageColor3 = v23.Color3,
			ImageTransparency = v23.Transparency
		}),
		Title = React.createElement(GenericTextLabel, {
			LayoutOrder = 2,
			fluidSizing = false,
			TextWrapped = true,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			Text = item.title,
			TextXAlignment = Enum.TextXAlignment.Left,
			colorStyle = {
				Transparency = 0,
				Color = if not selected then v22.Theme.TextDefault.Color else v22.Theme.TextEmphasis.Color
			},
			fontStyle = v22.Tokens.Semantic.Typography.Header,
			TextTruncate = Enum.TextTruncate.AtEnd
		})
	})
end

return IconTab
