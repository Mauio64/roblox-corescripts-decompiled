local parent = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp").Parent

local Http = require(parent.Http)
local Url = Http.Url
local HttpRequest = require(script.Parent.HttpRequest)

local v = Url.APIS_URL .. "subscriptions/v2/referral-eligibility?"

return function(p: number)
	local v2 = v .. Url:makeQueryString({ referrerId = tostring(p) })

	return HttpRequest.new():get(v2):andThen(function(p2)
		if p2 and p2.eligibility == "Eligible" then
			return { eligible = true, reason = nil }
		end

		local reason

		if p2 then
			reason = p2.ineligibilityReason
		end

		return { eligible = false, reason = reason }
	end, function()
		return { eligible = false, reason = nil }
	end)
end
