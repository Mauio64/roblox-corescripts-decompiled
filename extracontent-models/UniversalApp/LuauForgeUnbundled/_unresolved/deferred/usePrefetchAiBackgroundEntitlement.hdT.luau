local module = require("@luauforge/deferred/hcS")
local module2 = require("@luauforge/deferred/hdJ")
local module3 = require("@luauforge/deferred/hdK")

local module4 = require("@luauforge/deferred/hdO")

local function usePrefetchAiBackgroundEntitlement()
	local v5 = module2.RobloxSubscriptionSignals.get()
	local v6 = module3.useSignalState(v5.getHasRobloxSubscription)

	module.useEffect(function()
		module4(false).refresh(v6)
	end, { v6 })
end

return usePrefetchAiBackgroundEntitlement
