local HttpService = game:GetService("HttpService")

require("@luauforge/bundled/fJF")

local module = require("@luauforge/bundled/fJL")
local module2 = require("@luauforge/bundled/fKk")
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

			local unknownErrorKey = module3.UnknownErrorKey
			return {
				isError = true,
				errorCode = v5,
				errorKey = v5 == module.IdentifierInvalid and "Authentication.AccountRecovery.Message.Error.AccountNotFound" or v5 == module.TooManyRequests and "Authentication.AccountRecovery.Message.Error.TooManyRequests" or v5 == module.TryADifferentContactMethod and "Authentication.AccountRecovery.Message.Error.TryADifferentOne" or unknownErrorKey
			}
		end)
	end
end
