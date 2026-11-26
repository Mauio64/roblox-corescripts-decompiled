local PaymentPlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PaymentPlatform")
local FFlagEnablePioneerPaymentsPlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagEnablePioneerPaymentsPlatform")
local getIsPioneerBuild = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getIsPioneerBuild")

return function(p2, p3, p4)
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

		return PaymentPlatform.Web
	elseif p2 == Enum.Platform.Android then
		if p3 then
			return PaymentPlatform.Midas
		end

		if p4 then
			return PaymentPlatform.Amazon
		end

		return PaymentPlatform.Google
	elseif p2 == Enum.Platform.UWP then
		return PaymentPlatform.UWP
	else
		return PaymentPlatform.None
	end
end
