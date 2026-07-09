local Modules = game:GetService("CoreGui").RobloxGui.Modules
local GetPasswordValid = require(Modules.LuaApp.Http.Requests.GetPasswordValid)
local Promise = require(Modules.LuaApp.Promise)
local SetNetworkingErrorToast = require(Modules.LuaApp.Thunks.SetNetworkingErrorToast)
local SetSignUpPassword = require(Modules.LuaApp.Actions.Authentication.SetSignUpPassword)

return function(p1, p2, p3) -- line: 10
	-- upvalues: GetPasswordValid (copy), SetSignUpPassword (copy), Promise (copy), SetNetworkingErrorToast (copy)
	return function(p4) -- line: 11
		-- upvalues: GetPasswordValid (copy), p1 (copy), p2 (copy), p3 (copy), SetSignUpPassword (copy), Promise (copy), SetNetworkingErrorToast (copy)
		return GetPasswordValid(p1, p2, p3):andThen(function(p5) -- line: 15
			-- upvalues: p4 (copy), SetSignUpPassword (copy), p3 (copy), Promise (copy)
			if p5 and (p5.responseBody and p5.responseBody.code == 0) then
				p4:dispatch(SetSignUpPassword(p3))

				return Promise.resolve()
			end

			return Promise.reject()
		end, function(p6) -- line: 23
			-- upvalues: p4 (copy), SetNetworkingErrorToast (copy), Promise (copy)
			p4:dispatch(SetNetworkingErrorToast(p6))

			return Promise.reject(p6)
		end)
	end
end
