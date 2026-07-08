local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")
local AvatarExperienceControlBarParent = AvatarExperienceControlBar.Parent
local React = require(AvatarExperienceControlBarParent.React)
local Foundation = require(AvatarExperienceControlBarParent.Foundation)
local ReactOtter = require(AvatarExperienceControlBarParent.ReactOtter)
local Tooltip = require(AvatarExperienceControlBar.Components.Tooltip)

require(AvatarExperienceControlBar.ControlBarTypes)

local FFlagAXAddToolTipToIconItemMenu = require(AvatarExperienceControlBarParent.AvatarExperienceFlags).FFlagAXAddToolTipToIconItemMenu
local FFlagAXMigrateBuilderIcons = require(AvatarExperienceControlBarParent.AvatarExperienceFlags).FFlagAXMigrateBuilderIcons
local isBuilderIcon = Foundation.Utility.isBuilderIcon
local IconVariant = Foundation.Enums.IconVariant
local useSemanticTokens = require(AvatarExperienceControlBar.Hooks.useSemanticTokens)
local useHoverBinding = require(AvatarExperienceControlBar.Hooks.useHoverBinding)
local v13 = not FFlagAXMigrateBuilderIcons and "icons/navigation/close" or Foundation.Enums.IconName.X
local t1 = {
	dampingRatio = 1,
	frequency = 5
}

