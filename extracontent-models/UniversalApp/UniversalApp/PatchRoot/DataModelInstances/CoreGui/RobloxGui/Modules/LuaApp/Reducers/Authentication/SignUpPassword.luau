local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SetSignUpPassword = require(Modules.LuaApp.Actions.Authentication.SetSignUpPassword)

return function(s1: string?, p1) -- line: 6
	-- upvalues: SetSignUpPassword (copy)
	local v5 = s1 or ""

	if p1.type == SetSignUpPassword.name then
		return p1.signupPassword
	end

	return v5
end
