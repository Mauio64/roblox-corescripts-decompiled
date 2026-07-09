local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent
local HttpService = game:GetService("HttpService")

require(AccountRecoveryParent.Http)

local ResetPasswordErrorCodes = require(AccountRecovery.Enums.ResetPasswordErrorCodes)
local PostResetPassword = require(AccountRecovery.Requests.PostResetPassword)

require(AccountRecovery.Common.AccountRecoveryRequestTypes)

local Constants = require(AccountRecovery.Components.Constants)

return function(p1, p2) -- line: 13
	-- upvalues: PostResetPassword (copy), Constants (copy), HttpService (copy), ResetPasswordErrorCodes (copy)
	return function() -- line: 14
		-- upvalues: PostResetPassword (copy), p1 (copy), p2 (copy), Constants (copy), HttpService (copy), ResetPasswordErrorCodes (copy)
		return PostResetPassword(p1, p2):andThen(function(p3) -- line: 15
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
			-- upvalues: HttpService (copy), Constants (copy), ResetPasswordErrorCodes (copy)
			local n1 = 0

			if p4.Body and p4.Body ~= "" then
				n1 = HttpService:JSONDecode(p4.Body).errors[1].code
			end

			local UnknownErrorKey = Constants.UnknownErrorKey

			if n1 == ResetPasswordErrorCodes.TooManyRequests then
				UnknownErrorKey = "Authentication.AccountRecovery.Message.Error.TooManyRequests"
			elseif n1 == ResetPasswordErrorCodes.InvalidPassword then
				UnknownErrorKey = "Authentication.AccountRecovery.Message.Error.InvalidPassword"
			elseif n1 == ResetPasswordErrorCodes.PasswordsDoNotMatch then
				UnknownErrorKey = "Authentication.AccountRecovery.MessagePasswordsDoNotMatch"
			elseif n1 == ResetPasswordErrorCodes.TwoStepVerificationRequired then
				UnknownErrorKey = Constants.UnknownErrorKey
			end

			return {
				isError = true,
				errorCode = n1,
				errorKey = UnknownErrorKey,
				errorRaw = HttpService:JSONDecode(p4.Body)
			}
		end)
	end
end
