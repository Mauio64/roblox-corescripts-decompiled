local PaymentPlatform = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PaymentPlatform")

return function(p2): string
	if p2 == PaymentPlatform.Web then
		return "Web"
	end

	if p2 == PaymentPlatform.Apple then
		return "AppleAppStore"
	end

	if p2 == PaymentPlatform.Google then
		return "GooglePlayStore"
	end

	if p2 == PaymentPlatform.Amazon then
		return "AmazonStore"
	end

	if p2 == PaymentPlatform.UWP then
		return "WindowsStore"
	end

	if p2 == PaymentPlatform.Xbox then
		return "XboxStore"
	end

	if p2 == PaymentPlatform.Maquettes then
		return "MaquettesStore"
	end

	if p2 == PaymentPlatform.Palisades then
		return "PalisadesStore"
	end

	if p2 == PaymentPlatform.Microsoft then
		return "MicrosoftStore"
	end

	if p2 == PaymentPlatform.MilkyWay then
		return "MilkyWayStore"
	end

	if p2 == PaymentPlatform.Pioneer then
		return "PioneerStore"
	end

	return "None"
end
