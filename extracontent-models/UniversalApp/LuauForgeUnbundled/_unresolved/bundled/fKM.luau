local HttpService = game:GetService("HttpService")

require("@luauforge/bundled/fJF")

local module = require("@luauforge/bundled/fJL")
local module2 = require("@luauforge/bundled/fKN")
require("@luauforge/bundled/fJj")
local module3 = require("@luauforge/bundled/fJH")

return function(p2, p3)
	return function()
		return module2(p2, p3):andThen(function()
			return { isError = false, data = {} }
		end, function(p4)
			local v5 = 0

			if p4.Body and p4.Body ~= "" then
				local success, result = pcall(HttpService.JSONDecode, HttpService, p4.Body)

				if success then
					local v6 = result.errors and result.errors[1]

					if v6 then
						v5 = v6.code
					end
				end
			end

			local unknownErrorKey = module3.UnknownErrorKey
			return {
				isError = true,
				errorCode = v5,
				errorKey = v5 == module.IdentifierInvalid and "Authentication.AccountRecovery.Message.Error.AccountNotFound" or unknownErrorKey
			}
		end)
	end
end
