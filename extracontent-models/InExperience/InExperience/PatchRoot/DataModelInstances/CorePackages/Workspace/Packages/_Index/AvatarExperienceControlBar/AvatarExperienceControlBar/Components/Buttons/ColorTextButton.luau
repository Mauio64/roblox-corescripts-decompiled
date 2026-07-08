local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")
local AvatarExperienceControlBarParent = AvatarExperienceControlBar.Parent
local React = require(AvatarExperienceControlBarParent.React)
local Foundation = require(AvatarExperienceControlBarParent.Foundation)
local Localization = require(AvatarExperienceControlBarParent.Localization)
local useSemanticTokens = require(AvatarExperienceControlBar.Hooks.useSemanticTokens)
local useLocalization = Localization.Hooks.useLocalization
local useHoverBinding = require(AvatarExperienceControlBar.Hooks.useHoverBinding)
local ColorItem = require(AvatarExperienceControlBar.Components.Items.ColorItem)

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 27
	-- upvalues: useSemanticTokens (copy), useHoverBinding (copy), useLocalization (copy), React (copy), Foundation (copy), ColorItem (copy)
	local v12 = useSemanticTokens()
	local v13, v14 = useHoverBinding()
	local v15 = if not t1.radius then v12.defaultIconTextButtonRadius else t1.radius
	local v16 = useLocalization({
		text = t1.localizedTextKey
	})
	local v17 = if not v16.text then t1.text else v16.text

	return React.createElement(Foundation.View, {
		tag = "auto-xy size-full-0 clip row gap-xsmall items-center",
		onActivated = t1.onActivated,
		isDisabled = t1.disabled,
		ref = p1,
		onStateChanged = v14,
		backgroundStyle = v13:map(function(p2) -- line: 44
			-- upvalues: v12 (copy)
			return {
				Color3 = v12.hoverIconBackgroundStyle.Color3,
				Transparency = not p2 and 1 or v12.hoverIconBackgroundStyle.Transparency
			}
		end),
		padding = {
			left = UDim.new(0, v12.textButtonPaddingLeft),
			right = UDim.new(0, v12.textButtonPaddingRight),
			top = UDim.new(0, v12.textButtonPaddingY),
			bottom = UDim.new(0, v12.textButtonPaddingY)
		},
		cornerRadius = UDim.new(0, v15),
		Visible = t1.Visible,
		LayoutOrder = t1.LayoutOrder
	}, {
		Color = React.createElement(ColorItem, {
			disabled = true,
			Selectable = false,
			colors = t1.colors,
			size = t1.size,
			colorSize = t1.colorSize,
			onActivated = t1.onActivated
		}),
		Text = React.createElement(Foundation.Text, {
			tag = "auto-xy text-title-medium content-emphasis",
			Text = v17
		})
	})
end))
