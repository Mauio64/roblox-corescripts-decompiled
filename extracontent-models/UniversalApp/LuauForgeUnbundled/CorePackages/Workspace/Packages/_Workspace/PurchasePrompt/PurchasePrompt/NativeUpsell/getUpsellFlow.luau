local UpsellFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/UpsellFlow")
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/UniversalAppPolicy").getAppFeaturePolicies

local GetFFlagEnablePalisadesPaymentsPlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagEnablePalisadesPaymentsPlatform")
local FFlagEnablePioneerPaymentsPlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagEnablePioneerPaymentsPlatform")
local getIsPioneerBuild = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getIsPioneerBuild")

local function getUpsellFlow(p2)
	if getAppFeaturePolicies().getRobuxUpsellFlowMobile() then
		return UpsellFlow.Mobile
	end

	if p2 == Enum.Platform.Windows or p2 == Enum.Platform.OSX or p2 == Enum.Platform.Linux then
		if FFlagEnablePioneerPaymentsPlatform and getIsPioneerBuild() then
			return UpsellFlow.Mobile
		end

		return UpsellFlow.Web
	end

	if p2 == Enum.Platform.IOS or p2 == Enum.Platform.Android or p2 == Enum.Platform.UWP then
		return UpsellFlow.Mobile
	end

	if p2 == Enum.Platform.XBoxOne then
		return UpsellFlow.Xbox
	end

	if GetFFlagEnablePalisadesPaymentsPlatform() and (p2 == Enum.Platform.PS4 or p2 == Enum.Platform.PS5) then
		return UpsellFlow.Mobile
	end

	return UpsellFlow.None
end

return getUpsellFlow
