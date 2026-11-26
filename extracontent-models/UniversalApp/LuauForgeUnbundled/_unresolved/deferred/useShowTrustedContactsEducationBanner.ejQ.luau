local module = require("@luauforge/deferred/eil")

local module2 = require("@luauforge/deferred/ejR")
local module3 = require("@luauforge/deferred/ejS")

local ampApiProvider = require("@luauforge/deferred/ejN").AmpApiProvider
local ampEnums = require("@luauforge/deferred/ejN").AmpEnums

local fStringCanAccessTrustedContactsAmpFeature = require("@luauforge/deferred/eiz").FStringCanAccessTrustedContactsAmpFeature
local fStringCanAccessTrustedContactsAmpNameSpace = require("@luauforge/deferred/eiz").FStringCanAccessTrustedContactsAmpNameSpace

local function isBannerHiddenInitState(): boolean
	local value = module2.getValue()
	return value < 0 or module3 <= value
end

local function useShowTrustedContactsEducationBanner()
	local state, setState = module.useState(isBannerHiddenInitState)
	local state2, setState2 = module.useState(false)

	module.useEffect(function()
		if ampApiProvider.upsellFeatureAccess(
			fStringCanAccessTrustedContactsAmpFeature,
			{},
			fStringCanAccessTrustedContactsAmpNameSpace
		).access == ampEnums.AccessResponseEnum.Granted then
			setState2(true)
		end
	end, {})

	return not state and state2, module.useCallback(function()
		setState(true)
		module2.dismissValue()
	end, { setState }), (module.useCallback(function()
		module2.incrementValue()
	end, {}))
end

return useShowTrustedContactsEducationBanner
