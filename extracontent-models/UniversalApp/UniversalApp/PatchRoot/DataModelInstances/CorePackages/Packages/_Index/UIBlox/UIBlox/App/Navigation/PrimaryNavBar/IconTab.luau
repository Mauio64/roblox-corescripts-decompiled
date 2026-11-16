local parent = script.Parent.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent

local React = require(parent3.React)
local LuauPolyfill = require(parent3.LuauPolyfill)
local Object = LuauPolyfill.Object

local useStyle = require(parent2.Core.Style.useStyle)
local ImageSetComponent = require(parent2.Core.ImageSet.ImageSetComponent)
local Label = ImageSetComponent.Label
local GenericTextLabel = require(parent2.Core.Text.GenericTextLabel.GenericTextLabel)
local Placement = require(parent.Enum.Placement)
local ControlState = require(parent2.Core.Control.Enum.ControlState)
local IconSize = require(parent2.App.ImageSet.Enum.IconSize)
local getIconSize = require(parent2.App.ImageSet.getIconSize)

local HorizontalContainer = require(script.Parent.HorizontalContainer)

require(script.Parent.Types)

local Constants = require(script.Parent.Constants)

local v = {
	selected = false,
	controlState = ControlState.Default,
	padding = {
		left = Constants.ICON_TAB_ITEM_PADDING_LEFT,
		right = Constants.ICON_TAB_ITEM_PADDING_RIGHT
	}
}

local function IconTab(p)
	local v2 = Object.assign({}, v, p)
	local item = v2.item
	local pressed = v2.controlState == ControlState.SelectedPressed
	local selected = v2.selected
	local v3 = useStyle()
	local v4

	if selected then
		v4 = v3.Tokens.Color.Content.Emphasis
	else
		v4 = v3.Tokens.Color.Content.Default
	end

	local iconSize = getIconSize(IconSize.Medium, v3)
	local v5 = Constants.ICON_TAB_HEIGHT - Constants.ICON_TAB_PADDING * 2
	assert(item.icon == nil or item.iconComponent == nil, "icon or iconComponent cannot be assigned at same time")
	local spacing = item.icon == nil and item.iconComponent == nil and 0 or Constants.ICON_TAB_ITEM_ICON_TITLE_SPACING

	local v6 = {
		size = UDim2.new(0, 0, 0, Constants.ICON_TAB_HEIGHT),
		automaticSize = Enum.AutomaticSize.X,
		roundedBackgroundSize = UDim2.new(1, -(Constants.ICON_TAB_PADDING * 2), 0, v5),
		roundedBackgroundPosition = UDim2.fromOffset(Constants.ICON_TAB_PADDING, Constants.ICON_TAB_PADDING),
		roundedBackgroundColor = v3.Theme.Divider.Color,
		roundedBackgroundTransparency = Constants.ICON_TAB_SELECTED_TRANSPARENCY,
		spacing = spacing,
		padding = v2.padding,
		showRoundedBackground = 0,
		showOverlay = 0
	}
	local showRoundedBackground

	if item.showRoundedBackground == nil then
		showRoundedBackground = selected
	else
		showRoundedBackground = item.showRoundedBackground
	end

	v6.showRoundedBackground = showRoundedBackground
	local showOverlay

	if item.showOverlay == nil then
		showOverlay = pressed
	else
		showOverlay = item.showOverlay
	end

	v6.showOverlay = showOverlay
	local icon

	if item.icon == nil then
		if item.iconComponent ~= nil then
			icon = React.createElement(
				"Frame",
				{
					Size = UDim2.new(0, iconSize, 0, iconSize),
					BackgroundTransparency = 1,
					LayoutOrder = 1
				},
				React.createElement(item.iconComponent, {
					placement = Placement.Bottom,
					selected = selected,
					pressed = pressed,
					hovered = false
				})
			)
		end
	else
		icon = React.createElement(Label, {
			Size = UDim2.new(0, iconSize, 0, iconSize),
			LayoutOrder = 1,
			Image = item.icon,
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Fit,
			ImageColor3 = v4.Color3,
			ImageTransparency = v4.Transparency
		})
	end

	local createElement = React.createElement
	local v7 = {
		LayoutOrder = 2,
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		Text = item.title,
		fluidSizing = false,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		colorStyle = 0,
		fontStyle = 0,
		TextTruncate = 0,
		BackgroundTransparency = 1
	}
	local color

	if selected then
		color = v3.Theme.TextEmphasis.Color
	else
		color = v3.Theme.TextDefault.Color
	end

	v7.colorStyle = { Color = color, Transparency = 0 }

	v7.fontStyle = v3.Tokens.Typography.HeadingSmall
	v7.TextTruncate = Enum.TextTruncate.AtEnd
	return HorizontalContainer(v6, {
		Icon = icon,
		Title = createElement(GenericTextLabel, v7)
	})
end

return IconTab
