local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local UserInputService = game:GetService("UserInputService")
local UpsellFlow = require(ParentParent.Enums.UpsellFlow)
local getUpsellFlow = require(ParentParent.NativeUpsell.getUpsellFlow)
local getAppFeaturePolicies = require(ParentParentParent.UniversalAppPolicy).getAppFeaturePolicies
local FFlagEnableUnifiedProductPurchaseFlow = require(ParentParentParent.SharedFlags).FFlagEnableUnifiedProductPurchaseFlow

return function() -- line: 12
	-- upvalues: UserInputService (copy), getUpsellFlow (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), getAppFeaturePolicies (copy), UpsellFlow (copy)
	local Platform = UserInputService:GetPlatform()
	local v9 = getUpsellFlow(Platform)

	if FFlagEnableUnifiedProductPurchaseFlow and getAppFeaturePolicies().getShouldUseDMCCALegalDisclosureInApp() then
		return true
	end

	return v9 == UpsellFlow.Web
end
