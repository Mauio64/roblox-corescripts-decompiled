local Parent = script:FindFirstAncestor("GameTile").Parent
local UserModel = require(Parent.UserLib).Models.UserModel
local t1 = {
	[UserModel.PresenceType.IN_GAME] = 3,
	[UserModel.PresenceType.ONLINE] = 2,
	[UserModel.PresenceType.IN_STUDIO] = 1,
	[UserModel.PresenceType.OFFLINE] = 0
}

local function useLastOnlineForSort(p1, p2) -- line: 12
	return typeof(p1) == "number" and (typeof(p2) == "number" and p1 ~= p2)
end
local function getFriendWeight(p3) -- line: 16
	-- upvalues: t1 (copy), UserModel (copy)
	local v9 = nil

	if p3 and p3.presence then
		v9 = t1[p3.presence]
	end

	if v9 == nil then
		v9 = t1[UserModel.PresenceType.OFFLINE]
	end

	return v9
end

return function(s1: string) -- line: 27
	-- upvalues: t1 (copy), UserModel (copy)
	return function(p4, p5) -- line: 28
		-- upvalues: t1 (copy), UserModel (copy), s1 (copy)
		local v13 = nil

		if p4 and p4.presence then
			v13 = t1[p4.presence]
		end

		if v13 == nil then
			v13 = t1[UserModel.PresenceType.OFFLINE]
		end

		local v14 = nil

		if p5 and p5.presence then
			v14 = t1[p5.presence]
		end

		if v14 == nil then
			v14 = t1[UserModel.PresenceType.OFFLINE]
		end

		if v13 == v14 then
			if p4.presence ~= UserModel.PresenceType.OFFLINE then
				local lastOnline = p4.lastOnline
				local lastOnline2 = p5.lastOnline

				if typeof(lastOnline) == "number" and (typeof(lastOnline2) == "number" and lastOnline ~= lastOnline2) then
					return p4.lastOnline > p5.lastOnline
				end
			end

			local v17 = p4[s1] or ""
			local v18 = p5[s1] or ""

			return v17:lower() < v18:lower()
		end

		return v14 < v13
	end
end
