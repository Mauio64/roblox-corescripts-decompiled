local Modules = game:GetService("CoreGui").RobloxGui.Modules
local PostUsernameValid = require(Modules.LuaApp.Http.Requests.PostUsernameValid)
local Promise = require(Modules.LuaApp.Promise)
local SetNetworkingErrorToast = require(Modules.LuaApp.Thunks.SetNetworkingErrorToast)
local SetSignUpUsername = require(Modules.LuaApp.Actions.Authentication.SetSignUpUsername)

return function(p1, p2, p3, p4) -- line: 10
	-- upvalues: PostUsernameValid (copy), SetSignUpUsername (copy), Promise (copy), SetNetworkingErrorToast (copy)
	return function(p5) -- line: 11
		-- upvalues: PostUsernameValid (copy), p1 (copy), p2 (copy), p3 (copy), p4 (copy), SetSignUpUsername (copy), Promise (copy), SetNetworkingErrorToast (copy)
		return PostUsernameValid(p1, p2, p3, p4):andThen(function(p6) -- line: 13
			-- upvalues: p5 (copy), SetSignUpUsername (copy), p2 (copy), Promise (copy)
			if (p6 and (p6.responseBody and p6.responseBody.code)) == 0 then
				p5:dispatch(SetSignUpUsername(p2))

				return Promise.resolve()
			end

			return Promise.reject()
		end, function(p7) -- line: 22
			-- upvalues: p5 (copy), SetNetworkingErrorToast (copy), Promise (copy)
			p5:dispatch(SetNetworkingErrorToast(p7))

			return Promise.reject(p7)
		end)
	end
end
