local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)

local module = require("@luauforge/bundled/gey")

local function RobloxSubscriptionOnboardingSheetHost()
	local state, setState = React.useState(false)

	React.useEffect(function()
		local v5 = module.getGeneration(false)
		return Signals.createEffect(function(p2)
			local generation = module.getGeneration(p2)

			if generation ~= v5 then
				v5 = generation
				setState(true)
			end
		end)
	end, {})

	local v5 = React.useCallback(function()
		setState(false)
	end, {})

	if not state then
		return nil
	end

	local module2 = require("@luauforge/bundled/icA")
	return React.createElement(module2, { onClose = v5 })
end

return RobloxSubscriptionOnboardingSheetHost
