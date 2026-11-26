local HttpService = game:GetService("HttpService")
local module = require("@luauforge/bundled/ggA")

local module2 = require("@luauforge/bundled/ggB")
local module3 = require("@luauforge/bundled/ggC")
require("@luauforge/bundled/ggE")

local defineFastFlag = game:DefineFastFlag("LoginV2EmailCredentialRequiredError", false)
local defineFastFlag2 = game:DefineFastFlag("LoginV2NoLoginMethodsError", false)

return function(p2, p3)
	return function()
		return module3(p2, p3):andThen(function(p4)
			if p4 and p4.responseBody then
				return p4.responseBody
			end

			return module.reject()
		end, function(p4)
			local v5 = not p4.Body and 0 or HttpService:JSONDecode(p4.Body).errors[1].code
			local v6

			if v5 == module2.InvalidUser then
				v6 = "Authentication.Login.Response.AccountNotFound"
			elseif defineFastFlag and v5 == module2.EmailCredentialRequired then
				v6 = "Authentication.Login.Response.EnterEmailForLoginCode"
			elseif defineFastFlag2 and v5 == module2.NoLoginMethods then
				v6 = "Authentication.Login.Response.NoLoginMethods"
			else
				v6 = "Authentication.Login.Response.SomethingWentWrong"
			end

			return module.reject({ errorCode = v5, errorKey = v6 })
		end)
	end
end
