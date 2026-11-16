local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/Foundation")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/ReactOtter")
local Tooltip = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Components/Tooltip")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/ControlBarTypes")
local fFlagAXAddToolTipToIconItemMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceFlags").FFlagAXAddToolTipToIconItemMenu
local fFlagAXMigrateBuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceFlags").FFlagAXMigrateBuilderIcons

local isBuilderIcon = Foundation.Utility.isBuilderIcon
local iconVariant = Foundation.Enums.IconVariant

local useSemanticTokens = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Hooks/useSemanticTokens")
local useHoverBinding = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Hooks/useHoverBinding")

local v5 = not fFlagAXMigrateBuilderIcons and "icons/navigation/close" or Foundation.Enums.IconName.X
local v6 = { dampingRatio = 1, frequency = 5 }

local function IconItem(props, p2)
	local v7 = useSemanticTokens()
	local v8, v9 = useHoverBinding()

	local v10, v11 = ReactOtter.useAnimatedBinding(0)

	local isActive = props.isActive or false

	local v12 = if props.size then props.size else v7.defaultIconContainerSize
	local v13

	if props.iconSize then
		v13 = props.iconSize
	else
		v13 = if fFlagAXMigrateBuilderIcons then v7.defaultLegacyIconSize else v7.defaultIconSize
	end

	local v14 = if props.activeIcon then props.activeIcon else v5
	local v15

	if fFlagAXMigrateBuilderIcons then
		v15 = if props.activeIconVariant then props.activeIconVariant else iconVariant.Regular
	end

	local v16

	if props.activeIconSize then
		v16 = props.activeIconSize
	else
		v16 = if v14 == v5 then v7.closeIconSize else v13
	end

	React.useEffect(function()
		if props.animate then
			v11(ReactOtter.spring(isActive and 1 or 0, v6))
		else
			v11(ReactOtter.instant(isActive and 1 or 0))
		end
	end, { isActive, props.animate })

	if fFlagAXAddToolTipToIconItemMenu then
		local createElement = React.createElement
		local view = Foundation.View
		local v17 = {
			Size = UDim2.new(0, v12, 0, v12),
			LayoutOrder = props.LayoutOrder,
			tag = "row align-x-center align-y-center"
		}

		local createElement2 = React.createElement

		local toolTipConfig = props.toolTipConfig
		local createElement3 = React.createElement
		local view2 = Foundation.View
		local v20 = {
			Size = UDim2.new(0, v12, 0, v12),
			onStateChanged = v9,
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			tag = "radius-circle",
			onActivated = props.onActivated,
			disabled = props.disabled,
			ref = p2,
			LayoutOrder = props.LayoutOrder
		}

		local createElement4 = React.createElement
		local view3 = Foundation.View
		local v22 = {
			Size = UDim2.fromScale(1, 1),
			Visible = (not props.isActive or props.animate) and true or false,
			backgroundStyle = 0,
			tag = 0
		}
		local v23

		if not props.disabled then
			v23 = v8:map(function(p3)
				return {
					Color3 = v7.hoverIconBackgroundStyle.Color3,
					Transparency = not p3 and 1 or v7.hoverIconBackgroundStyle.Transparency
				}
			end)
		end

		v22.backgroundStyle = v23

		v22.tag = fFlagAXMigrateBuilderIcons
			and {
				["radius-circle position-center-center anchor-center-center clip"] = true,
				["row align-x-center align-y-center"] = isBuilderIcon(props.icon)
			}
			or "radius-circle position-center-center anchor-center-center clip"
		local v25

		if fFlagAXMigrateBuilderIcons and isBuilderIcon(props.icon) then
			local createElement5 = React.createElement
			local icon = Foundation.Icon
			local v26 = {
				name = props.icon,
				size = v10:map(function(p3)
					return (math.round((1 - p3) * v13))
				end),
				variant = 0,
				style = 0,
				tag = "position-center-center anchor-center-center content-emphasis"
			}

			local v27 = if props.iconVariant then props.iconVariant else iconVariant.Regular
			v26.variant = v27
			local v28 = { Color3 = v7.contentForegroundStyle.Color3, Transparency = 0 }
			local v29 = if props.disabled then v7.contentDisabledTransparency else v7.contentForegroundStyle.Transparency
			v28.Transparency = v29
			v26.style = v28
			v25 = createElement5(icon, v26)
		else
			local createElement5 = React.createElement
			local image = Foundation.Image
			local v26 = {
				Image = props.icon,
				Size = v10:map(function(p3)
					local v27 = math.round((1 - p3) * v13)
					return UDim2.fromOffset(v27, v27)
				end),
				imageStyle = 0,
				tag = "position-center-center anchor-center-center content-emphasis"
			}

			local v27 = { Color3 = v7.contentForegroundStyle.Color3, Transparency = 0 }
			local v28 = if props.disabled then v7.contentDisabledTransparency else v7.contentForegroundStyle.Transparency
			v27.Transparency = v28
			v26.imageStyle = v27
			v25 = createElement5(image, v26)
		end

		local v21 = {
			Icon = createElement4(view3, v22, { IconImage = v25 }),
			ActiveIcon = 0
		}
		local v26

		if isActive or props.animate then
			local createElement5 = React.createElement
			local view4 = Foundation.View
			local v27 = {
				Size = UDim2.fromScale(1, 1),
				GroupTransparency = v10:map(function(p3)
					return 1 - p3
				end),
				backgroundStyle = 0,
				tag = 0
			}
			local v28

			if not props.disabled then
				v28 = v8:map(function(p3)
					if p3 then
						return v7.hoverIconBackgroundStyle
					end

					return v7.activeIconBackgroundStyle
				end)
			end

			v27.backgroundStyle = v28

			v27.tag = fFlagAXMigrateBuilderIcons
				and {
					["radius-circle position-center-center anchor-center-center clip"] = true,
					["row align-x-center align-y-center"] = isBuilderIcon(v14)
				}
				or "radius-circle position-center-center anchor-center-center clip"
			local v30

			if fFlagAXMigrateBuilderIcons and isBuilderIcon(v14) then
				local createElement6 = React.createElement
				local icon = Foundation.Icon
				local v31 = {
					name = v14,
					size = v10:map(function(p3)
						return (math.round(p3 * v13))
					end),
					variant = v15,
					style = 0,
					tag = "size-full-full position-center-center anchor-center-center content-emphasis"
				}

				local v32 = {
					Color3 = v7.contentForegroundStyle.Color3,
					Transparency = 0
				}
				local v33 = if props.disabled then v7.contentDisabledTransparency else v7.contentForegroundStyle.Transparency
				v32.Transparency = v33
				v31.style = v32
				v30 = createElement6(icon, v31)
			else
				v30 = React.createElement(Foundation.Image, {
					Image = v14,
					Size = v10:map(function(p3)
						local v31 = math.round(p3 * v16)
						return UDim2.fromOffset(v31, v31)
					end),
					tag = "position-center-center anchor-center-center clip content-emphasis"
				})
			end

			v26 = createElement5(view4, v27, { ActiveIconImage = v30 })
		end

		v21.ActiveIcon = v26
		return createElement(view, v17, {
			TooltipIconItem = createElement2(Tooltip, toolTipConfig, createElement3(view2, v20, v21))
		})
	else
		local createElement = React.createElement
		local view = Foundation.View
		local v17 = {
			Size = UDim2.new(0, v12, 0, v12),
			onStateChanged = v9,
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			tag = "radius-circle",
			onActivated = props.onActivated,
			disabled = props.disabled,
			ref = p2,
			LayoutOrder = props.LayoutOrder
		}

		local createElement2 = React.createElement
		local view2 = Foundation.View
		local v19 = {
			Size = UDim2.fromScale(1, 1),
			Visible = (not props.isActive or props.animate) and true or false,
			backgroundStyle = 0,
			tag = 0
		}
		local v20

		if not props.disabled then
			v20 = v8:map(function(p3)
				return {
					Color3 = v7.hoverIconBackgroundStyle.Color3,
					Transparency = not p3 and 1 or v7.hoverIconBackgroundStyle.Transparency
				}
			end)
		end

		v19.backgroundStyle = v20

		v19.tag = fFlagAXMigrateBuilderIcons
			and {
				["radius-circle position-center-center anchor-center-center clip"] = true,
				["row align-x-center align-y-center"] = isBuilderIcon(props.icon)
			}
			or "radius-circle position-center-center anchor-center-center clip"
		local v22

		if fFlagAXMigrateBuilderIcons and isBuilderIcon(props.icon) then
			local createElement3 = React.createElement
			local icon = Foundation.Icon
			local v23 = {
				name = props.icon,
				size = v10:map(function(p3)
					return (math.round((1 - p3) * v13))
				end),
				variant = 0,
				style = 0,
				tag = "position-center-center anchor-center-center content-emphasis"
			}

			local v24 = if props.iconVariant then props.iconVariant else iconVariant.Regular
			v23.variant = v24
			local v25 = { Color3 = v7.contentForegroundStyle.Color3, Transparency = 0 }
			local v26 = if props.disabled then v7.contentDisabledTransparency else v7.contentForegroundStyle.Transparency
			v25.Transparency = v26
			v23.style = v25
			v22 = createElement3(icon, v23)
		else
			local createElement3 = React.createElement
			local image = Foundation.Image
			local v23 = {
				Image = props.icon,
				Size = v10:map(function(p3)
					local v24 = math.round((1 - p3) * v13)
					return UDim2.fromOffset(v24, v24)
				end),
				imageStyle = 0,
				tag = "position-center-center anchor-center-center content-emphasis"
			}

			local v24 = { Color3 = v7.contentForegroundStyle.Color3, Transparency = 0 }
			local v25 = if props.disabled then v7.contentDisabledTransparency else v7.contentForegroundStyle.Transparency
			v24.Transparency = v25
			v23.imageStyle = v24
			v22 = createElement3(image, v23)
		end

		local v18 = {
			Icon = createElement2(view2, v19, { IconImage = v22 }),
			ActiveIcon = 0
		}
		local v23

		if isActive or props.animate then
			local createElement3 = React.createElement
			local view3 = Foundation.View
			local v24 = {
				Size = UDim2.fromScale(1, 1),
				GroupTransparency = v10:map(function(p3)
					return 1 - p3
				end),
				backgroundStyle = 0,
				tag = 0
			}
			local v25

			if not props.disabled then
				v25 = v8:map(function(p3)
					if p3 then
						return v7.hoverIconBackgroundStyle
					end

					return v7.activeIconBackgroundStyle
				end)
			end

			v24.backgroundStyle = v25

			v24.tag = fFlagAXMigrateBuilderIcons
				and {
					["radius-circle position-center-center anchor-center-center clip"] = true,
					["row align-x-center align-y-center"] = isBuilderIcon(v14)
				}
				or "radius-circle position-center-center anchor-center-center clip"
			local v27

			if fFlagAXMigrateBuilderIcons and isBuilderIcon(v14) then
				v27 = React.createElement(Foundation.Icon, {
					name = v14,
					size = v10:map(function(p3)
						return (math.round((1 - p3) * v13))
					end),
					variant = v15,
					tag = "position-center-center anchor-center-center clip content-emphasis"
				})
			else
				v27 = React.createElement(Foundation.Image, {
					Image = v14,
					Size = v10:map(function(p3)
						local v28 = math.round(p3 * v16)
						return UDim2.fromOffset(v28, v28)
					end),
					tag = "position-center-center anchor-center-center clip content-emphasis"
				})
			end

			v23 = createElement3(view3, v24, { ActiveIconImage = v27 })
		end

		v18.ActiveIcon = v23
		return createElement(view, v17, v18)
	end
end

return React.forwardRef(IconItem)
