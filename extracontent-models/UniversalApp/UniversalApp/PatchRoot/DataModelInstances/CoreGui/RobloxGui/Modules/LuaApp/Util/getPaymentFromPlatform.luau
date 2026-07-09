local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local PaymentPlatform = require(Modules.LuaApp.Enum.PaymentPlatform)
local GetFFlagEnablePalisadesPaymentsPlatform = require(Modules.LuaApp.Flags.GetFFlagEnablePalisadesPaymentsPlatform)
local FFlagEnableMicrosoftStorePaymentsPlatform = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableMicrosoftStorePaymentsPlatform
local FFlagEnableMilkyWayPaymentsPlatformV2 = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableMilkyWayPaymentsPlatformV2
local getAppFeaturePolicies = require(CorePackages.Workspace.Packages.UniversalAppPolicy).getAppFeaturePolicies

return function(p1, b1: boolean, b2: boolean) -- line: 15
	-- upvalues: PaymentPlatform (copy), FFlagEnableMicrosoftStorePaymentsPlatform (copy), getAppFeaturePolicies (copy), FFlagEnableMilkyWayPaymentsPlatformV2 (copy), GetFFlagEnablePalisadesPaymentsPlatform (copy)
	if p1 == Enum.Platform.XBoxOne then
		return PaymentPlatform.Xbox
	end

	if p1 == Enum.Platform.IOS then
		return PaymentPlatform.Apple
	end

	if p1 == Enum.Platform.Windows or p1 == Enum.Platform.OSX or p1 == Enum.Platform.Linux then
		if FFlagEnableMicrosoftStorePaymentsPlatform and getAppFeaturePolicies().getUsePaymentPlatformMicrosoftStore() then
			return PaymentPlatform.Microsoft
		end

		return PaymentPlatform.Web
	end

	if p1 == Enum.Platform.Android then
		if b1 then
			return PaymentPlatform.Amazon
		end

		if b2 then
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
