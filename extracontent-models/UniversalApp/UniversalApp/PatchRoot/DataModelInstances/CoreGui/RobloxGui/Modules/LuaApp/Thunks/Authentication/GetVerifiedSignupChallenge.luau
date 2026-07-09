local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Modules = CoreGui.RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)
local PostVerifiedSignupChallenge = require(Modules.LuaApp.Http.Requests.PostVerifiedSignupChallenge)
local PhoneNumberVerificationErrorCodes = require(Modules.LuaApp.Enum.PhoneNumberVerificationErrorCodes)

return function(p1, p2) -- line: 8
	-- upvalues: PostVerifiedSignupChallenge (copy), HttpService (copy), PhoneNumberVerificationErrorCodes (copy), Promise (copy)
	return PostVerifiedSignupChallenge(p1, p2):andThen(function(p3) -- line: 9
		return {
			challenge = p3[1].challenge
		}
	end, function(p4) -- line: 15
		-- upvalues: HttpService (copy), PhoneNumberVerificationErrorCodes (copy), Promise (copy)
		local data = HttpService:JSONDecode(p4.Body)

		if data.errors[1].code == PhoneNumberVerificationErrorCodes.TooManyAttempts then
			return Promise.reject("Authentication.TwoStepVerification.Response.TooManyAttempts")
		end

		if data.errors[1].code == PhoneNumberVerificationErrorCodes.PhoneNumberAlreadyLinked then
			return Promise.reject("Authentication.SignUp.Response.PhoneNumberAlreadyLinked")
		end

		if data.errors[1].code == PhoneNumberVerificationErrorCodes.InvalidPhoneNumber then
			return Promise.reject("Authentication.SignUp.Response.InvalidPhoneNumber")
		end

		return Promise.reject("")
	end)
end
