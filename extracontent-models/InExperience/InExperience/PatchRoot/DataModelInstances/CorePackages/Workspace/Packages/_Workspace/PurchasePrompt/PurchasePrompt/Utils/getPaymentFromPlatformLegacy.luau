local parent = script.Parent.Parent

local PaymentPlatform = require(parent.Enums.PaymentPlatform)
local FFlagEnablePioneerPaymentsPlatform = require(parent.Flags.FFlagEnablePioneerPaymentsPlatform)
local getIsPioneerBuild = require(parent.Utils.getIsPioneerBuild)

return function(p, p2, p3)
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

		return PaymentPlatform.Web
	elseif p == Enum.Platform.Android then
		if p2 then
			return PaymentPlatform.Midas
		end

		if p3 then
			return PaymentPlatform.Amazon
		end

		return PaymentPlatform.Google
	elseif p == Enum.Platform.UWP then
		return PaymentPlatform.UWP
	else
		return PaymentPlatform.None
	end
end
