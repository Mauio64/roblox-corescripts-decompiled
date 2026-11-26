local HttpService = game:GetService("HttpService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Promise")
local PostVerifyPhoneCode = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Http/Requests/PostVerifyPhoneCode")

return function(p2, p3)
	return function()
		return PostVerifyPhoneCode(p2, p3):andThen(function(p4)
			return Promise.resolve()
		end, function(p4)
			local v5 = not p4.Body and 0 or HttpService:JSONDecode(p4.Body).errors[1].code

			return Promise.reject({ ErrorCode = v5 })
		end)
	end
end