local function IconItem(t2: {[any]: any}, p1) -- line: 44
	-- upvalues: useSemanticTokens (copy), useHoverBinding (copy), ReactOtter (copy), FFlagAXMigrateBuilderIcons (copy), v13 (copy), IconVariant (copy), React (copy), t1 (copy), FFlagAXAddToolTipToIconItemMenu (copy), Foundation (copy), Tooltip (copy), isBuilderIcon (copy)
	local v18 = useSemanticTokens()
	local v19, v20 = useHoverBinding()
	local v21, v22 = ReactOtter.useAnimatedBinding(0)
	local v23 = t2.isActive or false
	local v24 = if not t2.size then v18.defaultIconContainerSize else t2.size
	local v25 = if not t2.iconSize then if not FFlagAXMigrateBuilderIcons then v18.defaultIconSize else v18.defaultLegacyIconSize else t2.iconSize
	local v26 = if not t2.activeIcon then v13 else t2.activeIcon
	local v27 = if not FFlagAXMigrateBuilderIcons then nil else if not t2.activeIconVariant then IconVariant.Regular else t2.activeIconVariant
	local v28 = if not t2.activeIconSize then if v26 ~= v13 then v25 else v18.closeIconSize else t2.activeIconSize

	React.useEffect(function() -- line: 64
		-- upvalues: t2 (copy), v22 (copy), ReactOtter (copy), v23 (copy), t1 (copy)
		if t2.animate then
			v22(ReactOtter.spring(not v23 and 0 or 1, t1))

			return
		end

		v22((ReactOtter.instant(not v23 and 0 or 1)))
	end, {
		v23,
		t2.animate
	})

	if FFlagAXAddToolTipToIconItemMenu then
		return React.createElement(Foundation.View, {
			tag = "row align-x-center align-y-center",
			Size = UDim2.new(0, v24, 0, v24),
			LayoutOrder = t2.LayoutOrder
		}, {
			TooltipIconItem = React.createElement(Tooltip, t2.toolTipConfig, React.createElement(Foundation.View, {
				tag = "radius-circle",
				Size = UDim2.new(0, v24, 0, v24),
				onStateChanged = v20,
				stateLayer = {
					affordance = Foundation.Enums.StateLayerAffordance.None
				},
				onActivated = t2.onActivated,
				disabled = t2.disabled,
				ref = p1,
				LayoutOrder = t2.LayoutOrder
			}, {
				Icon = React.createElement(Foundation.View, {
					Size = UDim2.fromScale(1, 1),
					Visible = not t2.isActive or (t2.animate and true or false),
					backgroundStyle = if not t2.disabled then v19:map(function(p2) -- line: 98
						-- upvalues: v18 (copy)
						return {
							Color3 = v18.hoverIconBackgroundStyle.Color3,
							Transparency = not p2 and 1 or v18.hoverIconBackgroundStyle.Transparency
						}
					end) else nil,
					tag = not FFlagAXMigrateBuilderIcons and "radius-circle position-center-center anchor-center-center clip" or {
						["radius-circle position-center-center anchor-center-center clip"] = true,
						["row align-x-center align-y-center"] = isBuilderIcon(t2.icon)
					}
				}, {
					IconImage = if not FFlagAXMigrateBuilderIcons or not isBuilderIcon(t2.icon) then React.createElement(Foundation.Image, {
						tag = "position-center-center anchor-center-center content-emphasis",
						Image = t2.icon,
						Size = v21:map(function(n1: number) -- line: 129
							-- upvalues: v25 (copy)
							local v32 = math.round((1 - n1) * v25)

							return UDim2.fromOffset(v32, v32)
						end),
						imageStyle = {
							Color3 = v18.contentForegroundStyle.Color3,
							Transparency = if not t2.disabled then v18.contentForegroundStyle.Transparency else v18.contentDisabledTransparency
						}
					}) else React.createElement(Foundation.Icon, {
						tag = "position-center-center anchor-center-center content-emphasis",
						name = t2.icon,
						size = v21:map(function(n2: number) -- line: 114
							-- upvalues: v25 (copy)
							return (math.round((1 - n2) * v25))
						end),
						variant = if not t2.iconVariant then IconVariant.Regular else t2.iconVariant,
						style = {
							Color3 = v18.contentForegroundStyle.Color3,
							Transparency = if not t2.disabled then v18.contentForegroundStyle.Transparency else v18.contentDisabledTransparency
						}
					})
				}),
				ActiveIcon = if not v23 and not t2.animate then nil else React.createElement(Foundation.View, {
					Size = UDim2.fromScale(1, 1),
					GroupTransparency = v21:map(function(n3: number) -- line: 145
						return 1 - n3
					end),
					backgroundStyle = if not t2.disabled then v19:map(function(p3) -- line: 150
						-- upvalues: v18 (copy)
						if p3 then
							return v18.hoverIconBackgroundStyle
						end

						return v18.activeIconBackgroundStyle
					end) else nil,
					tag = not FFlagAXMigrateBuilderIcons and "radius-circle position-center-center anchor-center-center clip" or {
						["radius-circle position-center-center anchor-center-center clip"] = true,
						["row align-x-center align-y-center"] = isBuilderIcon(v26)
					}
				}, {
					ActiveIconImage = if not FFlagAXMigrateBuilderIcons or not isBuilderIcon(v26) then React.createElement(Foundation.Image, {
						tag = "position-center-center anchor-center-center clip content-emphasis",
						Image = v26,
						Size = v21:map(function(n4: number) -- line: 181
							-- upvalues: v28 (copy)
							local v37 = math.round(n4 * v28)

							return UDim2.fromOffset(v37, v37)
						end)
					}) else React.createElement(Foundation.Icon, {
						tag = "size-full-full position-center-center anchor-center-center content-emphasis",
						name = v26,
						size = v21:map(function(n5: number) -- line: 166
							-- upvalues: v25 (copy)
							return (math.round(n5 * v25))
						end),
						variant = v27,
						style = {
							Color3 = v18.contentForegroundStyle.Color3,
							Transparency = if not t2.disabled then v18.contentForegroundStyle.Transparency else v18.contentDisabledTransparency
						}
					})
				})
			}))
		})
	end

	return React.createElement(Foundation.View, {
		tag = "radius-circle",
		Size = UDim2.new(0, v24, 0, v24),
		onStateChanged = v20,
		stateLayer = {
			affordance = Foundation.Enums.StateLayerAffordance.None
		},
		onActivated = t2.onActivated,
		disabled = t2.disabled,
		ref = p1,
		LayoutOrder = t2.LayoutOrder
	}, {
		Icon = React.createElement(Foundation.View, {
			Size = UDim2.fromScale(1, 1),
			Visible = not t2.isActive or (t2.animate and true or false),
			backgroundStyle = if not t2.disabled then v19:map(function(p4) -- line: 210
				-- upvalues: v18 (copy)
				return {
					Color3 = v18.hoverIconBackgroundStyle.Color3,
					Transparency = not p4 and 1 or v18.hoverIconBackgroundStyle.Transparency
				}
			end) else nil,
			tag = not FFlagAXMigrateBuilderIcons and "radius-circle position-center-center anchor-center-center clip" or {
				["radius-circle position-center-center anchor-center-center clip"] = true,
				["row align-x-center align-y-center"] = isBuilderIcon(t2.icon)
			}
		}, {
			IconImage = if not FFlagAXMigrateBuilderIcons or not isBuilderIcon(t2.icon) then React.createElement(Foundation.Image, {
				tag = "position-center-center anchor-center-center content-emphasis",
				Image = t2.icon,
				Size = v21:map(function(n6: number) -- line: 241
					-- upvalues: v25 (copy)
					local v41 = math.round((1 - n6) * v25)

					return UDim2.fromOffset(v41, v41)
				end),
				imageStyle = {
					Color3 = v18.contentForegroundStyle.Color3,
					Transparency = if not t2.disabled then v18.contentForegroundStyle.Transparency else v18.contentDisabledTransparency
				}
			}) else React.createElement(Foundation.Icon, {
				tag = "position-center-center anchor-center-center content-emphasis",
				name = t2.icon,
				size = v21:map(function(n7: number) -- line: 226
					-- upvalues: v25 (copy)
					return (math.round((1 - n7) * v25))
				end),
				variant = if not t2.iconVariant then IconVariant.Regular else t2.iconVariant,
				style = {
					Color3 = v18.contentForegroundStyle.Color3,
					Transparency = if not t2.disabled then v18.contentForegroundStyle.Transparency else v18.contentDisabledTransparency
				}
			})
		}),
		ActiveIcon = if not v23 and not t2.animate then nil else React.createElement(Foundation.View, {
			Size = UDim2.fromScale(1, 1),
			GroupTransparency = v21:map(function(n8: number) -- line: 257
				return 1 - n8
			end),
			backgroundStyle = if not t2.disabled then v19:map(function(p5) -- line: 262
				-- upvalues: v18 (copy)
				if p5 then
					return v18.hoverIconBackgroundStyle
				end

				return v18.activeIconBackgroundStyle
			end) else nil,
			tag = not FFlagAXMigrateBuilderIcons and "radius-circle position-center-center anchor-center-center clip" or {
				["radius-circle position-center-center anchor-center-center clip"] = true,
				["row align-x-center align-y-center"] = isBuilderIcon(v26)
			}
		}, {
			ActiveIconImage = if not FFlagAXMigrateBuilderIcons or not isBuilderIcon(v26) then React.createElement(Foundation.Image, {
				tag = "position-center-center anchor-center-center clip content-emphasis",
				Image = v26,
				Size = v21:map(function(n9: number) -- line: 287
					-- upvalues: v28 (copy)
					local v46 = math.round(n9 * v28)

					return UDim2.fromOffset(v46, v46)
				end)
			}) else React.createElement(Foundation.Icon, {
				tag = "position-center-center anchor-center-center clip content-emphasis",
				name = v26,
				size = v21:map(function(n10: number) -- line: 278
					-- upvalues: v25 (copy)
					return (math.round((1 - n10) * v25))
				end),
				variant = v27
			})
		})
	})
end

return React.forwardRef(IconItem)
