local HttpService = game:GetService("HttpService")
local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local parent = PhoneUpsell.Parent
local Promise = require(parent.Promise)
local PostResendPhoneCode = require(PhoneUpsell.Http.Requests.PostResendPhoneCode)

return function(p)
	return function()
		return PostResendPhoneCode(p):andThen(function(_)
			return Promise.resolve()
		end, function(p2)
			local errorCode = not p2.Body and 0 or HttpService:JSONDecode(p2.Body).errors[1].code

			return Promise.reject({ ErrorCode = errorCode })
		end)
	end
end
