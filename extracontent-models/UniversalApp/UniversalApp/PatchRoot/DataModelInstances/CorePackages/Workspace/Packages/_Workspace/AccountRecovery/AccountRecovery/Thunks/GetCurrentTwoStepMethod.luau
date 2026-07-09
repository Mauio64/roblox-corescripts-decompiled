local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent
local HttpService = game:GetService("HttpService")

require(AccountRecoveryParent.Http)

local AccountRecoveryErrorCodes = require(AccountRecovery.Enums.AccountRecoveryErrorCodes)
local GetCurrentTwoStepMethod = require(AccountRecovery.Requests.GetCurrentTwoStepMethod)

require(AccountRecovery.Common.AccountRecoveryRequestTypes)

local Constants = require(AccountRecovery.Components.Constants)

return function(p1, s1: string) -- line: 13
	-- upvalues: GetCurrentTwoStepMethod (copy), Constants (copy), HttpService (copy), AccountRecoveryErrorCodes (copy)
	return function() -- line: 14
		-- upvalues: GetCurrentTwoStepMethod (copy), p1 (copy), s1 (copy), Constants (copy), HttpService (copy), AccountRecoveryErrorCodes (copy)
		return GetCurrentTwoStepMethod(p1, s1):andThen(function(p2) -- line: 15
			-- upvalues: Constants (copy)
			if p2 and (p2.responseBody and p2.responseBody ~= "") then
				return {
					isError = false,
					data = p2.responseBody
				}
			end

			return {
				isError = true,
				errorCode = 0,
				errorKey = Constants.UnknownErrorKey
			}
		end, function(p3) -- line: 27
			-- upvalues: HttpService (copy), Constants (copy), AccountRecoveryErrorCodes (copy)
			local n1 = 0

			if p3.Body and p3.Body ~= "" then
				local ok, result = pcall(HttpService.JSONDecode, HttpService, p3.Body)

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
