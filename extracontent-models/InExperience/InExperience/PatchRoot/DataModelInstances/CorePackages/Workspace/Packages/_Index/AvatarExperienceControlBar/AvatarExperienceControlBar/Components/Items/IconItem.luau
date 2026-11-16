local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")

local parent = AvatarExperienceControlBar.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local ReactOtter = require(parent.ReactOtter)
local Tooltip = require(AvatarExperienceControlBar.Components.Tooltip)
require(AvatarExperienceControlBar.ControlBarTypes)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXAddToolTipToIconItemMenu = AvatarExperienceFlags.FFlagAXAddToolTipToIconItemMenu
local AvatarExperienceFlags2 = require(parent.AvatarExperienceFlags)
local FFlagAXMigrateBuilderIcons = AvatarExperienceFlags2.FFlagAXMigrateBuilderIcons

local isBuilderIcon = Foundation.Utility.isBuilderIcon
local IconVariant = Foundation.Enums.IconVariant

local useSemanticTokens = require(AvatarExperienceControlBar.Hooks.useSemanticTokens)
local useHoverBinding = require(AvatarExperienceControlBar.Hooks.useHoverBinding)

local v = not FFlagAXMigrateBuilderIcons and "icons/navigation/close" or Foundation.Enums.IconName.X
local v2 = { dampingRatio = 1, frequency = 5 }

