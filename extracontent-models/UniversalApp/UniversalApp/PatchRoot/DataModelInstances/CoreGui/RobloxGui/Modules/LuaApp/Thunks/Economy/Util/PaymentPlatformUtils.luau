local Modules = game:GetService("CoreGui").RobloxGui.Modules
local PaymentPlatform = require(Modules.LuaApp.Enum.PaymentPlatform)

return {
	paymentPlatformToUpsellPlatform = function(p1) -- line: 6
		-- upvalues: PaymentPlatform (copy)
		if p1 == PaymentPlatform.Web then
			return "Web"
		end

		if p1 == PaymentPlatform.Apple then
			return "AppleAppStore"
		end

		if p1 == PaymentPlatform.Google then
			return "GooglePlayStore"
		end

		if p1 == PaymentPlatform.Amazon then
			return "AmazonStore"
		end

		if p1 == PaymentPlatform.UWP then
			return "WindowsStore"
		end

		if p1 == PaymentPlatform.Xbox then
			return "XboxStore"
		end

		if p1 == PaymentPlatform.Maquettes then
			return "MaquettesStore"
		end

		if p1 == PaymentPlatform.Palisades then
			return "PalisadesStore"
		end

		if p1 == PaymentPlatform.Microsoft then
			return "MicrosoftStore"
		end

		if p1 == PaymentPlatform.MilkyWay then
			return "MilkyWayStore"
		end

		return "None"
	end
}
