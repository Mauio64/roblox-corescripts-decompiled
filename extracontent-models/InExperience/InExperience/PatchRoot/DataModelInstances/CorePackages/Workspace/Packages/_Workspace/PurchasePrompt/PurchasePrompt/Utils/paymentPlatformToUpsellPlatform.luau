local parent = script.Parent.Parent
local PaymentPlatform = require(parent.Enums.PaymentPlatform)

return function(p): string
	if p == PaymentPlatform.Web then
		return "Web"
	end

	if p == PaymentPlatform.Apple then
		return "AppleAppStore"
	end

	if p == PaymentPlatform.Google then
		return "GooglePlayStore"
	end

	if p == PaymentPlatform.Amazon then
		return "AmazonStore"
	end

	if p == PaymentPlatform.UWP then
		return "WindowsStore"
	end

	if p == PaymentPlatform.Xbox then
		return "XboxStore"
	end

	if p == PaymentPlatform.Maquettes then
		return "MaquettesStore"
	end

	if p == PaymentPlatform.Palisades then
		return "PalisadesStore"
	end

	if p == PaymentPlatform.Microsoft then
		return "MicrosoftStore"
	end

	if p == PaymentPlatform.MilkyWay then
		return "MilkyWayStore"
	end

	if p == PaymentPlatform.Pioneer then
		return "PioneerStore"
	end

	return "None"
end
