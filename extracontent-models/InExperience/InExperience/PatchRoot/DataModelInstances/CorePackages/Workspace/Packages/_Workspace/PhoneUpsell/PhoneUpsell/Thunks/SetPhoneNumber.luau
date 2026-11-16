local HttpService = game:GetService("HttpService")
local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local parent = PhoneUpsell.Parent
local Promise = require(parent.Promise)
local PostSetPhone = require(PhoneUpsell.Http.Requests.PostSetPhone)
local AuthCommon = require(parent.AuthCommon)
local isStringPhone = AuthCommon.Utils.isStringPhone

return function(p, p2: string, p3: string, p4: string, p5: string?)
	return function()
		if isStringPhone(p3 .. p4) then
			return PostSetPhone(p, p2, p3, p4, p5):andThen(function(_)
				return Promise.resolve()
			end, function(p6)
				local errorCode = not p6.Body and 0 or HttpService:JSONDecode(p6.Body).errors[1].code

				return Promise.reject({ ErrorCode = errorCode, PhoneRegexFailed = false })
			end)
		end

		return Promise.reject({ PhoneRegexFailed = true })
	end
end
