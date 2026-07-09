local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)
local ArgCheck = require(Modules.LuaApp.ArgCheck)
local AuthGetMetaDataRequest = require(Modules.Luobu.Http.Requests.AuthGetMetaDataRequest)
local SetTokenAuthErrMessageKey = require(Modules.Luobu.Actions.SetTokenAuthErrMessageKey)

return function(p1, p2, p3) -- line: 9
	-- upvalues: ArgCheck (copy), AuthGetMetaDataRequest (copy), Promise (copy), SetTokenAuthErrMessageKey (copy)
	ArgCheck.isType(p1, "table", "networkImpl")
	ArgCheck.isType(p3, "string", "authMethod")

	return function(p4) -- line: 13
		-- upvalues: AuthGetMetaDataRequest (copy), p1 (copy), p3 (copy), Promise (copy), SetTokenAuthErrMessageKey (copy), p2 (copy)
		return AuthGetMetaDataRequest(p1, p3):andThen(function(p5) -- line: 14
			-- upvalues: Promise (copy)
			return Promise.resolve(p5.responseBody)
		end, function(p6) -- line: 16
			-- upvalues: p4 (copy), SetTokenAuthErrMessageKey (copy), p2 (copy), Promise (copy)
			p4:dispatch(SetTokenAuthErrMessageKey("Authentication.Login.Response.TencentLoginFailurePleaseTryAgain"))
			p2.Diag:reportCounter("RequestAuthMetaDataFailure", 1)

			return Promise.reject(p6)
		end)
	end
end
