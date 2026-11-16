local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")

local parent = AvatarExperienceControlBar.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)

local useSemanticTokens = require(AvatarExperienceControlBar.Hooks.useSemanticTokens)
local useLocalization = Localization.Hooks.useLocalization
local useHoverBinding = require(AvatarExperienceControlBar.Hooks.useHoverBinding)

local ColorItem = require(AvatarExperienceControlBar.Components.Items.ColorItem)

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
	return React.createElement(Foundation.View, {
		onActivated = props.onActivated,
		isDisabled = props.disabled,
		tag = "auto-xy size-full-0 clip row gap-xsmall items-center",
		ref = ref,
		onStateChanged = onStateChanged,
		backgroundStyle = v2:map(function(p)
			return {
				Color3 = v.hoverIconBackgroundStyle.Color3,
				Transparency = not p and 1 or v.hoverIconBackgroundStyle.Transparency
			}
		end),
		padding = {
			left = UDim.new(0, v.textButtonPaddingLeft),
			right = UDim.new(0, v.textButtonPaddingRight),
			top = UDim.new(0, v.textButtonPaddingY),
			bottom = UDim.new(0, v.textButtonPaddingY)
		},
		cornerRadius = UDim.new(0, v3),
		Visible = props.Visible,
		LayoutOrder = props.LayoutOrder
	}, {
		Color = React.createElement(ColorItem, {
			colors = props.colors,
			size = props.size,
			colorSize = props.colorSize,
			disabled = true,
			onActivated = props.onActivated,
			Selectable = false
		}),
		Text = React.createElement(Foundation.Text, {
			Text = text,
			tag = "auto-xy text-title-medium content-emphasis"
		})
	})
end))
