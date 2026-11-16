local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local PaymentPlatform = require(PurchasePrompt.Enums.PaymentPlatform)
local GetFFlagEnablePalisadesPaymentsPlatform = require(PurchasePrompt.Flags.GetFFlagEnablePalisadesPaymentsPlatform)
local FFlagEnablePioneerPaymentsPlatform = require(PurchasePrompt.Flags.FFlagEnablePioneerPaymentsPlatform)
local getIsPioneerBuild = require(PurchasePrompt.Utils.getIsPioneerBuild)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableMicrosoftStorePaymentsPlatform = SharedFlags.FFlagEnableMicrosoftStorePaymentsPlatform
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableMilkyWayPaymentsPlatformV2 = SharedFlags2.FFlagEnableMilkyWayPaymentsPlatformV2

local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies

return function(p, p2, p3, p4)
	if p == Enum.Platform.XBoxOne then
		return PaymentPlatform.Xbox
	end

	if p == Enum.Platform.IOS then
		if p2 then
			return PaymentPlatform.Midas
		end

		return PaymentPlatform.Apple
	elseif p == Enum.Platform.Windows or p == Enum.Platform.OSX or p == Enum.Platform.Linux then
		if FFlagEnablePioneerPaymentsPlatform and getIsPioneerBuild() then
			return PaymentPlatform.Pioneer
		end

		if
			FFlagEnableMicrosoftStorePaymentsPlatform
			and getAppFeaturePolicies().getUsePaymentPlatformMicrosoftStore()
		then
			return PaymentPlatform.Microsoft
		end

		return PaymentPlatform.Web
	elseif p == Enum.Platform.Android then
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
	else
		if p == Enum.Platform.UWP then
			return PaymentPlatform.UWP
		end

		if GetFFlagEnablePalisadesPaymentsPlatform() and (p == Enum.Platform.PS4 or p == Enum.Platform.PS5) then
			return PaymentPlatform.Palisades
		end

		return PaymentPlatform.None
	end
end
