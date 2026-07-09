local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local UpsellFlow = require(PurchasePrompt.Enums.UpsellFlow)
local getAppFeaturePolicies = require(PurchasePromptParent.UniversalAppPolicy).getAppFeaturePolicies
local GetFFlagEnablePalisadesPaymentsPlatform = require(PurchasePrompt.Flags.GetFFlagEnablePalisadesPaymentsPlatform)

local function getUpsellFlow(p1) -- line: 10
	-- upvalues: getAppFeaturePolicies (copy), UpsellFlow (copy), GetFFlagEnablePalisadesPaymentsPlatform (copy)
	if getAppFeaturePolicies().getRobuxUpsellFlowMobile() then
		return UpsellFlow.Mobile
	end

	if p1 == Enum.Platform.Windows or p1 == Enum.Platform.OSX or p1 == Enum.Platform.Linux then
		return UpsellFlow.Web
	end

	if p1 == Enum.Platform.IOS or p1 == Enum.Platform.Android or p1 == Enum.Platform.UWP then
		return UpsellFlow.Mobile
	end

	if p1 == Enum.Platform.XBoxOne then
		return UpsellFlow.Xbox
	end

	if GetFFlagEnablePalisadesPaymentsPlatform() and (p1 == Enum.Platform.PS4 or p1 == Enum.Platform.PS5) then
		return UpsellFlow.Mobile
	end

	return UpsellFlow.None
end

return getUpsellFlow
