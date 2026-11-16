local url = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Http").Url
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Network/HttpRequest")

local v5 = url.APIS_URL .. "subscriptions/v2/referral-eligibility?"

return function(p2)
	local v6 = v5 .. url:makeQueryString({ referrerId = tostring(p2) })

	return HttpRequest.new():get(v6):andThen(function(p3)
		if p3 and p3.eligibility == "Eligible" then
			return { eligible = true, reason = nil }
		end

		local v8 = if p3 then p3.ineligibilityReason else nil
		return { eligible = false, reason = v8 }
	end, function()
		return { eligible = false, reason = nil }
	end)
end
