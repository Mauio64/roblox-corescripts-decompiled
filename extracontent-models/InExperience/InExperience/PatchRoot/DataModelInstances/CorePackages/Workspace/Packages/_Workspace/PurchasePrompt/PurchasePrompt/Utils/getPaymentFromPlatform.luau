local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local PaymentPlatform = require(PurchasePrompt.Enums.PaymentPlatform)
local GetFFlagEnablePalisadesPaymentsPlatform = require(PurchasePrompt.Flags.GetFFlagEnablePalisadesPaymentsPlatform)
local FFlagEnableMicrosoftStorePaymentsPlatform = require(PurchasePromptParent.SharedFlags).FFlagEnableMicrosoftStorePaymentsPlatform
local FFlagEnableMilkyWayPaymentsPlatformV2 = require(PurchasePromptParent.SharedFlags).FFlagEnableMilkyWayPaymentsPlatformV2
local getAppFeaturePolicies = require(PurchasePromptParent.UniversalAppPolicy).getAppFeaturePolicies

return function(p1, p2, p3, p4) -- line: 17
	-- upvalues: PaymentPlatform (copy), FFlagEnableMicrosoftStorePaymentsPlatform (copy), getAppFeaturePolicies (copy), FFlagEnableMilkyWayPaymentsPlatformV2 (copy), GetFFlagEnablePalisadesPaymentsPlatform (copy)
	if p1 == Enum.Platform.XBoxOne then
		return PaymentPlatform.Xbox
	end

	if p1 == Enum.Platform.IOS then
		if p2 then
			return PaymentPlatform.Midas
		end

		return PaymentPlatform.Apple
	end

	if p1 == Enum.Platform.Windows or p1 == Enum.Platform.OSX or p1 == Enum.Platform.Linux then
		if FFlagEnableMicrosoftStorePaymentsPlatform and getAppFeaturePolicies().getUsePaymentPlatformMicrosoftStore() then
			return PaymentPlatform.Microsoft
		end

		return PaymentPlatform.Web
	end

	if p1 == Enum.Platform.Android then
		if p2 then
			return PaymentPlatform.Midas
		end

		if p3 then
			return PaymentPlatform.Amazon
		end

		if p4 then
			return PaymentPlatform.Maquettes
		end

		if FFlagEnableMilkyWayPaymentsPlatformV2 and getAppFeaturePolicies().getUsePaymentPlatformMilkyWayStore() then
			return PaymentPlatform.MilkyWay
		end

		return PaymentPlatform.Google
	end

	if p1 == Enum.Platform.UWP then
		return PaymentPlatform.UWP
	end

	if GetFFlagEnablePalisadesPaymentsPlatform() and (p1 == Enum.Platform.PS4 or p1 == Enum.Platform.PS5) then
		return PaymentPlatform.Palisades
	end

	return PaymentPlatform.None
end
