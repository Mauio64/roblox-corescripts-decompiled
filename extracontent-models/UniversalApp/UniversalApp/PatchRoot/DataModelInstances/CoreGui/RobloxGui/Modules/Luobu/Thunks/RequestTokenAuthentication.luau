local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)
local ArgCheck = require(Modules.LuaApp.ArgCheck)
local TokenAuthenticationPostRequest = require(Modules.Luobu.Http.Requests.TokenAuthenticationPostRequest)
local SetTokenAuthErrMessageKey = require(Modules.Luobu.Actions.SetTokenAuthErrMessageKey)

return function(p1, p2, p3, p4) -- line: 9
	-- upvalues: ArgCheck (copy), TokenAuthenticationPostRequest (copy), Promise (copy), SetTokenAuthErrMessageKey (copy)
	ArgCheck.isType(p1, "table", "networkImpl")
	ArgCheck.isType(p3, "string", "authMethod")
	ArgCheck.isType(p4, "table", "body")

	return function(p5) -- line: 13
		-- upvalues: TokenAuthenticationPostRequest (copy), p1 (copy), p3 (copy), p4 (copy), Promise (copy), SetTokenAuthErrMessageKey (copy), p2 (copy)
		return TokenAuthenticationPostRequest(p1, p3, p4):andThen(function(p6) -- line: 14
			-- upvalues: Promise (copy)
			return Promise.resolve(p6.responseBody)
		end, function(p7) -- line: 16
			-- upvalues: p5 (copy), SetTokenAuthErrMessageKey (copy), p2 (copy), Promise (copy)
			p5:dispatch(SetTokenAuthErrMessageKey("Authentication.Login.Response.TencentLoginFailurePleaseTryAgain"))
			p2.Diag:reportCounter("TokenAuthenticationPostRequestFailure", 1)

			return Promise.reject(p7)
		end)
	end
end
