local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local UpsellFlow = require(ParentParent.Enums.UpsellFlow)
local getUpsellFlow = require(ParentParent.NativeUpsell.getUpsellFlow)
local ExternalSettings = require(ParentParent.Services.ExternalSettings)
local PlatformInterface = require(ParentParent.Services.PlatformInterface)
local Thunk = require(ParentParent.Thunk)
local AppPage = require(ParentParentParent.RobloxAppEnums).AppPage
local TermsOfUse = require(ParentParent.Misc.Constants).TermsOfUse
local AppContext = require(ParentParent.Utils.AppContext)
local FFlagEnableUnifiedProductPurchaseFlow = require(ParentParentParent.SharedFlags).FFlagEnableUnifiedProductPurchaseFlow
local getAppFeaturePolicies = require(ParentParentParent.UniversalAppPolicy).getAppFeaturePolicies
local t1 = {
	ExternalSettings,
	PlatformInterface
}

local function openTermsOfUse(p1) -- line: 23
	-- upvalues: Thunk (copy), t1 (copy), ExternalSettings (copy), PlatformInterface (copy), getUpsellFlow (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), getAppFeaturePolicies (copy), AppContext (copy), AppPage (copy), TermsOfUse (copy), UpsellFlow (copy)
	return Thunk.new(script.Name, t1, function(_, p3) -- line: 24
		-- upvalues: ExternalSettings (copy), PlatformInterface (copy), getUpsellFlow (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), getAppFeaturePolicies (copy), AppContext (copy), p1 (copy), AppPage (copy), TermsOfUse (copy), UpsellFlow (copy)
		local v18 = p3[ExternalSettings]
		local v19 = p3[PlatformInterface]
		local v20 = getUpsellFlow(v18.getPlatform())

		if FFlagEnableUnifiedProductPurchaseFlow and getAppFeaturePolicies().getShouldUseDMCCALegalDisclosureInApp() then
			if AppContext.get() == AppContext.Enum.IN_APP then
				p1.navigate(AppPage.GenericWebPage, {
					detail = TermsOfUse.DMCCAUrl,
					extraProps = {
						title = ""
					}
				})

				return
			end

			v19.openTermsOfUseDMCCA()

			return
		end

		if v20 == UpsellFlow.Web then
			v19.openTermsOfUse()
		end
	end)
end

return openTermsOfUse
