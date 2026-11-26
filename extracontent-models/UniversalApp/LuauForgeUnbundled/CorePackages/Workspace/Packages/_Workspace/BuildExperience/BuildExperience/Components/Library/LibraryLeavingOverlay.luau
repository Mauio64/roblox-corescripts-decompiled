local module = require("@luauforge/bundled/hHr")
local module2 = require("@luauforge/bundled/hHu")

local function noop() end

local function PurchaseSpinnerView(p2)
	local v5 = module.Hooks.useTokens()

	if p2.isVisible then
		return module2.createElement(module.View, {
			ZIndex = p2.ZIndex,
			backgroundStyle = v5.Color.None,
			onActivated = noop,
			selection = { Selectable = false },
			stateLayer = { affordance = module.Enums.StateLayerAffordance.None },
			tag = "row align-x-center align-y-center size-full",
			testId = "BuyRobuxPurchaseSpinner"
		}, {
			Bezel = module2.createElement(
				module.View,
				{
					backgroundStyle = v5.DarkMode.Common.Backdrop,
					tag = "auto-xy padding-xlarge radius-medium",
					testId = "BuyRobuxPurchaseSpinner.Bezel"
				},
				{
					Spinner = module2.createElement(module.Loading, {
						size = module.Enums.IconSize.Large
					})
				}
			)
		})
	end

	return nil
end

return PurchaseSpinnerView
