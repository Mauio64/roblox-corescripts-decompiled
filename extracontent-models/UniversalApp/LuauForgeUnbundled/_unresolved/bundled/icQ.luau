local module = require("@luauforge/bundled/icR")
local module2 = require("@luauforge/bundled/icS")

require("@luauforge/bundled/icD")

local v5 = nil

local function createRobloxSubscriptionOnboardingStore()
	local sessionScopedSignal, v6 = module2.createSessionScopedSignal(nil)

	return { getOriginalLook = sessionScopedSignal, setOriginalLook = v6 }
end

return {
	get = function()
		if v5 == nil then
			v5 = module.createComputed(createRobloxSubscriptionOnboardingStore)(false)
		end

		return assert(v5, "RobloxSubscriptionOnboardingStore not initialized")
	end,
	cleanup = function()
		v5 = nil
	end
}
