local parent = script:FindFirstAncestor("GameTile").Parent
local UserLib = require(parent.UserLib)
local UserModel = UserLib.Models.UserModel

local v = {
	[UserModel.PresenceType.IN_GAME] = 3,
	[UserModel.PresenceType.ONLINE] = 2,
	[UserModel.PresenceType.IN_STUDIO] = 1,
	[UserModel.PresenceType.OFFLINE] = 0
}

local function useLastOnlineForSort(lastOnline, lastOnline2): boolean -- 1 equivalent call inferred from this helper
	return typeof(lastOnline) == "number" and typeof(lastOnline2) == "number" and lastOnline ~= lastOnline2
end

local function getFriendWeight(p) -- 2 equivalent calls inferred from this helper
	local friendWeight

	if p and p.presence then
		friendWeight = v[p.presence]
	end

	if friendWeight == nil then
		friendWeight = v[UserModel.PresenceType.OFFLINE]
	end

	return friendWeight
end

return function(p: string)
	return function(p2, p3): boolean
		local friendWeight = getFriendWeight(p2) -- inferred equivalent call
		local friendWeight2 = getFriendWeight(p3) -- inferred equivalent call

		if friendWeight ~= friendWeight2 then
			return friendWeight2 < friendWeight
		end

		if p2.presence ~= UserModel.PresenceType.OFFLINE and useLastOnlineForSort(p2.lastOnline, p3.lastOnline) then -- inferred equivalent call
			return p2.lastOnline > p3.lastOnline
		end

		local v2 = p2[p] or ""
		local v3 = p3[p] or ""
		return v2:lower() < v3:lower()
	end
end
