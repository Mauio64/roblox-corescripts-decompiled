local HttpService = game:GetService("HttpService")
local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local parent = PhoneUpsell.Parent
local Promise = require(parent.Promise)
local PostVerifyPhoneCode = require(PhoneUpsell.Http.Requests.PostVerifyPhoneCode)

return function(p, p2: string)
	return function()
		return PostVerifyPhoneCode(p, p2):andThen(function(_)
			return Promise.resolve()
		end, function(p3)
			local errorCode = not p3.Body and 0 or HttpService:JSONDecode(p3.Body).errors[1].code

			return Promise.reject({ ErrorCode = errorCode })
		end)
	end
end
