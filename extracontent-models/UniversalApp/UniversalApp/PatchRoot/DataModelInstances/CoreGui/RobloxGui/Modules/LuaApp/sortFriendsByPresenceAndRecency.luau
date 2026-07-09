local Modules = game:GetService("CoreGui").RobloxGui.Modules
local User = require(Modules.LuaApp.Models.User)
local useLastOnlineForSort = require(Modules.LuaApp.sortFriendsUtilities).useLastOnlineForSort
local getFriendWeight = require(Modules.LuaApp.sortFriendsUtilities).getFriendWeight

return function(p1, p2) -- line: 7
	-- upvalues: getFriendWeight (copy), User (copy), useLastOnlineForSort (copy)
	local v7 = getFriendWeight(p1)
	local v8 = getFriendWeight(p2)

	if v7 == v8 then
		if p1.presence ~= User.PresenceType.OFFLINE and useLastOnlineForSort(p1.lastOnline, p2.lastOnline) then
			return p1.lastOnline > p2.lastOnline
		end

		return p1.name:lower() < p2.name:lower()
	end

	return v8 < v7
end
