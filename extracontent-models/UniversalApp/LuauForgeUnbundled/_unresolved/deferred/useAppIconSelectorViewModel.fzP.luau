local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local module = require("@luauforge/bundled/fzr")

local module2 = require("@luauforge/bundled/fzM")
local module3 = require("@luauforge/bundled/fzQ")
local module4 = require("@luauforge/bundled/fzq")
require("@luauforge/deferred/fzL")

local function openRobloxPlusUpsell()
	module.initiateRobloxSubscriptionPurchase(
		nil,
		nil,
		nil,
		module.SurfaceName.SettingsAppIconUpsell,
		module.SurfaceContext.InApp
	)
end

local function useAppIconSelectorViewModel(p2)
	local v5 = module3(false)
	local v6 = useSignalState(v5.getAppIcon)
	local v7 = module4()
	local hasRobloxPlusSubscription = v7.hasRobloxPlusSubscription
	local isRobloxPlusUpsellEligible = v7.isRobloxPlusUpsellEligible

	local ref = React.useRef(nil)
	React.useEffect(function()
		local current = ref.current

		if hasRobloxPlusSubscription and current ~= nil then
			ref.current = nil
			v5.setAppIcon(current)
		end
	end, { hasRobloxPlusSubscription, v5 })

	return {
		options = React.useMemo(function()
			local result = {}

			for k, v8 in module2.ORDERED do
				local v9 = module2.REQUIRES_PLUS[v8] == true
				result[k] = {
					key = v8,
					label = p2[v8] or v8,
					image = module2.PREVIEW_IMAGE[v8],
					previewColor = module2.PREVIEW_COLOR[v8],
					isSelected = v8 == v6,
					isLocked = not module2.canUseAppIcon(v8, hasRobloxPlusSubscription),
					showPlusIcon = v9
				}
			end

			return result
		end, { p2, v6, hasRobloxPlusSubscription }),
		onSelect = React.useCallback(function(current)
			if current == v5.getAppIcon(false) then
				return
			end

			if module2.canUseAppIcon(current, hasRobloxPlusSubscription) then
				v5.setAppIcon(current)
			elseif isRobloxPlusUpsellEligible then
				ref.current = current
				module.initiateRobloxSubscriptionPurchase(
					nil,
					nil,
					nil,
					module.SurfaceName.SettingsAppIconUpsell,
					module.SurfaceContext.InApp
				)
			end
		end, { v5, hasRobloxPlusSubscription, isRobloxPlusUpsellEligible })
	}
end

return useAppIconSelectorViewModel
