local module = require("@luauforge/bundled/hwA")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/React")
local module4 = require("@luauforge/bundled/hwq")

local getEnableChatInputBarConfigurationAutocompleteEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChat/ExpChat/Flags/getEnableChatInputBarConfigurationAutocompleteEnabled")

local iconButton = Foundation.IconButton
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function BuyRobuxCloseButton(p2)
	local v5 = useTokens()
	local v6 = module4.useDeviceInsets()

	if
		module4.usePreferredInput() == module4.Input.Directional
		and not (getEnableChatInputBarConfigurationAutocompleteEnabled() or p2.showWithDirectionalInput)
	then
		return nil
	end

	return React.createElement(view, {
		ZIndex = 2,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromOffset(v6.left + v5.Padding.Large, v5.Padding.Medium + v5.Size.Size_800 / 2),
		tag = "auto-xy radius-circle bg-over-media-200"
	}, {
		CloseButton = React.createElement(iconButton, {
			isCircular = true,
			size = Foundation.Enums.InputSize.Medium,
			icon = {
				name = module.Icon.XSmall,
				variant = Foundation.Enums.IconVariant.Regular
			},
			onActivated = p2.onActivated,
			testId = "--buy-robux-sdui-close-button"
		})
	})
end

return React.memo(BuyRobuxCloseButton)
