local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/egs")
local module2 = require("@luauforge/bundled/hMs")
local module3 = require("@luauforge/bundled/hMt")

return function(p2, p3)
	return module2(p2, p3):andThen(function(list)
		return { challenge = list[1].challenge }
	end, function(p4)
		local jsonDecode = HttpService:JSONDecode(p4.Body)

		if jsonDecode.errors[1].code == module3.TooManyAttempts then
			return module.reject("Authentication.TwoStepVerification.Response.TooManyAttempts")
		end

		if jsonDecode.errors[1].code == module3.PhoneNumberAlreadyLinked then
			return module.reject("Authentication.SignUp.Response.PhoneNumberAlreadyLinked")
		end

		if jsonDecode.errors[1].code == module3.InvalidPhoneNumber then
			return module.reject("Authentication.SignUp.Response.InvalidPhoneNumber")
		end

		return module.reject("")
	end)
end
