local LuaApp = game:GetService("CoreGui").RobloxGui.Modules.LuaApp
local User = require(LuaApp.Models.User)
local t1 = {
	[User.PresenceType.IN_GAME] = 3,
	[User.PresenceType.ONLINE] = 2,
	[User.PresenceType.IN_STUDIO] = 1,
	[User.PresenceType.OFFLINE] = 0
}

return function(p1, p2) -- line: 14
	-- upvalues: t1 (copy)
	local v6 = t1[p1.presence] or 0
	local v7 = t1[p2.presence] or 0

	if v6 == v7 then
		return p1.name:lower() < p2.name:lower()
	end

	return v7 < v6
end
