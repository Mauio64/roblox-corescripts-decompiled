local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local UpsellFlow = require(PurchasePrompt.Enums.UpsellFlow)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies

local GetFFlagEnablePalisadesPaymentsPlatform = require(PurchasePrompt.Flags.GetFFlagEnablePalisadesPaymentsPlatform)
local FFlagEnablePioneerPaymentsPlatform = require(PurchasePrompt.Flags.FFlagEnablePioneerPaymentsPlatform)
local getIsPioneerBuild = require(PurchasePrompt.Utils.getIsPioneerBuild)

local function getUpsellFlow(p)
	if getAppFeaturePolicies().getRobuxUpsellFlowMobile() then
		return UpsellFlow.Mobile
	end

	if p == Enum.Platform.Windows or p == Enum.Platform.OSX or p == Enum.Platform.Linux then
		if FFlagEnablePioneerPaymentsPlatform and getIsPioneerBuild() then
			return UpsellFlow.Mobile
		end

		return UpsellFlow.Web
	end

	if p == Enum.Platform.IOS or p == Enum.Platform.Android or p == Enum.Platform.UWP then
		return UpsellFlow.Mobile
	end

	if p == Enum.Platform.XBoxOne then
		return UpsellFlow.Xbox
	end

	if GetFFlagEnablePalisadesPaymentsPlatform() and (p == Enum.Platform.PS4 or p == Enum.Platform.PS5) then
		return UpsellFlow.Mobile
	end

	return UpsellFlow.None
end

return getUpsellFlow
