local Modules = game:GetService("CoreGui").RobloxGui.Modules
local LoginStatus = require(Modules.LuaApp.Enum.LoginStatus)
local Logout = require(Modules.LuaApp.Thunks.Authentication.Logout)
local luaLogoutReasonNames = require(Modules.LuaApp.Analytics.Events.Auth.luaLogoutReasonNames)

return function(p1, p2, s1: string?) -- line: 8
	-- upvalues: LoginStatus (copy), Logout (copy), luaLogoutReasonNames (copy)
	return function(p3) -- line: 9
		-- upvalues: LoginStatus (copy), Logout (copy), p1 (copy), p2 (copy), luaLogoutReasonNames (copy), s1 (copy)
		if p3:getState().AuthenticationStatus.status == LoginStatus.LOGGED_IN then
			p3:dispatch(Logout(p1, p2, luaLogoutReasonNames.UnauthorizedResponse, s1))
		end
	end
end
