local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent
local HttpService = game:GetService("HttpService")

require(AccountRecoveryParent.Http)

local AccountRecoveryErrorCodes = require(AccountRecovery.Enums.AccountRecoveryErrorCodes)
local PostVerifyBackupCode = require(AccountRecovery.Requests.PostVerifyBackupCode)

require(AccountRecovery.Common.AccountRecoveryRequestTypes)

local Constants = require(AccountRecovery.Components.Constants)

return function(p1, p2) -- line: 13
	-- upvalues: PostVerifyBackupCode (copy), Constants (copy), HttpService (copy), AccountRecoveryErrorCodes (copy)
	return function() -- line: 14
		-- upvalues: PostVerifyBackupCode (copy), p1 (copy), p2 (copy), Constants (copy), HttpService (copy), AccountRecoveryErrorCodes (copy)
		return PostVerifyBackupCode(p1, p2):andThen(function(p3) -- line: 15
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
				n1 = HttpService:JSONDecode(p4.Body).errors[1].code
			end

			local UnknownErrorKey = Constants.UnknownErrorKey

			if n1 == AccountRecoveryErrorCodes.InvalidCode then
				UnknownErrorKey = "Authentication.AccountRecovery.Message.Error.InvalidCode"
			end

			return {
				isError = true,
				errorCode = n1,
				errorKey = UnknownErrorKey
			}
		end)
	end
end
