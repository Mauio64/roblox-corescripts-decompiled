local PaymentPlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PaymentPlatform")
local GetFFlagEnablePalisadesPaymentsPlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagEnablePalisadesPaymentsPlatform")
local FFlagEnablePioneerPaymentsPlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagEnablePioneerPaymentsPlatform")
local getIsPioneerBuild = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getIsPioneerBuild")

local fFlagEnableMicrosoftStorePaymentsPlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableMicrosoftStorePaymentsPlatform
local fFlagEnableMilkyWayPaymentsPlatformV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableMilkyWayPaymentsPlatformV2

local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/UniversalAppPolicy").getAppFeaturePolicies

return function(p2, p3, p4, p5)
	if p2 == Enum.Platform.XBoxOne then
		return PaymentPlatform.Xbox
	end

	if p2 == Enum.Platform.IOS then
		if p3 then
			return PaymentPlatform.Midas
		end

		return PaymentPlatform.Apple
	elseif p2 == Enum.Platform.Windows or p2 == Enum.Platform.OSX or p2 == Enum.Platform.Linux then
		if FFlagEnablePioneerPaymentsPlatform and getIsPioneerBuild() then
			return PaymentPlatform.Pioneer
		end

		if
			fFlagEnableMicrosoftStorePaymentsPlatform
			and getAppFeaturePolicies().getUsePaymentPlatformMicrosoftStore()
		then
			return PaymentPlatform.Microsoft
		end

		return PaymentPlatform.Web
	elseif p2 == Enum.Platform.Android then
		if p3 then
			return PaymentPlatform.Midas
		end

		if p4 then
			return PaymentPlatform.Amazon
		end

		if p5 then
			return PaymentPlatform.Maquettes
		end

		if
			fFlagEnableMilkyWayPaymentsPlatformV2
			and getAppFeaturePolicies().getUsePaymentPlatformMilkyWayStore()
		then
			return PaymentPlatform.MilkyWay
		end

		return PaymentPlatform.Google
	else
		if p2 == Enum.Platform.UWP then
			return PaymentPlatform.UWP
		end

		if GetFFlagEnablePalisadesPaymentsPlatform() and (p2 == Enum.Platform.PS4 or p2 == Enum.Platform.PS5) then
			return PaymentPlatform.Palisades
		end

		return PaymentPlatform.None
	end
end
