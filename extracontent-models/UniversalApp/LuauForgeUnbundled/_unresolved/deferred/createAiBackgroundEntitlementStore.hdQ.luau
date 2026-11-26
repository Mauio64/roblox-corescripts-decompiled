local module = require("@luauforge/deferred/hdR")
require("@luauforge/deferred/hdP")
local createSessionScopedSignal = require("@luauforge/deferred/hdS").createSessionScopedSignal

local accessResponseEnum = module.AmpEnums.AccessResponseEnum

local function createAiBackgroundEntitlementStore()
	local sessionScopedSignal, v5 = createSessionScopedSignal(false)

	local sessionScopedSignal2, v6 = createSessionScopedSignal(nil)
	local count = 0

	local function refresh(p2)
		if sessionScopedSignal2(false) == p2 then
			return
		end

		v6(p2)
		count += 1

		if not p2 then
			v5(false)
			return
		end

		local v7 = count

		task.spawn(function()
			local upsellFeatureAccess = module.AmpApiProvider.upsellFeatureAccess(
				"IsAiBackgroundEnabled",
				{},
				"subscriptions/PlusSubscription"
			)

			if v7 ~= count or sessionScopedSignal2(false) ~= true then
				return
			end

			if upsellFeatureAccess.access == accessResponseEnum.Error then
				v6(nil)
			end

			v5(upsellFeatureAccess.access == accessResponseEnum.Granted)
		end)
	end

	local function reset()
		count += 1
		v6(nil)
		v5(false)
	end

	return { getIsEntitled = sessionScopedSignal, refresh = refresh, reset = reset }
end

return createAiBackgroundEntitlementStore
