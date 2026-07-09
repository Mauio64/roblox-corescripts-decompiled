local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent
local HttpService = game:GetService("HttpService")

require(AccountRecoveryParent.Http)

local AccountRecoveryErrorCodes = require(AccountRecovery.Enums.AccountRecoveryErrorCodes)
local PostDisableTwoStepMethod = require(AccountRecovery.Requests.PostDisableTwoStepMethod)

require(AccountRecovery.Common.AccountRecoveryRequestTypes)

local Constants = require(AccountRecovery.Components.Constants)

return function(p1, p2) -- line: 13
	-- upvalues: PostDisableTwoStepMethod (copy), Constants (copy), HttpService (copy), AccountRecoveryErrorCodes (copy)
	return function() -- line: 14
		-- upvalues: PostDisableTwoStepMethod (copy), p1 (copy), p2 (copy), Constants (copy), HttpService (copy), AccountRecoveryErrorCodes (copy)
		return PostDisableTwoStepMethod(p1, p2):andThen(function(p3) -- line: 15
			-- upvalues: Constants (copy)
			if p3 and (p3.responseBody and p3.responseBody ~= "") then
				return {
					isError = false,
					data = p3.responseBody
				}
			end

			return {
				isError = true,
				errorCode = 0,
				errorKey = Constants.UnknownErrorKey
			}
		end, function(p4) -- line: 27
			-- upvalues: HttpService (copy), Constants (copy), AccountRecoveryErrorCodes (copy)
			local n1 = 0

			if p4.Body and p4.Body ~= "" then
				local ok, result = pcall(HttpService.JSONDecode, HttpService, p4.Body)

				if ok then
					local v14 = result.errors and result.errors[1]

					if v14 then
						n1 = v14.code
					end
				end
			end

			local UnknownErrorKey = Constants.UnknownErrorKey

			if n1 == AccountRecoveryErrorCodes.IdentifierInvalid then
				UnknownErrorKey = "Authentication.AccountRecovery.Message.Error.AccountNotFound"
			end

			return {
				isError = true,
				errorCode = n1,
				errorKey = UnknownErrorKey
			}
		end)
	end
end
