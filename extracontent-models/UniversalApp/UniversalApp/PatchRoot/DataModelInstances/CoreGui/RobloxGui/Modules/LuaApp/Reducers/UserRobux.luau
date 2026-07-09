local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Immutable = require(Modules.Common.Immutable)
local SetUserRobux = require(Modules.LuaApp.Actions.SetUserRobux)

return function(p1, p2) -- line: 5
	-- upvalues: SetUserRobux (copy), Immutable (copy)
	local v6 = p1 or {}

	if p2.type == SetUserRobux.name then
		v6 = Immutable.Set(v6, p2.userId, p2.robux)
	end

	return v6
end
