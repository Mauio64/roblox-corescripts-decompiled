local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/egs")
local module2 = require("@luauforge/deferred/hVP")
local module3 = require("@luauforge/bundled/hMt")

return function(p2, p3, p4)
	return function(p5)
		return module2(p2, p3, p4):andThen(function(list)
			return { voucher = list[1].voucher }
		end, function(p6)
			local jsonDecode = HttpService:JSONDecode(p6.Body)

			if jsonDecode.errors[1].code == module3.InvalidCode then
				return module.reject("Authentication.TwoStepVerification.Label.InvalidCode")
			end

			if jsonDecode.errors[1].code == module3.TooManyAttempts then
				return module.reject("Authentication.TwoStepVerification.Response.TooManyAttempts")
			end

			return module.reject("")
		end)
	end
end
