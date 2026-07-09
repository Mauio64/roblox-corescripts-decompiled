local HttpService = game:GetService("HttpService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)
local PostVerifyPhoneNumber = require(Modules.LuaApp.Http.Requests.PostVerifyPhoneNumber)
local PhoneNumberVerificationErrorCodes = require(Modules.LuaApp.Enum.PhoneNumberVerificationErrorCodes)

return function(p1, p2, p3) -- line: 8
	-- upvalues: PostVerifyPhoneNumber (copy), HttpService (copy), PhoneNumberVerificationErrorCodes (copy), Promise (copy)
	return function(_) -- line: 9
		-- upvalues: PostVerifyPhoneNumber (copy), p1 (copy), p2 (copy), p3 (copy), HttpService (copy), PhoneNumberVerificationErrorCodes (copy), Promise (copy)
		return PostVerifyPhoneNumber(p1, p2, p3):andThen(function(p5) -- line: 10
			return {
				voucher = p5[1].voucher
			}
		end, function(p6) -- line: 16
			-- upvalues: HttpService (copy), PhoneNumberVerificationErrorCodes (copy), Promise (copy)
			local data = HttpService:JSONDecode(p6.Body)

			if data.errors[1].code == PhoneNumberVerificationErrorCodes.InvalidCode then
				return Promise.reject("Authentication.TwoStepVerification.Label.InvalidCode")
			end

			if data.errors[1].code == PhoneNumberVerificationErrorCodes.TooManyAttempts then
				return Promise.reject("Authentication.TwoStepVerification.Response.TooManyAttempts")
			end

			return Promise.reject("")
		end)
	end
end
