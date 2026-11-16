local ContentProvider = game:GetService("ContentProvider")

local parent = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagEnablePlusReferralLandingSheet = SharedFlags.FFlagEnablePlusReferralLandingSheet

local function getSubscriptionPurchaseUrl(p: string, p2: string?, p3: number?)
	local baseUrl = ContentProvider.BaseUrl
	local subscriptionPurchaseUrl

	if p2 then
		subscriptionPurchaseUrl = string.format(
			"%supgrades/paymentmethods?ctx=subscription&type=Blackbird&id=%s&paymentSessionId=%s",
			baseUrl,
			p,
			p2
		)
	else
		subscriptionPurchaseUrl = string.format(
			"%supgrades/paymentmethods?ctx=subscription&type=Blackbird&id=%s",
			baseUrl,
			p
		)
	end

	if FFlagEnablePlusReferralLandingSheet and p3 then
		subscriptionPurchaseUrl ..= "&referrerId=" .. tostring(p3)
	end

	return subscriptionPurchaseUrl
end

return getSubscriptionPurchaseUrl
