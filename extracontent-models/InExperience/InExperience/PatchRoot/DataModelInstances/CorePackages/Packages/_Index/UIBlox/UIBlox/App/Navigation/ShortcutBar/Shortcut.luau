local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local UIBloxConfig = require(ParentParentParent.UIBloxConfig)
local React = require(ParentParentParentParent.React)
local Object = require(ParentParentParentParent.LuauPolyfill).Object
local Foundation = require(ParentParentParentParent.Foundation)
local useStyle = require(ParentParentParent.Core.Style.useStyle)
local ImageSetComponent = require(ParentParentParent.Core.ImageSet.ImageSetComponent)
local IconSize = require(ParentParent.ImageSet.Enum.IconSize)
local getIconSize = require(ParentParent.ImageSet.getIconSize)
local GenericTextLabel = require(ParentParentParent.Core.Text.GenericTextLabel.GenericTextLabel)
local KeyLabel = require(ParentParent.Menu.KeyLabel.KeyLabel)
local ProgressIconAnimated = require(script.Parent.ProgressIconAnimated)

require(script.Parent.Types)

local t1 = {
	iconLabelGap = 6,
	actionTextSpacingLeading = 12,
	size = UDim2.fromOffset(0, 0),
	automaticSize = Enum.AutomaticSize.XY
}
local t2 = {
	hasProgress = false,
	animationTriggerTime = 0.3,
	animationKeyHoldingTime = 1.5,
	animationCoolDownTime = 0.75
}

local function renderIcon(t3: {[any]: any}, p1) -- line: 43
	-- upvalues: Foundation (copy), UIBloxConfig (copy), getIconSize (copy), IconSize (copy), React (copy), KeyLabel (copy), ImageSetComponent (copy), ProgressIconAnimated (copy)
	local layoutOrder = t3.layoutOrder
	local itemProps = t3.itemProps
	local v23 = Foundation.Hooks.useTokens()
	local v24 = if not UIBloxConfig.useTokenizedShortcutBar then getIconSize(IconSize.Medium) else v23.Size.Size_600
	local hasProgress = itemProps.hasProgress
	local v26 = nil

	if hasProgress then
		v26 = itemProps
	end

	local icon = itemProps.icon
	local AutomaticSizeX = nil
	local v29 = typeof(icon) == "EnumItem"
	local v30 = typeof(icon) == "table" and #icon > 0

	if v29 or v30 then
		AutomaticSizeX = Enum.AutomaticSize.X
	end

	local v31

	if v29 then
		v31 = React.createElement(KeyLabel, {
			iconThemeKey = "IconEmphasis",
			keyCode = icon
		})
	elseif v30 then
		local t4 = {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center
			})
		}

		for v33, v34 in icon do
			t4["KeyLabel" .. v33] = React.createElement(KeyLabel, {
				iconThemeKey = "IconEmphasis",
				keyCode = v34,
				LayoutOrder = v33
			})
		end

		v31 = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		}, t4)
	else
		v31 = React.createElement(ImageSetComponent.Label, {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Image = icon,
			ImageColor3 = p1.Theme.TextEmphasis.Color,
			ImageTransparency = p1.Theme.TextEmphasis.Transparency
		})
	end

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		Size = UDim2.fromOffset(v24, v24),
		AutomaticSize = AutomaticSizeX
	}, {
		ProgressIcon = if not hasProgress then nil else React.createElement(ProgressIconAnimated, v26),
		Image = if not hasProgress then v31 else nil
	})
end
local function Shortcut(p2) -- line: 119
	-- upvalues: Object (copy), t1 (copy), t2 (copy), useStyle (copy), Foundation (copy), React (copy), UIBloxConfig (copy), GenericTextLabel (copy), renderIcon (copy)
	local v36 = Object.assign({}, t1, p2)
	local v37 = Object.assign({}, t2, v36.publicProps)
	local v38 = useStyle()
	local v39 = Foundation.Hooks.useTokens()
	local index = v36.index

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		LayoutOrder = index,
		Size = if not UIBloxConfig.enableShortcutCustomization then UDim2.fromOffset(0, 0) else v36.size,
		AutomaticSize = if not UIBloxConfig.enableShortcutCustomization then Enum.AutomaticSize.XY else v36.automaticSize
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v36.iconLabelGap)
		}),
		ActionText = if not v37.actionText then nil else React.createElement("Frame", {
			LayoutOrder = 1,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v36.actionTextSpacingLeading)
			}),
			Label = React.createElement(GenericTextLabel, {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				Text = v37.actionText,
				colorStyle = v38.Theme.TextEmphasis,
				fontStyle = v38.Font.SubHeader1
			})
		}),
		Icon = if not UIBloxConfig.enableShortcutCustomization or not v36.renderIcon then renderIcon({
			layoutOrder = 2,
			itemProps = v37
		}, v38) else v36.renderIcon({
			layoutOrder = 2
		}),
		LabelText = React.createElement(GenericTextLabel, {
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			Text = v37.text,
			TextSize = if not UIBloxConfig.enableShortcutCustomization or not v36.labelTextSize then if not UIBloxConfig.useTokenizedShortcutBar then nil else v39.FontSize.FontSize_50 else v36.labelTextSize,
			colorStyle = if not UIBloxConfig.enableShortcutCustomization or not v36.labelColorStyle then v38.Theme.TextEmphasis else v36.labelColorStyle,
			fontStyle = if not UIBloxConfig.enableShortcutCustomization or not v36.labelFontStyle then v38.Font.SubHeader1 else v36.labelFontStyle
		})
	})
end

return Shortcut
