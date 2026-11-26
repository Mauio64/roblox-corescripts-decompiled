local module = require("@luauforge/deferred/eil")

local module2 = require("@luauforge/deferred/emy")

local ampApiProvider = require("@luauforge/deferred/ejN").AmpApiProvider
local ampEnums = require("@luauforge/deferred/ejN").AmpEnums

local module3 = require("@luauforge/deferred/eiz")
local fStringEligibleToAgeVerifyAmpFeature = module3.FStringEligibleToAgeVerifyAmpFeature
local fStringAgeCheckAmpNameSpace = module3.FStringAgeCheckAmpNameSpace

local function useShowFAEEligibleBanner()
	local state, setState = module.useState(module2.isDismissed)
	local state2, setState2 = module.useState(false)

	module.useEffect(function()
		if ampApiProvider.upsellFeatureAccess(
			fStringEligibleToAgeVerifyAmpFeature,
			{},
			fStringAgeCheckAmpNameSpace
		).access == ampEnums.AccessResponseEnum.Granted then
			setState2(true)
		end
	end, {})

	return not state and state2, (module.useCallback(function()
		setState(true)
		module2.markDismissed()
	end, { setState }))
end

return useShowFAEEligibleBanner
