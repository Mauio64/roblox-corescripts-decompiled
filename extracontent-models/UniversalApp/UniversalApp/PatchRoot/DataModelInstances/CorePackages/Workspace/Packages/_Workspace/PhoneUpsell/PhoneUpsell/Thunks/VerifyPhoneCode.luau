local HttpService = game:GetService("HttpService")
local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local PhoneUpsellParent = PhoneUpsell.Parent
local Promise = require(PhoneUpsellParent.Promise)
local PostVerifyPhoneCode = require(PhoneUpsell.Http.Requests.PostVerifyPhoneCode)

return function(p1, s1: string) -- line: 14
	-- upvalues: PostVerifyPhoneCode (copy), Promise (copy), HttpService (copy)
	return function() -- line: 15
		-- upvalues: PostVerifyPhoneCode (copy), p1 (copy), s1 (copy), Promise (copy), HttpService (copy)
		return PostVerifyPhoneCode(p1, s1):andThen(function(_) -- line: 16
			-- upvalues: Promise (copy)
			return Promise.resolve()
		end, function(p3) -- line: 18
			-- upvalues: HttpService (copy), Promise (copy)
			local n1 = 0

			if p3.Body then
				n1 = HttpService:JSONDecode(p3.Body).errors[1].code
			end

			return Promise.reject({
				ErrorCode = n1
			})
		end)
	end
end
