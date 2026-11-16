local urlBuilder = require("@luauforge/bundled/gue").UrlBuilder
local urlBase = require("@luauforge/bundled/gue").UrlBase

local HttpService = game:GetService("HttpService")

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "subscriptions/v2/referral-eligibility"
})

local function fetchReferralEligibility(p2, callback)
	local v6 = v5()

	if p2 then
		v6 ..= "?referrerId=" .. tostring(p2)
	end

	HttpService:RequestInternal({
		Url = v6,
		Method = "GET",
		Headers = { Accept = "application/json" }
	}):Start(function(p3, p4)
		if p4.StatusCode == 200 then
			local success, result = pcall(function()
				return HttpService:JSONDecode(p4.Body)
			end)

			if success and result then
				callback(result.eligibility == "Eligible")
				return
			end
		end

		callback(false)
	end)
end

return fetchReferralEligibility
