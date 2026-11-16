local userModel = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/UserLib").Models.UserModel

local v5 = {
	[userModel.PresenceType.IN_GAME] = 3,
	[userModel.PresenceType.ONLINE] = 2,
	[userModel.PresenceType.IN_STUDIO] = 1,
	[userModel.PresenceType.OFFLINE] = 0
}

local function useLastOnlineForSort(value, value2): boolean
	return typeof(value) == "number" and typeof(value2) == "number" and value ~= value2
end

local function getFriendWeight(p2)
	local friendWeight = if p2 and p2.presence then v5[p2.presence] else nil

	if friendWeight == nil then
		friendWeight = v5[userModel.PresenceType.OFFLINE]
	end

	return friendWeight
end

return function(p2)
	return function(p3, p4): boolean
		local v6 = if p3 and p3.presence then v5[p3.presence] else nil

		if v6 == nil then
			v6 = v5[userModel.PresenceType.OFFLINE]
		end

		local v7 = if p4 and p4.presence then v5[p4.presence] else nil

		if v7 == nil then
			v7 = v5[userModel.PresenceType.OFFLINE]
		end

		if v6 ~= v7 then
			return v7 < v6
		end

		if p3.presence ~= userModel.PresenceType.OFFLINE then
			local lastOnline = p3.lastOnline
			local lastOnline2 = p4.lastOnline
			local v8

			if typeof(lastOnline) == "number" and typeof(lastOnline2) == "number" then
				v8 = lastOnline ~= lastOnline2
			else
				v8 = false
			end

			if v8 then
				return p3.lastOnline > p4.lastOnline
			end
		end

		local v8 = p3[p2] or ""
		local v9 = p4[p2] or ""
		return v8:lower() < v9:lower()
	end
end
