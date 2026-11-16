local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/Localization")

local useSemanticTokens = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Hooks/useSemanticTokens")
local useLocalization = Localization.Hooks.useLocalization
local useHoverBinding = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Hooks/useHoverBinding")

local ColorItem = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Components/Items/ColorItem")

return (React.forwardRef(function(props, p2)
	local v5 = useSemanticTokens()
	local v6, v7 = useHoverBinding()

	local v8 = if props.radius then props.radius else v5.defaultIconTextButtonRadius

	local v9 = useLocalization({ text = props.localizedTextKey })

	local v10 = if v9.text then v9.text else props.text
	return React.createElement(Foundation.View, {
		onActivated = props.onActivated,
		isDisabled = props.disabled,
		tag = "auto-xy size-full-0 clip row gap-xsmall items-center",
		ref = p2,
		onStateChanged = v7,
		backgroundStyle = v6:map(function(p3)
			return {
				Color3 = v5.hoverIconBackgroundStyle.Color3,
				Transparency = not p3 and 1 or v5.hoverIconBackgroundStyle.Transparency
			}
		end),
		padding = {
			left = UDim.new(0, v5.textButtonPaddingLeft),
			right = UDim.new(0, v5.textButtonPaddingRight),
			top = UDim.new(0, v5.textButtonPaddingY),
			bottom = UDim.new(0, v5.textButtonPaddingY)
		},
		cornerRadius = UDim.new(0, v8),
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
			Text = v10,
			tag = "auto-xy text-title-medium content-emphasis"
		})
	})
end))