local function IconItem(props, ref)
	local v3 = useSemanticTokens()
	local v4, onStateChanged = useHoverBinding()

	local v5, v6 = ReactOtter.useAnimatedBinding(0)

	local isActive = props.isActive or false
	local v7

	if props.size then
		v7 = props.size
	else
		v7 = v3.defaultIconContainerSize
	end

	local v8

	if props.iconSize then
		v8 = props.iconSize
	elseif FFlagAXMigrateBuilderIcons then
		v8 = v3.defaultLegacyIconSize
	else
		v8 = v3.defaultIconSize
	end

	local v9 = if props.activeIcon then props.activeIcon else v
	local variant

	if FFlagAXMigrateBuilderIcons then
		if props.activeIconVariant then
			variant = props.activeIconVariant
		else
			variant = IconVariant.Regular
		end
	end

	local v10

	if props.activeIconSize then
		v10 = props.activeIconSize
	else
		v10 = if v9 == v then v3.closeIconSize else v8
	end

	React.useEffect(function()
		if props.animate then
			v6(ReactOtter.spring(isActive and 1 or 0, v2))
		else
			v6((ReactOtter.instant(isActive and 1 or 0)))
		end
	end, { isActive, props.animate })

	if FFlagAXAddToolTipToIconItemMenu then
		local createElement = React.createElement
		local view = Foundation.View
		local v11 = {
			Size = UDim2.new(0, v7, 0, v7),
			LayoutOrder = props.LayoutOrder,
			tag = "row align-x-center align-y-center"
		}

		local createElement2 = React.createElement

		local toolTipConfig = props.toolTipConfig
		local createElement3 = React.createElement
		local view2 = Foundation.View
		local v12 = {
			Size = UDim2.new(0, v7, 0, v7),
			onStateChanged = onStateChanged,
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			tag = "radius-circle",
			onActivated = props.onActivated,
			disabled = props.disabled,
			ref = ref,
			LayoutOrder = props.LayoutOrder
		}

		local createElement4 = React.createElement
		local view3 = Foundation.View
		local v13 = {
			Size = UDim2.fromScale(1, 1),
			Visible = (not props.isActive or props.animate) and true or false,
			backgroundStyle = 0,
			tag = 0
		}
		local backgroundStyle

		if not props.disabled then
			backgroundStyle = v4:map(function(p)
				return {
					Color3 = v3.hoverIconBackgroundStyle.Color3,
					Transparency = not p and 1 or v3.hoverIconBackgroundStyle.Transparency
				}
			end)
		end

		v13.backgroundStyle = backgroundStyle

		v13.tag = FFlagAXMigrateBuilderIcons
			and {
				["radius-circle position-center-center anchor-center-center clip"] = true,
				["row align-x-center align-y-center"] = isBuilderIcon(props.icon)
			}
			or "radius-circle position-center-center anchor-center-center clip"
		local iconImage

		if FFlagAXMigrateBuilderIcons and isBuilderIcon(props.icon) then
			local createElement5 = React.createElement
			local icon = Foundation.Icon
			local v14 = {
				name = props.icon,
				size = v5:map(function(p: number)
					return (math.round((1 - p) * v8))
				end),
				variant = 0,
				style = 0,
				tag = "position-center-center anchor-center-center content-emphasis"
			}
			local variant2

			if props.iconVariant then
				variant2 = props.iconVariant
			else
				variant2 = IconVariant.Regular
			end

			v14.variant = variant2
			local style = { Color3 = v3.contentForegroundStyle.Color3, Transparency = 0 }
			local transparency

			if props.disabled then
				transparency = v3.contentDisabledTransparency
			else
				transparency = v3.contentForegroundStyle.Transparency
			end

			style.Transparency = transparency
			v14.style = style
			iconImage = createElement5(icon, v14)
		else
			local createElement5 = React.createElement
			local image = Foundation.Image
			local v14 = {
				Image = props.icon,
				Size = v5:map(function(p: number)
					local v14 = math.round((1 - p) * v8)
					return UDim2.fromOffset(v14, v14)
				end),
				imageStyle = 0,
				tag = "position-center-center anchor-center-center content-emphasis"
			}

			local imageStyle = { Color3 = v3.contentForegroundStyle.Color3, Transparency = 0 }
			local transparency

			if props.disabled then
				transparency = v3.contentDisabledTransparency
			else
				transparency = v3.contentForegroundStyle.Transparency
			end

			imageStyle.Transparency = transparency
			v14.imageStyle = imageStyle
			iconImage = createElement5(image, v14)
		end

		local v14 = {
			Icon = createElement4(view3, v13, { IconImage = iconImage }),
			ActiveIcon = 0
		}
		local activeIcon

		if isActive or props.animate then
			local createElement5 = React.createElement
			local view4 = Foundation.View
			local v15 = {
				Size = UDim2.fromScale(1, 1),
				GroupTransparency = v5:map(function(p: number)
					return 1 - p
				end),
				backgroundStyle = 0,
				tag = 0
			}
			local backgroundStyle2

			if not props.disabled then
				backgroundStyle2 = v4:map(function(p)
					if p then
						return v3.hoverIconBackgroundStyle
					end

					return v3.activeIconBackgroundStyle
				end)
			end

			v15.backgroundStyle = backgroundStyle2

			v15.tag = FFlagAXMigrateBuilderIcons
				and {
					["radius-circle position-center-center anchor-center-center clip"] = true,
					["row align-x-center align-y-center"] = isBuilderIcon(v9)
				}
				or "radius-circle position-center-center anchor-center-center clip"
			local activeIconImage

			if FFlagAXMigrateBuilderIcons and isBuilderIcon(v9) then
				local createElement6 = React.createElement
				local icon = Foundation.Icon
				local v16 = {
					name = v9,
					size = v5:map(function(p: number)
						return (math.round(p * v8))
					end),
					variant = variant,
					style = 0,
					tag = "size-full-full position-center-center anchor-center-center content-emphasis"
				}

				local style = { Color3 = v3.contentForegroundStyle.Color3, Transparency = 0 }
				local transparency

				if props.disabled then
					transparency = v3.contentDisabledTransparency
				else
					transparency = v3.contentForegroundStyle.Transparency
				end

				style.Transparency = transparency
				v16.style = style
				activeIconImage = createElement6(icon, v16)
			else
				activeIconImage = React.createElement(Foundation.Image, {
					Image = v9,
					Size = v5:map(function(p: number)
						local v16 = math.round(p * v10)
						return UDim2.fromOffset(v16, v16)
					end),
					tag = "position-center-center anchor-center-center clip content-emphasis"
				})
			end

			activeIcon = createElement5(view4, v15, { ActiveIconImage = activeIconImage })
		end

		v14.ActiveIcon = activeIcon
		return createElement(view, v11, {
			TooltipIconItem = createElement2(Tooltip, toolTipConfig, createElement3(view2, v12, v14))
		})
	else
		local createElement = React.createElement
		local view = Foundation.View
		local v11 = {
			Size = UDim2.new(0, v7, 0, v7),
			onStateChanged = onStateChanged,
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			tag = "radius-circle",
			onActivated = props.onActivated,
			disabled = props.disabled,
			ref = ref,
			LayoutOrder = props.LayoutOrder
		}

		local createElement2 = React.createElement
		local view2 = Foundation.View
		local v12 = {
			Size = UDim2.fromScale(1, 1),
			Visible = (not props.isActive or props.animate) and true or false,
			backgroundStyle = 0,
			tag = 0
		}
		local backgroundStyle

		if not props.disabled then
			backgroundStyle = v4:map(function(p)
				return {
					Color3 = v3.hoverIconBackgroundStyle.Color3,
					Transparency = not p and 1 or v3.hoverIconBackgroundStyle.Transparency
				}
			end)
		end

		v12.backgroundStyle = backgroundStyle

		v12.tag = FFlagAXMigrateBuilderIcons
			and {
				["radius-circle position-center-center anchor-center-center clip"] = true,
				["row align-x-center align-y-center"] = isBuilderIcon(props.icon)
			}
			or "radius-circle position-center-center anchor-center-center clip"
		local iconImage

		if FFlagAXMigrateBuilderIcons and isBuilderIcon(props.icon) then
			local createElement3 = React.createElement
			local icon = Foundation.Icon
			local v13 = {
				name = props.icon,
				size = v5:map(function(p: number)
					return (math.round((1 - p) * v8))
				end),
				variant = 0,
				style = 0,
				tag = "position-center-center anchor-center-center content-emphasis"
			}
			local variant2

			if props.iconVariant then
				variant2 = props.iconVariant
			else
				variant2 = IconVariant.Regular
			end

			v13.variant = variant2
			local style = { Color3 = v3.contentForegroundStyle.Color3, Transparency = 0 }
			local transparency

			if props.disabled then
				transparency = v3.contentDisabledTransparency
			else
				transparency = v3.contentForegroundStyle.Transparency
			end

			style.Transparency = transparency
			v13.style = style
			iconImage = createElement3(icon, v13)
		else
			local createElement3 = React.createElement
			local image = Foundation.Image
			local v13 = {
				Image = props.icon,
				Size = v5:map(function(p: number)
					local v13 = math.round((1 - p) * v8)
					return UDim2.fromOffset(v13, v13)
				end),
				imageStyle = 0,
				tag = "position-center-center anchor-center-center content-emphasis"
			}

			local imageStyle = { Color3 = v3.contentForegroundStyle.Color3, Transparency = 0 }
			local transparency

			if props.disabled then
				transparency = v3.contentDisabledTransparency
			else
				transparency = v3.contentForegroundStyle.Transparency
			end

			imageStyle.Transparency = transparency
			v13.imageStyle = imageStyle
			iconImage = createElement3(image, v13)
		end

		local v13 = {
			Icon = createElement2(view2, v12, { IconImage = iconImage }),
			ActiveIcon = 0
		}
		local activeIcon

		if isActive or props.animate then
			local createElement3 = React.createElement
			local view3 = Foundation.View
			local v14 = {
				Size = UDim2.fromScale(1, 1),
				GroupTransparency = v5:map(function(p: number)
					return 1 - p
				end),
				backgroundStyle = 0,
				tag = 0
			}
			local backgroundStyle2

			if not props.disabled then
				backgroundStyle2 = v4:map(function(p)
					if p then
						return v3.hoverIconBackgroundStyle
					end

					return v3.activeIconBackgroundStyle
				end)
			end

			v14.backgroundStyle = backgroundStyle2

			v14.tag = FFlagAXMigrateBuilderIcons
				and {
					["radius-circle position-center-center anchor-center-center clip"] = true,
					["row align-x-center align-y-center"] = isBuilderIcon(v9)
				}
				or "radius-circle position-center-center anchor-center-center clip"
			local activeIconImage

			if FFlagAXMigrateBuilderIcons and isBuilderIcon(v9) then
				activeIconImage = React.createElement(Foundation.Icon, {
					name = v9,
					size = v5:map(function(p: number)
						return (math.round((1 - p) * v8))
					end),
					variant = variant,
					tag = "position-center-center anchor-center-center clip content-emphasis"
				})
			else
				activeIconImage = React.createElement(Foundation.Image, {
					Image = v9,
					Size = v5:map(function(p: number)
						local v15 = math.round(p * v10)
						return UDim2.fromOffset(v15, v15)
					end),
					tag = "position-center-center anchor-center-center clip content-emphasis"
				})
			end

			activeIcon = createElement3(view3, v14, { ActiveIconImage = activeIconImage })
		end

		v13.ActiveIcon = activeIcon
		return createElement(view, v11, v13)
	end
end

return React.forwardRef(IconItem)
