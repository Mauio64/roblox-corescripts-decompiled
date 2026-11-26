local CorePackages = game:GetService("CorePackages")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local module = require("@luauforge/bundled/fHh")

local function useHeroUnitHasRobloxSubscription()
	return (useSignalState(module.RobloxSubscriptionSignals.get().getHasRobloxSubscription))
end

return useHeroUnitHasRobloxSubscription
