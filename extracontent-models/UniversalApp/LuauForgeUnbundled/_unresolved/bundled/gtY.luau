local module = require("@luauforge/bundled/gtZ")

require("@luauforge/bundled/gua")
local module2 = require("@luauforge/bundled/gub")

local v5 = nil

local function createPlusReferralStore()
	local signal, v6 = module.createSignal(module2.Idle)

	local signal2, v7 = module.createSignal(nil)

	local signal3, v8 = module.createSignal(nil)

	local signal4, v9 = module.createSignal(nil)

	local function reset()
		v6(module2.Idle)
		v7(nil)
		v8(nil)
		v9(nil)
	end

	return {
		getScreenLoadStatus = signal,
		getShareUrl = signal2,
		getBenefits = signal3,
		getAnalyticsMetadata = signal4,
		setScreenLoadStatus = v6,
		setShareUrl = v7,
		setBenefits = v8,
		setAnalyticsMetadata = v9,
		reset = reset
	}
end

return {
	get = function()
		if v5 == nil then
			v5 = module.createComputed(createPlusReferralStore)(false)
		end

		return assert(v5, "PlusReferralStore not initialized")
	end,
	cleanup = function()
		v5 = nil
	end
}
