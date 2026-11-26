local module = require("@luauforge/bundled/fJN")
local module2 = require("@luauforge/bundled/fJy")
local module3 = require("@luauforge/bundled/fJO")
local useSignalState = require("@luauforge/bundled/fJP").useSignalState

local module4 = require("@luauforge/bundled/fJI")
local module5 = require("@luauforge/bundled/fJQ")
local module6 = require("@luauforge/bundled/fJR")
local module7 = require("@luauforge/bundled/fJK")

local function useRefetchCampaignOnSubscriptionChange(p2)
	local v5 = module3.RobloxSubscriptionSignals.get()
	local v6 = useSignalState(v5.getHasRobloxSubscription)
	local ref = module2.useRef(nil)

	module2.useEffect(function()
		local current = ref.current
		ref.current = v6

		if current ~= nil and current ~= v6 then
			module4.markAllStale()

			module.retryWithDelay(p2, module5, module6 / 1000):catch(function() end)
		end
	end, { v6, p2 })

	if module7 then
		local v7 = useSignalState(v5.getExistingSubscriptionUpgradedThisSession)

		module2.useEffect(function()
			local v8 = module4.swapLastSeenExistingSubscriptionUpgraded(v7)

			if v7 and not v8 then
				module4.markAllStale()
				module.retryWithDelay(p2, module5, module6 / 1000):catch(function() end)
			end
		end, { v7, p2 })
	end
end

return useRefetchCampaignOnSubscriptionChange
