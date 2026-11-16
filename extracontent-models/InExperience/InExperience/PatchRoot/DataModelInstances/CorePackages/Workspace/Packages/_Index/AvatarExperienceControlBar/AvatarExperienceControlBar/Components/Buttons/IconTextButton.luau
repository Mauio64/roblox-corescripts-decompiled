local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")

local parent = AvatarExperienceControlBar.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)

local useSemanticTokens = require(AvatarExperienceControlBar.Hooks.useSemanticTokens)
local useLocalization = Localization.Hooks.useLocalization
local useHoverBinding = require(AvatarExperienceControlBar.Hooks.useHoverBinding)

local isBuilderIcon = Foundation.Utility.isBuilderIcon

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXMigrateBuilderIcons = AvatarExperienceFlags.FFlagAXMigrateBuilderIcons
local AvatarExperienceFlags2 = require(parent.AvatarExperienceFlags)
local FFlagAXResetAvatarButton = AvatarExperienceFlags2.FFlagAXResetAvatarButton

return (React.forwardRef(function(props, ref)
	local v = useSemanticTokens()
	local v2, onStateChanged = useHoverBinding()
	local v3

	if props.radius then
		v3 = props.radius
	else
		v3 = v.defaultIconTextButtonRadius
	end

	local v4 = useLocalization({ text = props.localizedTextKey })

	local text = if v4.text then v4.text else props.text
	local size

	if props.iconSize then
		size = props.iconSize
	else
		size = v.defaultIconSize
	end

	local rowalignxcenteralignycenter = FFlagAXMigrateBuilderIcons and isBuilderIcon(props.icon)

	local createElement = React.createElement
	local view = Foundation.View
	local v5 = {
		onActivated = props.onActivated,
		isDisabled = props.disabled,
		tag = "auto-xy size-full-0 clip row gap-xsmall items-center",
		ref = ref,
		onStateChanged = onStateChanged,
		GroupTransparency = 0,
		backgroundStyle = 0,
		cornerRadius = 0,
		padding = 0,
		Visible = 0,
		LayoutOrder = 0
	}
	local groupTransparency

	if FFlagAXResetAvatarButton then
		if props.disabled then
			groupTransparency = v.contentDisabledTransparency
		else
			groupTransparency = v.contentForegroundStyle.Transparency
		end
	end

	v5.GroupTransparency = groupTransparency

	v5.backgroundStyle = v2:map(function(p)
		return {
			Color3 = v.hoverIconBackgroundStyle.Color3,
			Transparency = not p and 1 or v.hoverIconBackgroundStyle.Transparency
		}
	end)

	v5.cornerRadius = UDim.new(0, v3)
	v5.padding = {
		left = UDim.new(0, v.textButtonPaddingLeft),
		right = UDim.new(0, v.textButtonPaddingRight),
		top = UDim.new(0, v.textButtonPaddingY),
		bottom = UDim.new(0, v.textButtonPaddingY)
	}

	v5.Visible = props.Visible
	v5.LayoutOrder = props.LayoutOrder

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v6 = {
		Size = UDim2.new(0, v.iconTextButtonIconContainerSize, 0, v.iconTextButtonIconContainerSize),
		tag = FFlagAXMigrateBuilderIcons and {
			["radius-circle"] = true,
			["row align-x-center align-y-center"] = rowalignxcenteralignycenter
		} or "radius-circle"
	}
	local iconImage

	if rowalignxcenteralignycenter then
		iconImage = React.createElement(Foundation.Icon, {
			tag = "position-center-center anchor-center-center",
			name = props.icon,
			size = size,
			style = v.contentForegroundStyle
		})
	else
		iconImage = React.createElement(Foundation.Image, {
			tag = "position-center-center anchor-center-center",
			Image = props.icon,
			Size = UDim2.new(0, size, 0, size),
			imageStyle = v.contentForegroundStyle
		})
	end

	return createElement(view, v5, {
		Icon = createElement2(view2, v6, { IconImage = iconImage }),
		Text = React.createElement(Foundation.Text, {
			Text = text,
			tag = "auto-xy text-title-medium content-emphasis"
		})
	})
end))
