local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SetSignUpUsername = require(Modules.LuaApp.Actions.Authentication.SetSignUpUsername)

return function(s1: string?, p1) -- line: 6
	-- upvalues: SetSignUpUsername (copy)
	local v5 = s1 or ""

	if p1.type == SetSignUpUsername.name then
		return p1.signupUsername
	end

	return v5
end
