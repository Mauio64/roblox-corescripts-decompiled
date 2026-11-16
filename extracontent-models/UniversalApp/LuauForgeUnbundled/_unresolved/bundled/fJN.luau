local HttpService = game:GetService("HttpService")

require("@luauforge/bundled/fJF")

local module = require("@luauforge/bundled/fJO")
local module2 = require("@luauforge/bundled/fJP")
require("@luauforge/bundled/fJj")
local module3 = require("@luauforge/bundled/fJH")

return function(p2, p3)
	return function()
		return module2(p2, p3):andThen(function(p4)
			if p4 and p4.responseBody and p4.responseBody ~= "" then
				return { isError = false, data = p4.responseBody }
			end

			return { isError = true, errorCode = 0, errorKey = module3.UnknownErrorKey }
		end, function(p4)
			local v5 = (not p4.Body or p4.Body == "") and 0
				or HttpService:JSONDecode(p4.Body).errors[1].code

			local v6 = module3.UnknownErrorKey

			if v5 == module.TooManyRequests then
				v6 = "Authentication.AccountRecovery.Message.Error.TooManyRequests"
			elseif v5 == module.InvalidPassword then
				v6 = "Authentication.AccountRecovery.Message.Error.InvalidPassword"
			elseif v5 == module.PasswordsDoNotMatch then
				v6 = "Authentication.AccountRecovery.MessagePasswordsDoNotMatch"
			elseif v5 == module.TwoStepVerificationRequired then
				v6 = module3.UnknownErrorKey
			end

			return {
				isError = true,
				errorCode = v5,
				errorKey = v6,
				errorRaw = HttpService:JSONDecode(p4.Body)
			}
		end)
	end
end
