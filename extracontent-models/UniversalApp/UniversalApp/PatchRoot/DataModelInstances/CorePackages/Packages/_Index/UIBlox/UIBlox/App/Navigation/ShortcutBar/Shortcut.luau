local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local UIBloxConfig = require(parent2.UIBloxConfig)

local React = require(parent3.React)
local LuauPolyfill = require(parent3.LuauPolyfill)
local Object = LuauPolyfill.Object
local Foundation = require(parent3.Foundation)

local useStyle = require(parent2.Core.Style.useStyle)
local ImageSetComponent = require(parent2.Core.ImageSet.ImageSetComponent)

local IconSize = require(parent.ImageSet.Enum.IconSize)
local getIconSize = require(parent.ImageSet.getIconSize)
local GenericTextLabel = require(parent2.Core.Text.GenericTextLabel.GenericTextLabel)
local KeyLabel = require(parent.Menu.KeyLabel.KeyLabel)

local ProgressIconAnimated = require(script.Parent.ProgressIconAnimated)
require(script.Parent.Types)

local v = {
	iconLabelGap = 6,
	actionTextSpacingLeading = 12,
	size = UDim2.fromOffset(0, 0),
	automaticSize = Enum.AutomaticSize.XY
}

local v2 = {
	hasProgress = false,
	animationTriggerTime = 0.3,
	animationKeyHoldingTime = 1.5,
	animationCoolDownTime = 0.75
}

local function renderIcon(p, p2)
	local layoutOrder = p.layoutOrder
	local itemProps = p.itemProps
	local v3 = Foundation.Hooks.useTokens()
	local v4

	if UIBloxConfig.useTokenizedShortcutBar then
		v4 = v3.Size.Size_600
	else
		v4 = getIconSize(IconSize.Medium)
	end

	local hasProgress = itemProps.hasProgress
	local v5

	if hasProgress then
		v5 = itemProps
	end

	local icon = itemProps.icon

	local x = nil
	local v6 = typeof(icon) == "EnumItem"
	local v7

	if typeof(icon) == "table" then
		v7 = #icon > 0
	else
		v7 = false
	end

	if v6 or v7 then
		x = Enum.AutomaticSize.X
	end

	local image

	if v6 then
		image = React.createElement(KeyLabel, { keyCode = icon, iconThemeKey = "IconEmphasis" })
	elseif v7 then
		local children = {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center
			})
		}

		for k, item in icon do
			children["KeyLabel" .. k] = React.createElement(KeyLabel, {
				keyCode = item,
				LayoutOrder = k,
				iconThemeKey = "IconEmphasis"
			})
		end

		image = React.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1
			},
			children
		)
	else
		image = React.createElement(ImageSetComponent.Label, {
			Size = UDim2.fromScale(1, 1),
			Image = icon,
			ImageColor3 = p2.Theme.TextEmphasis.Color,
			ImageTransparency = p2.Theme.TextEmphasis.Transparency,
			BackgroundTransparency = 1
		})
	end

	local createElement = React.createElement
	local v8 = {
		LayoutOrder = layoutOrder,
		Size = UDim2.fromOffset(v4, v4),
		AutomaticSize = x,
		BorderSizePixel = 0,
		BackgroundTransparency = 1
	}
	local progressIcon

	if hasProgress then
		progressIcon = React.createElement(ProgressIconAnimated, v5)
	end

	if hasProgress then
		image = nil
	end

	return createElement("Frame", v8, { ProgressIcon = progressIcon, Image = image })
end

local function Shortcut(p)
	local v3 = Object.assign({}, v, p)
	local itemProps = Object.assign({}, v2, v3.publicProps)

	local v4 = useStyle()
	local v5 = Foundation.Hooks.useTokens()
	local index = v3.index

	local createElement = React.createElement
	local size

	if UIBloxConfig.enableShortcutCustomization then
		size = v3.size
	else
		size = UDim2.fromOffset(0, 0)
	end

	local automaticSize

	if UIBloxConfig.enableShortcutCustomization then
		automaticSize = v3.automaticSize
	else
		automaticSize = Enum.AutomaticSize.XY
	end

	local v6 = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v3.iconLabelGap)
		}),
		ActionText = 0,
		Icon = 0,
		LabelText = 0
	}
	local actionText

	if itemProps.actionText then
		actionText = React.createElement("Frame", {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(0, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v3.actionTextSpacingLeading)
			}),
			Label = React.createElement(GenericTextLabel, {
				Size = UDim2.fromOffset(0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				Text = itemProps.actionText,
				colorStyle = v4.Theme.TextEmphasis,
				fontStyle = v4.Font.SubHeader1,
				BackgroundTransparency = 1
			})
		})
	end

	v6.ActionText = actionText
	local icon

	if UIBloxConfig.enableShortcutCustomization and v3.renderIcon then
		icon = v3.renderIcon({ layoutOrder = 2 })
	else
		icon = renderIcon({ layoutOrder = 2, itemProps = itemProps }, v4)
	end

	v6.Icon = icon

	local createElement2 = React.createElement
	local v7 = {
		LayoutOrder = 3,
		Size = UDim2.fromOffset(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		Text = itemProps.text,
		TextSize = 0,
		colorStyle = 0,
		fontStyle = 0,
		BackgroundTransparency = 1
	}
	local textSize

	if UIBloxConfig.enableShortcutCustomization and v3.labelTextSize then
		textSize = v3.labelTextSize
	elseif UIBloxConfig.useTokenizedShortcutBar then
		textSize = v5.FontSize.FontSize_50
	end

	v7.TextSize = textSize
	local colorStyle

	if UIBloxConfig.enableShortcutCustomization and v3.labelColorStyle then
		colorStyle = v3.labelColorStyle
	else
		colorStyle = v4.Theme.TextEmphasis
	end

	v7.colorStyle = colorStyle
	local fontStyle

	if UIBloxConfig.enableShortcutCustomization and v3.labelFontStyle then
		fontStyle = v3.labelFontStyle
	else
		fontStyle = v4.Font.SubHeader1
	end

	v7.fontStyle = fontStyle
	v6.LabelText = createElement2(GenericTextLabel, v7)
	return createElement("Frame", {
		LayoutOrder = index,
		Size = size,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		AutomaticSize = automaticSize
	}, v6)
end

return Shortcut
