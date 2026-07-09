local LoginV2 = script:FindFirstAncestor("LoginV2")
local LoginV2Parent = LoginV2.Parent
local HttpService = game:GetService("HttpService")
local Promise = require(LoginV2Parent.Promise)
local AuthIdentifierErrorCodes = require(LoginV2.Enums.AuthIdentifierErrorCodes)
local PostInitializeLogin = require(LoginV2.Requests.PostInitializeLogin)

require(LoginV2.Common.LoginV2RequestTypes)

local v7 = game:DefineFastFlag("LoginV2EmailCredentialRequiredError", false)
local v8 = game:DefineFastFlag("LoginV2NoLoginMethodsError", false)

return function(p1, p2) -- line: 14
	-- upvalues: PostInitializeLogin (copy), Promise (copy), HttpService (copy), AuthIdentifierErrorCodes (copy), v7 (copy), v8 (copy)
	return function() -- line: 15
		-- upvalues: PostInitializeLogin (copy), p1 (copy), p2 (copy), Promise (copy), HttpService (copy), AuthIdentifierErrorCodes (copy), v7 (copy), v8 (copy)
		return PostInitializeLogin(p1, p2):andThen(function(p3) -- line: 16
			-- upvalues: Promise (copy)
			if p3 and p3.responseBody then
				return p3.responseBody
			end

			return Promise.reject()
		end, function(p4) -- line: 21
			-- upvalues: HttpService (copy), AuthIdentifierErrorCodes (copy), v7 (copy), v8 (copy), Promise (copy)
			local n1 = 0

			if p4.Body then
				n1 = HttpService:JSONDecode(p4.Body).errors[1].code
			end

			local s1 = "Authentication.Login.Response.SomethingWentWrong"

			if n1 == AuthIdentifierErrorCodes.InvalidUser then
				s1 = "Authentication.Login.Response.AccountNotFound"
			elseif v7 and n1 == AuthIdentifierErrorCodes.EmailCredentialRequired then
				s1 = "Authentication.Login.Response.EnterEmailForLoginCode"
			elseif v8 and n1 == AuthIdentifierErrorCodes.NoLoginMethods then
				s1 = "Authentication.Login.Response.NoLoginMethods"
			end

			return Promise.reject({
				errorCode = n1,
				errorKey = s1
			})
		end)
	end
end
