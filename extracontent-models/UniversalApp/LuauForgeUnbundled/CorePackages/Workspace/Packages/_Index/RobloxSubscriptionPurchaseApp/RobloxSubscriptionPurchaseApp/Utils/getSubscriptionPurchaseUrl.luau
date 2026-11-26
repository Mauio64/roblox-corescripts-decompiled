local ContentProvider = game:GetService("ContentProvider")

local fFlagEnablePlusReferralLandingSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SharedFlags").FFlagEnablePlusReferralLandingSheet

local function getSubscriptionPurchaseUrl(p2, p3, p4)
	local baseUrl = ContentProvider.BaseUrl
	local subscriptionPurchaseUrl

	if p3 then
		subscriptionPurchaseUrl = string.format(
			"%supgrades/paymentmethods?ctx=subscription&type=Blackbird&id=%s&paymentSessionId=%s",
			baseUrl,
			p2,
			p3
		)
	else
		subscriptionPurchaseUrl = string.format(
			"%supgrades/paymentmethods?ctx=subscription&type=Blackbird&id=%s",
			baseUrl,
			p2
		)
	end

	if fFlagEnablePlusReferralLandingSheet and p4 then
		subscriptionPurchaseUrl ..= "&referrerId=" .. tostring(p4)
	end

	return subscriptionPurchaseUrl
end

return getSubscriptionPurchaseUrl
