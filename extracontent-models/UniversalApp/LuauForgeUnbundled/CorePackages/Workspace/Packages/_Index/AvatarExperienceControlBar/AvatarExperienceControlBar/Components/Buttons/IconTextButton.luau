local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/Localization")

local useSemanticTokens = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Hooks/useSemanticTokens")
local useLocalization = Localization.Hooks.useLocalization
local useHoverBinding = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Hooks/useHoverBinding")

local isBuilderIcon = Foundation.Utility.isBuilderIcon

local fFlagAXMigrateBuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceFlags").FFlagAXMigrateBuilderIcons
local fFlagAXResetAvatarButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceFlags").FFlagAXResetAvatarButton

return (React.forwardRef(function(props, p2)
	local v5 = useSemanticTokens()
	local v6, v7 = useHoverBinding()

	local v8 = if props.radius then props.radius else v5.defaultIconTextButtonRadius

	local v9 = useLocalization({ text = props.localizedTextKey })

	local text = if v9.text then v9.text else props.text
	local v10 = if props.iconSize then props.iconSize else v5.defaultIconSize

	local v11 = fFlagAXMigrateBuilderIcons and isBuilderIcon(props.icon)

	local createElement = React.createElement
	local view = Foundation.View
	local v12 = {
		onActivated = props.onActivated,
		isDisabled = props.disabled,
		tag = "auto-xy size-full-0 clip row gap-xsmall items-center",
		ref = p2,
		onStateChanged = v7,
		GroupTransparency = 0,
		backgroundStyle = 0,
		cornerRadius = 0,
		padding = 0,
		Visible = 0,
		LayoutOrder = 0
	}
	local v13

	if fFlagAXResetAvatarButton then
		if props.disabled then
			v13 = v5.contentDisabledTransparency
		else
			v13 = v5.contentForegroundStyle.Transparency
		end
	end

	v12.GroupTransparency = v13

	v12.backgroundStyle = v6:map(function(p3)
		return {
			Color3 = v5.hoverIconBackgroundStyle.Color3,
			Transparency = not p3 and 1 or v5.hoverIconBackgroundStyle.Transparency
		}
	end)

	v12.cornerRadius = UDim.new(0, v8)
	v12.padding = {
		left = UDim.new(0, v5.textButtonPaddingLeft),
		right = UDim.new(0, v5.textButtonPaddingRight),
		top = UDim.new(0, v5.textButtonPaddingY),
		bottom = UDim.new(0, v5.textButtonPaddingY)
	}

	v12.Visible = props.Visible
	v12.LayoutOrder = props.LayoutOrder

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local v14 = {
		Size = UDim2.new(0, v5.iconTextButtonIconContainerSize, 0, v5.iconTextButtonIconContainerSize),
		tag = fFlagAXMigrateBuilderIcons and {
			["radius-circle"] = true,
			["row align-x-center align-y-center"] = v11
		} or "radius-circle"
	}

	local v16 = if v11 then React.createElement(Foundation.Icon, {
		tag = "position-center-center anchor-center-center",
		name = props.icon,
		size = v10,
		style = v5.contentForegroundStyle
	}) else React.createElement(Foundation.Image, {
		tag = "position-center-center anchor-center-center",
		Image = props.icon,
		Size = UDim2.new(0, v10, 0, v10),
		imageStyle = v5.contentForegroundStyle
	})
	return createElement(view, v12, {
		Icon = createElement2(view2, v14, { IconImage = v16 }),
		Text = React.createElement(Foundation.Text, {
			Text = text,
			tag = "auto-xy text-title-medium content-emphasis"
		})
	})
end))
