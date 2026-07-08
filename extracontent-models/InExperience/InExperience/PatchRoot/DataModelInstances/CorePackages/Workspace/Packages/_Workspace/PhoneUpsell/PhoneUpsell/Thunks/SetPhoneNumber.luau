local HttpService = game:GetService("HttpService")
local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local PhoneUpsellParent = PhoneUpsell.Parent
local Promise = require(PhoneUpsellParent.Promise)
local PostSetPhone = require(PhoneUpsell.Http.Requests.PostSetPhone)
local isStringPhone = require(PhoneUpsellParent.AuthCommon).Utils.isStringPhone

return function(p1, s1: string, s2: string, s3: string, s4: string?) -- line: 16
	-- upvalues: isStringPhone (copy), Promise (copy), PostSetPhone (copy), HttpService (copy)
	return function() -- line: 17
		-- upvalues: isStringPhone (copy), s2 (copy), s3 (copy), Promise (copy), PostSetPhone (copy), p1 (copy), s1 (copy), s4 (copy), HttpService (copy)
		if not isStringPhone(s2 .. s3) then
			return Promise.reject({
				PhoneRegexFailed = true
			})
		end

		return PostSetPhone(p1, s1, s2, s3, s4):andThen(function(_) -- line: 23
			-- upvalues: Promise (copy)
			return Promise.resolve()
		end, function(p3) -- line: 25
			-- upvalues: HttpService (copy), Promise (copy)
			local n1 = 0

			if p3.Body then
				n1 = HttpService:JSONDecode(p3.Body).errors[1].code
			end

			return Promise.reject({
				PhoneRegexFailed = false,
				ErrorCode = n1
			})
		end)
	end
end
