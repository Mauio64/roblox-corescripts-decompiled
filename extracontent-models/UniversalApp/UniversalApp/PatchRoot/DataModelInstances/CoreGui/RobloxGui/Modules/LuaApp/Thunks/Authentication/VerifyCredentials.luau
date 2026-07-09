local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SetNetworkingErrorToast = require(Modules.LuaApp.Thunks.SetNetworkingErrorToast)
local AuthVerifyCredentials = require(Modules.LuaApp.Http.Requests.AuthVerifyCredentials)

return function(p1, p2, p3, p4) -- line: 7
	-- upvalues: AuthVerifyCredentials (copy), SetNetworkingErrorToast (copy)
	return function(p5) -- line: 8
		-- upvalues: AuthVerifyCredentials (copy), p1 (copy), p2 (copy), p3 (copy), p4 (copy), SetNetworkingErrorToast (copy)
		return AuthVerifyCredentials(p1, p2, p3, p4):andThen(nil, function(p6) -- line: 9
			-- upvalues: p5 (copy), SetNetworkingErrorToast (copy)
			p5:dispatch(SetNetworkingErrorToast(p6))
		end)
	end
end
