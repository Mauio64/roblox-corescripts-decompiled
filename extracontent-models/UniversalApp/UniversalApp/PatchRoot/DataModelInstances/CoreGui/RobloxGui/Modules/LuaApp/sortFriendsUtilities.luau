local Modules = game:GetService("CoreGui").RobloxGui.Modules
local User = require(Modules.LuaApp.Models.User)
local t1 = {
	[User.PresenceType.IN_GAME] = 3,
	[User.PresenceType.ONLINE] = 2,
	[User.PresenceType.IN_STUDIO] = 1,
	[User.PresenceType.OFFLINE] = 0
}

return {
	useLastOnlineForSort = function(p1, p2) -- line: 11
		return typeof(p1) == "number" and (typeof(p2) == "number" and p1 ~= p2)
	end,
	getFriendWeight = function(p3) -- line: 15
		-- upvalues: t1 (copy), User (copy)
		local v7 = nil

		if p3 and p3.presence then
			v7 = t1[p3.presence]
		end

		if v7 == nil then
			v7 = t1[User.PresenceType.OFFLINE]
		end

		return v7
	end
}
