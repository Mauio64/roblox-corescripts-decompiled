local urlBuilder = require("@luauforge/bundled/gWj").UrlBuilder
local urlBase = require("@luauforge/bundled/gWj").UrlBase

local HttpService = game:GetService("HttpService")

local v5 = urlBuilder.new({ base = urlBase.APIS, path = "subscriptions/v2/referrals" })

local function fetchPendingReferrals(callback)
	HttpService:RequestInternal({
		Url = v5() .. "?Status=1&PageSize=1",
		Method = "GET",
		Headers = { Accept = "application/json" }
	}):Start(function(p2, p3)
		if p3.StatusCode == 200 then
			local success, result = pcall(function()
				return HttpService:JSONDecode(p3.Body)
			end)

			if success and result and result.referrals and #result.referrals > 0 then
				local referral = result.referrals[1]
				local senderUserId = referral
					and referral.senderUserId
					and tonumber(referral.senderUserId)
					or nil
				callback({ hasPending = true, referrerId = senderUserId })
				return
			end
		end

		callback({ hasPending = false, referrerId = nil })
	end)
end

return fetchPendingReferrals
