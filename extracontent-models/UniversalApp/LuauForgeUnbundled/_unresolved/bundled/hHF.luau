local module = require("@luauforge/bundled/hHG")
local module2 = require("@luauforge/bundled/hHr")
local module3 = require("@luauforge/bundled/hHu")
local module4 = require("@luauforge/bundled/hHw")

local module5 = require("@luauforge/bundled/hHH")

local iconButton = module2.IconButton
local view = module2.View
local useTokens = module2.Hooks.useTokens

local function BuyRobuxCloseButton(p2)
	local v5 = useTokens()
	local v6 = module4.useDeviceInsets()

	if
		module4.usePreferredInput() == module4.Input.Directional
		and not (module5() or p2.showWithDirectionalInput)
	then
		return nil
	end

	return module3.createElement(view, {
		ZIndex = 2,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromOffset(v6.left + v5.Padding.Large, v5.Padding.Medium + v5.Size.Size_800 / 2),
		tag = "auto-xy radius-circle bg-over-media-200"
	}, {
		CloseButton = module3.createElement(iconButton, {
			isCircular = true,
			size = module2.Enums.InputSize.Medium,
			icon = {
				name = module.Icon.XSmall,
				variant = module2.Enums.IconVariant.Regular
			},
			onActivated = p2.onActivated,
			testId = "--buy-robux-sdui-close-button"
		})
	})
end

return module3.memo(BuyRobuxCloseButton)
