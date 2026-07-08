local ContentProvider = game:GetService("ContentProvider")

local function getSubscriptionPurchaseUrl(s1: string, s2: string?) -- line: 3
	-- upvalues: ContentProvider (copy)
	local BaseUrl = ContentProvider.BaseUrl

	if s2 then
		return string.format("%supgrades/paymentmethods?ctx=subscription&type=Blackbird&id=%s&paymentSessionId=%s", BaseUrl, s1, s2)
	end

	return string.format("%supgrades/paymentmethods?ctx=subscription&type=Blackbird&id=%s", BaseUrl, s1)
end

return getSubscriptionPurchaseUrl
