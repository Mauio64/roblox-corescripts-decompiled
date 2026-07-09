local ParentParent = script.Parent.Parent
local PaymentPlatform = require(ParentParent.Enums.PaymentPlatform)

return function(p1, p2, p3) -- line: 5
	-- upvalues: PaymentPlatform (copy)
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
		return PaymentPlatform.Web
	end

	if p1 == Enum.Platform.Android then
		if p2 then
			return PaymentPlatform.Midas
		end

		if p3 then
			return PaymentPlatform.Amazon
		end

		return PaymentPlatform.Google
	end

	if p1 == Enum.Platform.UWP then
		return PaymentPlatform.UWP
	end

	return PaymentPlatform.None
end
