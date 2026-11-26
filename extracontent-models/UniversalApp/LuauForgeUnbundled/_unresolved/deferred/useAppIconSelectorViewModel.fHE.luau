local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local module = require("@luauforge/bundled/fHh")

local module2 = require("@luauforge/bundled/fHC")
local module3 = require("@luauforge/bundled/fHF")
require("@luauforge/deferred/fHB")

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
	local v8 = useSignalState(module.RobloxSubscriptionSignals.get().getHasRobloxSubscription) == true

	local ref = React.useRef(nil)
	React.useEffect(function()
		local current = ref.current

		if v8 and current ~= nil then
			ref.current = nil
			v5.setAppIcon(current)
		end
	end, { v8, v5 })

	return {
		options = React.useMemo(function()
			local result = {}

			for k, v9 in module2.ORDERED do
				local v10 = module2.REQUIRES_PLUS[v9] == true
				result[k] = {
					key = v9,
					label = p2[v9] or v9,
					image = module2.PREVIEW_IMAGE[v9],
					previewColor = module2.PREVIEW_COLOR[v9],
					isSelected = v9 == v6,
					isLocked = not module2.canUseAppIcon(v9, v8),
					showPlusIcon = v10
				}
			end

			return result
		end, { p2, v6, v8 }),
		onSelect = React.useCallback(function(current)
			if current == v5.getAppIcon(false) then
				return
			end

			if module2.canUseAppIcon(current, v8) then
				v5.setAppIcon(current)
				return
			end

			ref.current = current
			module.initiateRobloxSubscriptionPurchase(
				nil,
				nil,
				nil,
				module.SurfaceName.SettingsAppIconUpsell,
				module.SurfaceContext.InApp
			)
		end, { v5, v8 })
	}
end

return useAppIconSelectorViewModel
