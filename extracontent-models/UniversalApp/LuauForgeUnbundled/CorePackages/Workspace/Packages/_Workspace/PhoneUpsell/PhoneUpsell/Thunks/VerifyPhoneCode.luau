local HttpService = game:GetService("HttpService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Promise")
local PostResendPhoneCode = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Http/Requests/PostResendPhoneCode")

return function(p2)
	return function()
		return PostResendPhoneCode(p2):andThen(function(p3)
			return Promise.resolve()
		end, function(p3)
			local v5 = not p3.Body and 0 or HttpService:JSONDecode(p3.Body).errors[1].code

			return Promise.reject({ ErrorCode = v5 })
		end)
	end
end
