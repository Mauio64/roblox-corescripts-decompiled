local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")
local AvatarExperienceControlBarParent = AvatarExperienceControlBar.Parent
local React = require(AvatarExperienceControlBarParent.React)
local Foundation = require(AvatarExperienceControlBarParent.Foundation)
local Localization = require(AvatarExperienceControlBarParent.Localization)
local useSemanticTokens = require(AvatarExperienceControlBar.Hooks.useSemanticTokens)
local useLocalization = Localization.Hooks.useLocalization
local useHoverBinding = require(AvatarExperienceControlBar.Hooks.useHoverBinding)
local isBuilderIcon = Foundation.Utility.isBuilderIcon
local FFlagAXMigrateBuilderIcons = require(AvatarExperienceControlBarParent.AvatarExperienceFlags).FFlagAXMigrateBuilderIcons
local FFlagAXResetAvatarButton = require(AvatarExperienceControlBarParent.AvatarExperienceFlags).FFlagAXResetAvatarButton

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 29
	-- upvalues: useSemanticTokens (copy), useHoverBinding (copy), useLocalization (copy), FFlagAXMigrateBuilderIcons (copy), isBuilderIcon (copy), React (copy), Foundation (copy), FFlagAXResetAvatarButton (copy)
	local v14 = useSemanticTokens()
	local v15, v16 = useHoverBinding()
	local v17 = if not t1.radius then v14.defaultIconTextButtonRadius else t1.radius
	local v18 = useLocalization({
		text = t1.localizedTextKey
	})
	local v19 = if not v18.text then t1.text else v18.text
	local v20 = if not t1.iconSize then v14.defaultIconSize else t1.iconSize
	local v21 = FFlagAXMigrateBuilderIcons and isBuilderIcon(t1.icon)

	return React.createElement(Foundation.View, {
		tag = "auto-xy size-full-0 clip row gap-xsmall items-center",
		onActivated = t1.onActivated,
		isDisabled = t1.disabled,
		ref = p1,
		onStateChanged = v16,
		GroupTransparency = if not FFlagAXResetAvatarButton then nil else if not t1.disabled then v14.contentForegroundStyle.Transparency else v14.contentDisabledTransparency,
		backgroundStyle = v15:map(function(p2) -- line: 55
			-- upvalues: v14 (copy)
			return {
				Color3 = v14.hoverIconBackgroundStyle.Color3,
				Transparency = not p2 and 1 or v14.hoverIconBackgroundStyle.Transparency
			}
		end),
		cornerRadius = UDim.new(0, v17),
		padding = {
			left = UDim.new(0, v14.textButtonPaddingLeft),
			right = UDim.new(0, v14.textButtonPaddingRight),
			top = UDim.new(0, v14.textButtonPaddingY),
			bottom = UDim.new(0, v14.textButtonPaddingY)
		},
		Visible = t1.Visible,
		LayoutOrder = t1.LayoutOrder
	}, {
		Icon = React.createElement(Foundation.View, {
			Size = UDim2.new(0, v14.iconTextButtonIconContainerSize, 0, v14.iconTextButtonIconContainerSize),
			tag = not FFlagAXMigrateBuilderIcons and "radius-circle" or {
				["radius-circle"] = true,
				["row align-x-center align-y-center"] = v21
			}
		}, {
			IconImage = if not v21 then React.createElement(Foundation.Image, {
				tag = "position-center-center anchor-center-center",
				Image = t1.icon,
				Size = UDim2.new(0, v20, 0, v20),
				imageStyle = v14.contentForegroundStyle
			}) else React.createElement(Foundation.Icon, {
				tag = "position-center-center anchor-center-center",
				name = t1.icon,
				size = v20,
				style = v14.contentForegroundStyle
			})
		}),
		Text = React.createElement(Foundation.Text, {
			tag = "auto-xy text-title-medium content-emphasis",
			Text = v19
		})
	})
end))
